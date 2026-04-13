#!/bin/bash

DOCKER_USER="rajkumartst"
IMAGE_DEV="$DOCKER_USER/react-app-dev"
IMAGE_PROD="$DOCKER_USER/react-app-prod"

echo "Building Docker Image..."
docker build -t react-app .

echo "Tagging Image..."
docker tag react-app $IMAGE_DEV

echo "Pushing to Docker Hub (DEV)..."
docker push $IMAGE_DEV