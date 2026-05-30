locals {
  name   = "eks-lab"
  domain = "lab.test24app.work"
  region = "eu-west-2"

  tags = {
    Environment = "sandbox"
    Project     = "EKS Advanced Lab"
    Owner       = "akh-haani"
  }
}