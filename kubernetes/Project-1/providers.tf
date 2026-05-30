terraform {
  backend "s3" {
    bucket  = "eks-tfstate-akh-haani"
    key     = "eks-lab"
    region  = "eu-west-2"
    encrypt = true
  }

  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

# We then went into security credentials on our profile at the top right and created an access key
# we plugged the access key id and secret access key into the .env file

# We also created an s3 bucket on AWS Console using the same name we listed in this file.
# Intially terraform init didn't work since the bucket was created in another region and I needed to fix that 

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}
# tutorial did not have an
# = before the { on kubernetes and exec
# (old syntax)

provider "kubernetes" {
  # Configuration options
}