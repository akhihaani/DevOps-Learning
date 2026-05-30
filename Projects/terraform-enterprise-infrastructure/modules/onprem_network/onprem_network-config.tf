# VPC
resource "aws_vpc" "vpc_onprem" {
  cidr_block       = "10.50.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = { Name = "onprem-vpc" }
}

# Subnets
resource "aws_subnet" "onprem_subnet" {
  vpc_id                  = aws_vpc.vpc_onprem.id
  cidr_block              = "10.50.1.0/24"
  availability_zone       = "eu-west-2a"

  tags = { Name = "onprem-subnet-public-2a" }
}