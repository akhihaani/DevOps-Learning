terraform {
  backend "s3" {
    bucket         = "tei-bucket-1"
    key            = "environments/dev/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

# Tells Terraform to use S3 + DynamoDB backend.