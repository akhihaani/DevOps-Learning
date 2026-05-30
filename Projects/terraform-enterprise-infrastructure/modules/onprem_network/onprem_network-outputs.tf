output "onprem_vpc" {
  value = aws_vpc.vpc_onprem.id
}

output "onprem_subnet" {
    value = aws_subnet.onprem_subnet.id
}