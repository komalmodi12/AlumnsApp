# Getting Started - Production Deployment

Complete guide to deploy Alumns App backend to AWS.

## Overview

This setup deploys your Node.js/Express API to **AWS ECS Fargate** with:
- **Load Balancing**: Application Load Balancer
- **Database**: Aurora PostgreSQL with high availability
- **Auto-scaling**: Based on CPU and memory
- **Monitoring**: CloudWatch logs and metrics
- **CI/CD**: GitHub Actions auto-deployment

## Prerequisites

Install these tools:

```bash
# macOS
brew install awscli terraform docker

# Windows (with Chocolatey)
choco install awscli terraform docker-desktop

# Linux
# Follow official documentation for your distribution
```

Create an AWS account and [generate IAM credentials](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html).

Configure AWS CLI:
```bash
aws configure
# Enter Access Key ID, Secret Access Key, region (us-east-1), format (json)
```

## Step 1: Quick Start (Automated)

Use the provided deployment script:

```bash
cd backend
chmod +x deploy.sh
./deploy.sh

# Select option 5 for full deployment
```

## Step 2: Manual Deployment

### Build and Push Docker Image

```bash
# Get AWS Account ID
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
AWS_REGION=us-east-1

# Build Docker image
cd backend
docker build -t alumns-api:latest .

# Login to ECR (Elastic Container Registry)
aws ecr get-login-password --region $AWS_REGION | \
  docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# Push image
docker tag alumns-api:latest $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/alumns-api:latest
docker push $ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/alumns-api:latest
```

### Deploy Infrastructure with Terraform

```bash
cd backend/aws/terraform

# Create configuration file
cat > terraform.tfvars << EOF
aws_region            = "us-east-1"
environment           = "production"
app_name              = "alumns-app"
container_image       = "$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/alumns-api:latest"
jwt_secret            = "$(openssl rand -base64 32)"
db_password           = "$(openssl rand -base64 24)"
desired_count         = 2
ecs_task_cpu          = 256
ecs_task_memory       = 512
db_instance_class     = "db.t3.small"
EOF

# Initialize and deploy
terraform init
terraform plan
terraform apply
```

### Get Your API URL

```bash
# After Terraform completes, get outputs
terraform output alb_dns_name

# Test the API
curl http://<alb_dns_name>/health
```

## Step 3: Setup CI/CD (GitHub)

### Add GitHub Secrets

1. Go to Your GitHub Repo → Settings → Secrets and variables → Actions
2. Create these secrets:

```
AWS_ACCESS_KEY_ID       → Your AWS access key
AWS_SECRET_ACCESS_KEY   → Your AWS secret key
```

Push code to main branch:
```bash
git push origin main
```

GitHub Actions will automatically build and deploy your app.

## Step 4: Post-Deployment

### Setup Domain Name

1. Update `ALLOWED_ORIGINS` in `.env`:
   ```
   ALLOWED_ORIGINS=https://yourdomain.com
   ```

2. Create Route53 record:
   ```bash
   aws route53 change-resource-record-sets \
     --hosted-zone-id <ZONE_ID> \
     --change-batch '{
       "Changes": [{
         "Action": "CREATE",
         "ResourceRecordSet": {
           "Name": "api.yourdomain.com",
           "Type": "CNAME",
           "TTL": 300,
           "ResourceRecords": [{"Value": "<ALB_DNS>"}]
         }
       }]
     }'
   ```

### Enable HTTPS

1. Request ACM certificate:
   ```bash
   aws acm request-certificate \
     --domain-name yourdomain.com \
     --domain-name api.yourdomain.com
   ```

2. Add HTTPS listener in Terraform (`aws/terraform/alb.tf`)
3. Redeploy: `terraform apply`

### Monitor Your App

```bash
# View logs
aws logs tail /ecs/alumns-app --follow

# Check service status
aws ecs describe-services \
  --cluster alumns-app-cluster \
  --services alumns-app

# View scaling metrics
aws cloudwatch get-metric-statistics \
  --namespace AWS/ECS \
  --metric-name CPUUtilization \
  --dimensions Name=ServiceName,Value=alumns-app \
  --start-time 2024-01-01T00:00:00Z \
  --end-time 2024-01-02T00:00:00Z \
  --period 300 \
  --statistics Average
```

## Cost Estimation

Monthly costs (approx):
- **ECS Fargate**: $50-100 (2 tasks, 256 CPU, 512 MB)
- **Aurora PostgreSQL**: $100-200 (1 DB, t3.small)
- **ALB**: $20
- **Data Transfer**: $0-50 (varies)

**Total**: $170-370/month

## Testing

### Test Endpoints

```bash
API="http://$(terraform output -raw alb_dns_name)"

# Health check
curl $API/health

# Login
curl -X POST $API/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}'

# Get profile (with token)
TOKEN=$(curl -s -X POST $API/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password"}' | jq -r .data.token)

curl -H "Authorization: Bearer $TOKEN" \
  $API/profile

# List posts
curl "$API/posts?page=1&limit=10"
```

## Troubleshooting

### Deployment failed
```bash
# Check Terraform state
terraform show

# Destroy and retry
terraform destroy
terraform apply
```

### App not responding
```bash
# Check ECS tasks
aws ecs list-tasks --cluster alumns-app-cluster
aws ecs describe-tasks \
  --cluster alumns-app-cluster \
  --tasks $(aws ecs list-tasks --cluster alumns-app-cluster --query taskArns[0] --output text)

# View service logs
aws logs tail /ecs/alumns-app --follow
```

### Database connection error
```bash
# Check RDS status
aws rds describe-db-clusters \
  --db-cluster-identifier alumns-app-db

# Verify security group
aws ec2 describe-security-groups \
  --filters "Name=group-name,Values=alumns-app-rds-sg"
```

## Cleanup

Remove all resources (⚠️ This deletes everything):

```bash
cd backend/aws/terraform
terraform destroy
```

## Next Steps

1. ✅ Set up monitoring alerts
2. ✅ Enable backups and snapshots
3. ✅ Setup auto-scaling policies
4. ✅ Configure WAF rules
5. ✅ Implement blue/green deployments
6. ✅ Add additional security headers

## Resources

- [AWS Documentation](https://docs.aws.amazon.com)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest)
- [Express.js Best Practices](https://expressjs.com)
- [PostgreSQL Documentation](https://www.postgresql.org/docs)
