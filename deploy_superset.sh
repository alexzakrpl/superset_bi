#!/bin/bash
set -e

# Redirect output to log file
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

# Step 2: Check Docker availability
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed or not in PATH. Exiting."
  exit 1
fi

# Step 3: Create required Docker volumes if missing
echo "Ensuring Docker volumes exist..."
docker volume inspect pg_data >/dev/null 2>&1 || docker volume create pg_data
docker volume inspect beat_data >/dev/null 2>&1 || docker volume create beat_data

# Step 4: Build images with no cache if needed
echo "Building Docker images..."
docker compose build --no-cache --pull

# Step 5: Run superset-init only
echo "Running Superset initialization (superset-init)..."
docker compose run --rm superset-init

# Step 6: Bring up all services
echo "Starting all Superset services..."
docker compose up -d --force-recreate

# Step 7: List running containers
echo "Currently running containers:"
docker compose ps

echo 'Loading example data...'
docker exec -it superset superset load-examples

echo -e "\nSuperset Production Deployment Completed Successfully!"
echo "Open Superset at: http://<host-ip>:8088 or http://localhost:8088"
echo "To stop the services, run: docker compose down"
