resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"

  create_namespace = true
  namespace        = "nginx-ingress"
}

resource "helm_release" "cert_manager" {
  name = "cert-manager"

  repository = "oci://quay.io/jetstack/charts"
  chart      = "cert-manager"
  version    = "v1.20.0"
  # the repo given in the documentation was for a helm install command
  # it needed to be split since this is a helm resource

  create_namespace = true
  namespace        = "cert-manager"

  # First entry: cert-manager waits for the IAM role to be created.
  # Second entry: installs the custom resource definitions.
  set = [
    {
      name  = "wait-for"
      value = module.cert_manager_irsa_role.iam_role_arn
    },
    {
      name  = "installCRDs"
      value = "true"
    },
  ]

  values = [
    "${file("helm-values/cert-manager.yaml")}"
  ]
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"

  create_namespace = true
  namespace        = "external-dns"

  set = [
    {
      name  = "wait-for"
      value = module.external_dns_irsa_role.iam_role_arn
    },
  ]

  values = [
    "${file("helm-values/external-dns.yaml")}"
  ]
}