# Provider Block - Tells the code which cloud provider we are working with and how
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2" # London. Config options let terraform authenticate and which region to deploy to.
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter { # filter blocks are used to specify what we want
    name   = "name"
    values = ["al2023-ami-20*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "network" {
  source      = "../../modules/network"
  common_tags = local.common_tags

  project = var.project
}

module "compute" {
  source = "../../modules/compute"

  project            = var.project
  common_tags        = local.common_tags
  public_subnet_id   = module.network.public_subnet_1_id
  private_subnet_id  = module.network.private_subnet_1_id
  ami_id             = data.aws_ami.al2023.id
  bastion_sg = module.network.bastion_sg
  private_sg = module.network.private_sg
}

module "onprem_network" {
  source = "../../modules/onprem_network"
}

module "transit_gateway" {
  source = "../../modules/transit_gateway"

  vpc_tei = module.network.vpc_tei
  tei_public_subnet = module.network.public_subnet_1_id
}