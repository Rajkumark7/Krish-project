#!/bin/bash

DOCKER_USER="rajkumartst"
IMAGE_PROD="$DOCKER_USER/react-app-prod"

echo "Pulling latest image..."
docker pull $IMAGE_PROD

echo "Stopping old container..."
docker stop react-container || true
docker rm react-container || true

echo "Running new container..."
docker run -d -p 80:80 --name react-container $IMAGE_PROD