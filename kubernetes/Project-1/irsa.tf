# Cert Manager IRSA (IAM roles for service accounts)

# This allows the created IAM role to be able to add records to the hosted zone

module "cert_manager_irsa_role" {
  # This is a registry submodule, so Terraform requires `//modules/...`.
  # Pinning the version keeps your code aligned with the tutorial/module API.
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.2.0"


  role_name                     = "cert_manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z09148692W990QKT2MM6V"] #Hosted Zone ID

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }

  tags = local.tags
}

# External DNS IRSA

module "external_dns_irsa_role" {
  # Same fix here: use `//modules/...` for a registry submodule path.
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.2.0"

  role_name                     = "external_dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z09148692W990QKT2MM6V"]

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["external-dns:external-dns"]
    }
  }

  tags = local.tags
}