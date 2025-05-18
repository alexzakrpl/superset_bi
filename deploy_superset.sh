# This script automates the deployment of Apache Superset in a production environment on AWS EC2 using Docker.
# It includes steps for loading environment variables, checking Docker installation, creating required volumes,
# building Docker images, and starting the Superset services.
# It also logs all output to a log file for easier debugging and tracking of the deployment process.
#!/bin/bash
set -e

# Redirect all output to a log file
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

# Step 2: Check if Docker is installed and running
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed or not in PATH. Exiting."
  exit 1
fi

# Step 3: Create required docker volumes (only if they don't exist)
echo "Creating required Docker volumes..."
docker volume inspect pg_data >/dev/null 2>&1 || docker volume create pg_data
docker volume inspect beat_data >/dev/null 2>&1 || docker volume create beat_data

# Step 4: Build images
echo "Building Docker images..."
docker compose build

# Step 5: Bring up Superset services
echo "Starting Superset services..."
docker compose up -d

# Step 6: Show running containers
echo "Currently running containers:"
docker compose ps

echo -e "\nSuperset Production Deployment Completed Successfully!"
echo "To open Superset just open host ip:8088 or localhost at port 8088"

echo -e "\nTo stop the services, run: docker compose down"

