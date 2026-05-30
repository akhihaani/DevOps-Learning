output "wordpress_public_ip" { # output block is a way for terraform to give you key information at the end of the report
  value = aws_instance.cloud-init_Instance.public_ip
}

output "wordpress_url" {
  value = "http://${aws_instance.cloud-init_Instance.public_ip}"
}