#!/bin/bash

# Configuration
REGION="us-east-1"
CLUSTER_NAME="shopsmart-cluster"
SERVICE_NAME="shopsmart-service"
SERVER_REPO="shopsmart-server"
CLIENT_REPO="shopsmart-client"
TASK_FAMILY="shopsmart-task"

echo "Step 1: Creating ECR Repositories..."
aws ecr create-repository --repository-name "$SERVER_REPO" --region "$REGION" || echo "Server repository already exists"
aws ecr create-repository --repository-name "$CLIENT_REPO" --region "$REGION" || echo "Client repository already exists"

echo "Step 2: Creating ECS Cluster..."
aws ecs create-cluster --cluster-name "$CLUSTER_NAME" --region "$REGION"

echo "Step 3: Finding Network Configuration..."
VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" --query "Vpcs[0].VpcId" --output text)
SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC_ID" --query "Subnets[*].SubnetId" --output text | tr '\t' ',')
SG_ID=$(aws ec2 describe-security-groups --filters "Name=vpc-id,Values=$VPC_ID" "Name=group-name,Values=default" --query "SecurityGroups[0].GroupId" --output text)

echo "Step 4: Registering Initial Task Definition..."
aws ecs register-task-definition --cli-input-json file://task-definition.json --region "$REGION"

echo "Step 5: Creating ECS Service..."
NET_CONFIG="awsvpcConfiguration={subnets=[$SUBNETS],securityGroups=[$SG_ID],assignPublicIp=ENABLED}"
aws ecs create-service \
  --cluster "$CLUSTER_NAME" \
  --service-name "$SERVICE_NAME" \
  --task-definition "$TASK_FAMILY" \
  --desired-count 1 \
  --launch-type FARGATE \
  --network-configuration "$NET_CONFIG" \
  --region "$REGION" || echo "Service already exists"

echo "Infrastructure setup completed successfully."
