# Provider Block - Tells the code which cloud provider we are working with and how
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }
  }
}

provider "aws" {
  region = var.region # London. Config options let terraform authenticate and which region to deploy to.
}


# Using the default VPC + default subnet to avoid building networking.
data "aws_vpc" "default" { # data is a block type that looks up information to reference in the file
  default = true
}

data "aws_subnets" "default" { # second part is the data source type, third part is the name I have given the block
  filter {
    name   = "vpc-id" # name is the attribute you are using to filter subnets
    values = [data.aws_vpc.default.id] # the value of the attribute
  }
}

# Latest Amazon Linux 2023 AMI
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter { # filter blocks are used to specify what we want
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group
resource "aws_security_group" "wp_sg" { # resource means we are creating/managing something
  name        = "ci-sg"
  vpc_id      = data.aws_vpc.default.id

  ingress { # ingress means incoming traffic rules
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { # outbound traffic rules
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wp-sg"
  }
}


# AWS Instance
resource "aws_instance" "cloud-init_Instance" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.wp_sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/cloud-init.yaml") # User data is collected from the cloud init file

  tags = {
    Name = "assignment-2-cloud-init"
  }
}
