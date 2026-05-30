output "bastion_instance_id" {
  value = aws_instance.bastion_instance.id
}

output "bastion_private_ip" {
  value = aws_instance.bastion_instance.private_ip
}

output "private_instance_id" {
  value = aws_instance.private_instance.id
}

output "private_instance_private_ip" {
  value = aws_instance.private_instance.private_ip
}

output "private_ec2_role_name" {
  value = aws_iam_role.private_ec2_role.name
}
