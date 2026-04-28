# CI/CD Deployment Guide: ECR & ECS

This guide documents how the project satisfies the requirements for the FSDE Assignment.

## Section 1: Amazon ECR (Container Registry)

### 1.1 ECR Repo Setup
A setup script is provided in `scripts/setup-aws.sh` which uses the AWS CLI to create the necessary repositories:
- `shopsmart-server`
- `shopsmart-client`

### 1.2 Image Pushed
The GitHub Actions workflow `.github/workflows/deploy-aws.yml` automatically builds and pushes Docker images to these ECR repositories on every push to the `main` branch.

### 1.3 Tagging Strategy
The workflow implements a dual-tagging strategy:
- **Unique Tag**: Uses the GitHub Commit SHA (`${{ github.sha }}`) for version tracking and rollback capability.
- **Latest Tag**: Updates the `latest` tag for the most recent successful build.

---

## Section 2: Amazon ECS (Container Orchestration)

### 2.1 ECS Cluster
The `scripts/setup-aws.sh` script includes the command to create an ECS Cluster named `shopsmart-cluster`.

### 2.2 Task Definition
A complete `task-definition.json` file is provided in the root directory. It defines:
- A Fargate task with two containers (server and client).
- Port mappings (5000 for server, 80 for client).
- CloudWatch logging configuration.
- Resource limits (CPU/Memory).

### 2.3 Service Running
The CI/CD pipeline uses the `amazon-ecs-deploy-task-definition` action to update the ECS service, ensuring the new task definition is deployed and the service is kept running with the latest images.

---

## Section 3: CI/CD Pipeline (GitHub Actions -> ECR -> ECS)

### 3.1 Dockerfile
- **Server**: A `Dockerfile` in `/server` (fixed with correct `FROM` instruction).
- **Client**: A production-ready multi-stage `Dockerfile` in `/client` using Nginx to serve the built assets.

### 3.2 Workflow File
The workflow file is located at `.github/workflows/deploy-aws.yml`.

### 3.3 Build & Push
The `deploy` job in the workflow handles:
1. Building Docker images for both services.
2. Pushing them to Amazon ECR.

### 3.4 Full Automation
The pipeline is fully automated. Once AWS secrets are configured in GitHub, a simple `git push origin main` will:
1. Build images.
2. Push to ECR.
3. Update Task Definition with new image URIs.
4. Deploy to ECS and wait for stability.

---

## Setup Instructions

1. **AWS Infrastructure**:
   Run the setup script (requires AWS CLI configured):
   ```bash
   chmod +x scripts/setup-aws.sh
   ./scripts/setup-aws.sh
   ```

2. **GitHub Secrets**:
   Add the following secrets to your GitHub repository (`Settings > Secrets and variables > Actions`):
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION` (e.g., `us-east-1`)
