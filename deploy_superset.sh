#!/bin/bash
set -e

exec > >(tee -a /var/log/superset_deploy.log) 2>&1

echo "Starting Superset Production Deployment..."

# Step 1: Load environment variables
if [ -f ".env" ]; then
  echo "Loading environment variables from .env file..."
  set -a
  source .env
  set +a
else
  echo "No .env file found. Exiting."
  exit 1
fi

# Step 2: Check Docker
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed. Exiting."
  exit 1
fi

# Step 3: Ensure volumes
docker volume inspect pg_data >/dev/null 2>&1 || docker volume create pg_data
docker volume inspect beat_data >/dev/null 2>&1 || docker volume create beat_data

# Step 4: Build
docker compose build --no-cache --pull

# Step 5: Run initialization
docker compose run --rm superset-init

# Step 6: Start all services
docker compose up -d --force-recreate

# Step 7: Wait for Superset to be ready
echo "Waiting for Superset container to become healthy..."
for i in {1..30}; do
  status=$(docker inspect -f '{{.State.Health.Status}}' superset 2>/dev/null || echo "not_found")
  echo "Health status: $status"
  if [ "$status" = "healthy" ]; then
    echo "Superset is healthy."
    break
  fi
  sleep 5
done

# Step 8: Load example data
echo "Loading example data..."
docker exec -i superset superset load-examples || echo "Failed to load examples."

# Step 9: Succsess message
echo -e "\nSuperset Production Deployment Completed Successfully!"
echo "Open Superset at: http://<host-ip>:8088 or http://localhost:8088"
echo "To stop the services, run: docker compose down"
