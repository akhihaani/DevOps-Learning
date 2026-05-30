variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "common_tags" {
  type = map(string)
}

variable "project" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "private_sg" {
    type = string
}

variable "bastion_sg" {
    type = string
}