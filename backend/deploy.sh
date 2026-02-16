#!/bin/bash

set -e

echo "🚀 Alumns App - Production Deployment Guide"
echo "==========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check prerequisites
check_prerequisites() {
  echo "📋 Checking prerequisites..."
  
  local missing=0
  
  if ! command -v aws &> /dev/null; then
    echo -e "${RED}✗ AWS CLI not found${NC}"
    missing=1
  else
    echo -e "${GREEN}✓ AWS CLI${NC}"
  fi
  
  if ! command -v terraform &> /dev/null; then
    echo -e "${RED}✗ Terraform not found${NC}"
    missing=1
  else
    echo -e "${GREEN}✓ Terraform${NC}"
  fi
  
  if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker not found${NC}"
    missing=1
  else
    echo -e "${GREEN}✓ Docker${NC}"
  fi
  
  if [ $missing -eq 1 ]; then
    echo ""
    echo -e "${RED}Please install missing tools and try again${NC}"
    exit 1
  fi
  
  echo ""
}

# Step 1: Build Docker image
build_image() {
  echo "🐳 Building Docker image..."
  cd backend
  docker build -t alumns-api:latest .
  cd ..
  echo -e "${GREEN}✓ Docker image built${NC}"
  echo ""
}

# Step 2: Push to ECR
push_to_ecr() {
  echo "📤 Pushing image to AWS ECR..."
  
  # Get AWS account ID
  ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
  AWS_REGION="${AWS_REGION:-us-east-1}"
  ECR_REPO="$ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/alumns-api"
  
  # Login to ECR
  aws ecr get-login-password --region $AWS_REGION | \
    docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
  
  # Tag and push
  docker tag alumns-api:latest $ECR_REPO:latest
  docker tag alumns-api:latest $ECR_REPO:$(date +%s)
  docker push $ECR_REPO:latest
  
  echo -e "${GREEN}✓ Image pushed to ECR${NC}"
  echo ""
  echo "Image URI: $ECR_REPO:latest"
  echo ""
}

# Step 3: Deploy with Terraform
deploy_terraform() {
  echo "🏗️  Deploying infrastructure with Terraform..."
  
  cd backend/aws/terraform
  
  if [ ! -f terraform.tfvars ]; then
    echo -e "${YELLOW}⚠ terraform.tfvars not found${NC}"
    echo "Creating template..."
    cat > terraform.tfvars << EOF
aws_region            = "us-east-1"
environment           = "production"
app_name              = "alumns-app"
container_image       = "$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/alumns-api:latest"
jwt_secret            = "CHANGE_ME_TO_SECURE_SECRET"
db_password           = "CHANGE_ME_TO_SECURE_PASSWORD"
desired_count         = 2
ecs_task_cpu          = 256
ecs_task_memory       = 512
db_instance_class     = "db.t3.small"
EOF
    echo -e "${YELLOW}Please edit terraform.tfvars and run again${NC}"
    exit 1
  fi
  
  # Initialize Terraform
  terraform init
  
  # Plan
  terraform plan -out=tfplan
  
  # Apply
  echo ""
  read -p "Do you want to apply? (yes/no): " confirm
  if [ "$confirm" != "yes" ]; then
    echo "Cancelled"
    exit 1
  fi
  
  terraform apply tfplan
  
  # Get outputs
  echo ""
  echo -e "${GREEN}✓ Infrastructure deployed${NC}"
  echo ""
  echo "📌 Important Outputs:"
  terraform output
  
  cd ../../..
  echo ""
}

# Step 4: Setup GitHub Actions
setup_github_actions() {
  echo "🔐 Setting up GitHub Actions secrets..."
  
  ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
  
  echo ""
  echo "Add these secrets to your GitHub repository:"
  echo ""
  echo -e "${YELLOW}AWS_ACCESS_KEY_ID${NC}"
  echo "  - Generate in AWS IAM console"
  echo ""
  echo -e "${YELLOW}AWS_SECRET_ACCESS_KEY${NC}"
  echo "  - Generate in AWS IAM console"
  echo ""
  
  echo "Steps:"
  echo "1. Go to GitHub repo Settings → Secrets and variables → Actions"
  echo "2. Click 'New repository secret'"
  echo "3. Add AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY"
  echo ""
}

# Main execution
main() {
  check_prerequisites
  
  echo -e "${YELLOW}Select deployment steps:${NC}"
  echo "1. Build Docker image"
  echo "2. Push to ECR"
  echo "3. Deploy with Terraform"
  echo "4. Setup GitHub Actions"
  echo "5. Full deployment (1-3)"
  echo ""
  
  read -p "Enter choice (1-5): " choice
  
  case $choice in
    1) build_image ;;
    2) build_image && push_to_ecr ;;
    3) build_image && push_to_ecr && deploy_terraform ;;
    4) setup_github_actions ;;
    5) build_image && push_to_ecr && deploy_terraform && setup_github_actions ;;
    *) echo "Invalid choice" ;;
  esac
  
  echo ""
  echo -e "${GREEN}✓ Done!${NC}"
}

main
