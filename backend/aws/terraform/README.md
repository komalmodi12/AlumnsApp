# Alumns App - AWS Terraform Deployment

Production-ready Terraform configuration for deploying the Alumns App backend to AWS.

## Architecture

- **ECS Fargate**: Container orchestration (serverless)
- **Aurora PostgreSQL**: Database with multi-AZ failover
- **Application Load Balancer**: Traffic distribution
- **Auto-scaling**: CPU and memory-based scaling
- **CloudWatch**: Monitoring and logging

## Prerequisites

1. AWS Account with appropriate permissions
2. Terraform >= 1.0
3. Docker image pushed to ECR
4. S3 bucket for Terraform state (optional but recommended)

## Setup

### 1. Build and Push Docker Image

```bash
cd ../..

# Login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

# Build image
docker build -t alumns-api:latest .

# Tag image
docker tag alumns-api:latest \
  <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/alumns-api:latest

# Push image
docker push <ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/alumns-api:latest
```

### 2. Initialize Terraform

```bash
# Initialize (with S3 backend)
terraform init \
  -backend-config="bucket=terraform-state-<account-id>" \
  -backend-config="key=alumns-app/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="encrypt=true"

# Or without backend
terraform init
```

### 3. Create terraform.tfvars

```bash
cat > terraform.tfvars << EOF
aws_region       = "us-east-1"
environment      = "production"
app_name         = "alumns-app"
container_image  = "<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/alumns-api:latest"
jwt_secret       = "your-super-secret-key-min-32-chars"
db_password      = "YourSecureDBPassword123"
desired_count    = 2
ecs_task_cpu     = 256
ecs_task_memory  = 512
db_instance_class = "db.t3.small"
EOF
```

### 4. Plan and Apply

```bash
# Review changes
terraform plan -out=tfplan

# Apply
terraform apply tfplan
```

## Outputs

After deployment, Terraform will output:
- **alb_dns_name**: Base URL for your API
- **ecr_repository_url**: ECR repository for images
- **rds_endpoint**: Database endpoint
- **ecs_cluster_name**: ECS cluster name

## Post-Deployment

### Access API

```bash
curl http://<alb_dns_name>/health
```

### Setup Domain

1. Create Route53 hosted zone or use existing domain
2. Create CNAME record pointing to ALB DNS

### Enable HTTPS

1. Request ACM certificate or use existing
2. Update ALB listener to use HTTPS
3. Update security group to allow port 443

### Database Migration

Connect to the database and run migrations:

```bash
psql -h <rds_endpoint> -U alumns_user -d alumns_db < ../scripts/init.sql
```

## Monitoring

- **CloudWatch Logs**: `/ecs/alumns-app`
- **Container Insights**: View in ECS console
- **RDS Enhanced Monitoring**: CloudWatch metrics

## Scaling

Auto-scaling is configured:
- **Min tasks**: 2
- **Max tasks**: 4
- **CPU target**: 70%
- **Memory target**: 80%

## Costs

Estimated monthly costs (rough):
- ECS Fargate: ~$50-100
- Aurora PostgreSQL: ~$100-200
- ALB: ~$20
- Data transfer: Variable

## Cleanup

```bash
# Destroy all resources
terraform destroy
```

## Variables Reference

| Variable | Default | Description |
|----------|---------|-------------|
| aws_region | us-east-1 | AWS region |
| environment | production | Environment name |
| app_name | alumns-app | Application name |
| container_image | - | Docker image URI (required) |
| ecs_task_cpu | 256 | CPU units (256-4096) |
| ecs_task_memory | 512 | Memory MB (512-30720) |
| desired_count | 2 | Number of tasks |
| db_instance_class | db.t3.micro | RDS instance type |
| jwt_secret | - | JWT secret (required) |
| db_password | - | Database password (required) |

## Troubleshooting

### Tasks not starting
- Check CloudWatch logs
- Verify container image exists in ECR
- Check security groups and service configuration

### Database connection fails
- Verify RDS security group allows ECS task
- Check database credentials in Secrets Manager
- Verify VPC and subnet configuration

### ALB returns 502
- Check ECS task health
- Verify target group health checks
- Review container logs
