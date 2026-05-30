output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}

output "vpc_endpoint_sg_id" {
  value = module.network.vpc_endpoint_sg_id
}

output "bastion_instance_id" {
  value = module.compute.bastion_instance_id
}

output "bastion_private_ip" {
  value = module.compute.bastion_private_ip
}

output "private_instance_id" {
  value = module.compute.private_instance_id
}

output "private_instance_private_ip" {
  value = module.compute.private_instance_private_ip
}

output "private_ec2_role_name" {
  value = module.compute.private_ec2_role_name
}


