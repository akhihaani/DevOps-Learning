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
  name        = "wp-sg"
  description = "Allow web + ssh"
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
resource "aws_instance" "wordpress" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnets.default.ids[0]
  vpc_security_group_ids      = [aws_security_group.wp_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    dnf -y update # dnf is the package manager. -y means 'yes' to all prompts.
    dnf -y install httpd php php-mysqlnd mariadb105-server wget tar # first four are packages. wget is for downloading files, and tar is for un/archiving files
    # php is a scripting language. php-mysqlnd is the driver that allows php to interact with the database
    # mariadb105-server is the database


    systemctl enable --now mariadb # systemctl is a command that manages services on linux. We are running mariadb and httpd now and upon reboot.
    systemctl enable --now httpd

    mysql -e "CREATE DATABASE wordpress;"
    mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'wp_password_123';"
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
    # Created a database, created a user with password, gave user all permissions, made sure all changes stay

    cd /var/www/html
    wget -q https://wordpress.org/latest.tar.gz
    tar -xzf latest.tar.gz
    cp -r wordpress/* /var/www/html/
    rm -rf wordpress latest.tar.gz
    # moving into the html file, downloaded the wordpress tar file, unarchived it and copied it into html file then removed the original wordpress download

    chown -R apache:apache /var/www/html
    chmod -R 755 /var/www/html
    # chown changes ownership, chmod changes permissions. -R makes command recursive, everything in the directory gets the same treatment

    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/wordpress/" wp-config.php
    sed -i "s/username_here/wpuser/" wp-config.php
    sed -i "s/password_here/wp_password_123/" wp-config.php
    # sed -i means it edits the file in-place so the changes are saved in the original file
    # when extracting wordpress's code we get the sample config which we can then use

    systemctl restart httpd # restart webserver after all changes
  EOF

  tags = {
    Name = "assignment-1-wordpress"
  }
}
