#!/bin/bash
set -e

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

# Step 2: Create required docker volumes (only if they don't exist)
echo "Creating required Docker volumes..."
docker volume inspect pg_data >/dev/null 2>&1 || docker volume create pg_data
docker volume inspect beat_data >/dev/null 2>&1 || docker volume create beat_data

# Step 3: Build images
echo "Building Docker images..."
docker compose build

# Step 4: Bring up Superset services
echo "Starting Superset services..."
docker compose up -d

# Step 5: Show running containers
echo "Currently running containers:"
docker compose ps

echo -e "\nSuperset Production Deployment Completed Successfully!"
echo "To open Superset just open host ip:8088 or localhost at port 8088"

echo -e "\nTo stop the services, run: docker compose down"
