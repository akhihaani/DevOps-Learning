output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id
  ]
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

output "private_subnet_1_id" {
  value = aws_subnet.private_subnet_1.id
}

output "public_subnet_1_id" {
  value = aws_subnet.public_subnet_1.id
}

output "vpc_endpoint_sg_id" {
  value = aws_security_group.vpc_endpoint_sg.id
}

output "bastion_sg" {
    value = aws_security_group.bastion_sg.id
}

output "private_sg" {
    value = aws_security_group.private_sg.id
}

output "vpc_tei" {
  value = aws_vpc.vpc_tei.id
}