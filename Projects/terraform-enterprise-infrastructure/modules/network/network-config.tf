# vpc, subnets, igw, nat, route tables, security groups, associations

# VPC
resource "aws_vpc" "vpc_tei" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = merge(var.common_tags, { Name = "tei-vpc" })
}

resource "aws_vpc_endpoint" "vpc_endpoint-ssm" {
  vpc_id            = aws_vpc.vpc_tei.id
  service_name      = "com.amazonaws.eu-west-2.ssm"
  vpc_endpoint_type = "Interface"

  subnet_ids          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, { Name = "tei-vpc-endpoint-ssm" })
}

resource "aws_vpc_endpoint" "vpc_endpoint-ssmmessages" {
  vpc_id            = aws_vpc.vpc_tei.id
  service_name      = "com.amazonaws.eu-west-2.ssmmessages"
  vpc_endpoint_type = "Interface"

  subnet_ids          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, { Name = "tei-vpc-endpoint-ssmmessages" })
}

resource "aws_vpc_endpoint" "vpc_endpoint-ec2messages" {
  vpc_id            = aws_vpc.vpc_tei.id
  service_name      = "com.amazonaws.eu-west-2.ec2messages"
  vpc_endpoint_type = "Interface"

  subnet_ids          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
  security_group_ids  = [aws_security_group.vpc_endpoint_sg.id]
  private_dns_enabled = true

  tags = merge(var.common_tags, { Name = "tei-vpc-endpoint-ec2messages" })
}

# Bastion security group
resource "aws_security_group" "bastion_sg" {
  name        = "tei-bastion-sg"
  vpc_id      = aws_vpc.vpc_tei.id

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "tei-bastion-sg" })
}

# Private instance security group
resource "aws_security_group" "private_sg" {
  name        = "tei-private-sg"
  vpc_id      = aws_vpc.vpc_tei.id

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "tei-private-sg" })
}

# VPC endpoint Security Group
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "tei-vpc-endpoint-sg"
  description = "Allow HTTPS from instances to Interface VPC Endpoints"
  vpc_id      = aws_vpc.vpc_tei.id

  ingress {
    description     = "HTTPS from private instance SG"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.private_sg.id]
  }

  ingress {
    description     = "HTTPS from bastion SG"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    description = "All outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, { Name = "tei-vpc-endpoint-sg" })
}

# Subnets

resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.vpc_tei.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { Name = "tei-subnet-public-2a" })
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.vpc_tei.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true

  tags = merge(var.common_tags, { Name = "tei-subnet-public-2b" })
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.vpc_tei.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "eu-west-2a"

  tags = merge(var.common_tags, { Name = "tei-subnet-private-2a" })
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.vpc_tei.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "eu-west-2b"

  tags = merge(var.common_tags, { Name = "tei-subnet-private-2b" })
}

# CloudWatch Logging
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/tei-flow-logs"
  retention_in_days = 30

  tags = merge(var.common_tags, { Name = "tei-vpc-flow-logs" })
}

resource "aws_flow_log" "vpc" {
  vpc_id               = aws_vpc.vpc_tei.id
  traffic_type         = "ALL"
  log_destination_type = "cloud-watch-logs"
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  iam_role_arn         = aws_iam_role.flow_logs_role.arn

  tags = merge(var.common_tags, { Name = "tei-vpc-flow-log" })
}

# IAM Role for Flow Logs
data "aws_iam_policy_document" "flow_logs_assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "flow_logs_role" {
  name               = "${var.project}-flow-logs-role"
  assume_role_policy = data.aws_iam_policy_document.flow_logs_assume.json
}

data "aws_iam_policy_document" "flow_logs_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["${aws_cloudwatch_log_group.vpc_flow_logs.arn}:*"]
  }
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  name   = "${var.project}-flow-logs-policy"
  role   = aws_iam_role.flow_logs_role.id
  policy = data.aws_iam_policy_document.flow_logs_permissions.json
}

# Internet Gateway

resource "aws_internet_gateway" "tei_internet_gateway" {
  vpc_id = aws_vpc.vpc_tei.id

  tags = merge(var.common_tags, { Name = "tei-igw" })
}


# Route Table - Traffic Rules

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc_tei.id
  tags   = merge(var.common_tags, { Name = "tei-private-route-table" })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc_tei.id

  route {
    cidr_block = "0.0.0.0/0"                                  # destination
    gateway_id = aws_internet_gateway.tei_internet_gateway.id # target
  }

  tags = merge(var.common_tags, { Name = "tei-public-route-table" })
}

# Route table Association - Which subnet uses those rules

resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}