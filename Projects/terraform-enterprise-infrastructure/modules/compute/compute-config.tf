# bastion instance, private instance, security groups, outputs

# AWS Instances
resource "aws_instance" "bastion_instance" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg]
  associate_public_ip_address = true
  monitoring                  = true

  tags = merge(var.common_tags, { Name = "tei-bastion-instance" })
}

resource "aws_instance" "private_instance" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [var.private_sg]
  associate_public_ip_address = false
  monitoring                  = true
  iam_instance_profile        = aws_iam_instance_profile.private_ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              set -e

              LOG="/var/log/user-data.log"
              exec > >(tee -a "$LOG") 2>&1

              echo "User data started at: $(date -Is)"

              echo "Ensuring SSM agent is enabled"
              systemctl enable amazon-ssm-agent

              echo "Starting SSM agent"
              systemctl start amazon-ssm-agent

              echo "SSM agent status:"
              systemctl status amazon-ssm-agent --no-pager || true

              echo "User data finished at: $(date -Is)"
              EOF

  tags = merge(var.common_tags, { Name = "tei-private-instance" })
}

#IAM role + SSM
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "private_ec2_role" {
  name               = "${var.project}-private-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(var.common_tags, { Name = "tei-iam-role" })
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.private_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "private_ec2_profile" {
  name = "${var.project}-private-ec2-profile"
  role = aws_iam_role.private_ec2_role.name

  tags = merge(var.common_tags, { Name = "tei-instance-profile" })
}