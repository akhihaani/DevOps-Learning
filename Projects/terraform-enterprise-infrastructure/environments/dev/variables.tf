variable "project" {
  description = "Project tag applied to all resources"
  type        = string
  default     = "terraform-enterprise-lab"
}

variable "environment" {
  description = "Environment tag applied to all resources"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "Owner tag applied to all resources"
  type        = string
}
