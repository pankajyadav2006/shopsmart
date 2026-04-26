#!/bin/bash

# Configuration
REGION="us-east-1" # Change this to your preferred region
CLUSTER_NAME="shopsmart-cluster"
SERVICE_NAME="shopsmart-service"
SERVER_REPO="shopsmart-server"
CLIENT_REPO="shopsmart-client"

echo "Step 1: Creating ECR Repositories..."
aws ecr create-repository --repository-name $SERVER_REPO --region $REGION || echo "Repository $SERVER_REPO already exists"
aws ecr create-repository --repository-name $CLIENT_REPO --region $REGION || echo "Repository $CLIENT_REPO already exists"

echo "Step 2: Creating ECS Cluster..."
aws ecs create-cluster --cluster-name $CLUSTER_NAME --region $REGION

echo "Infrastructure setup script completed."
echo "Please make sure to set up the following secrets in your GitHub repository:"
echo "- AWS_ACCESS_KEY_ID"
echo "- AWS_SECRET_ACCESS_KEY"
echo "- AWS_REGION"
