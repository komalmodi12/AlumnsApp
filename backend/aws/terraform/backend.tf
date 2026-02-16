terraform {
  backend "s3" {
    # Configure these values or use terraform backend config flags
    # Example: terraform init -backend-config="bucket=my-terraform-state" -backend-config="key=alumns-app/terraform.tfstate" -backend-config="region=us-east-1"
  }
}
