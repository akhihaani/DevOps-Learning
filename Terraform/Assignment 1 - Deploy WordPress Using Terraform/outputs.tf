output "wordpress_public_ip" { # output block is a way for terraform to give you key information at the end of the report
  value = aws_instance.wordpress.public_ip
}

output "wordpress_url" {
  value = "http://${aws_instance.wordpress.public_ip}"
}