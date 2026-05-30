resource "kubernetes_manifest" "clusterIssuer" {
  manifest = {
"apiVersion" = "cert-manager.io/v1"
"kind" = "ClusterIssuer"
"metadata" = {
  name = "letsencrypt-dns01"
           }
"spec" = {
  acme = {
    server = "https://acme-v02.api.letsencrypt.org/directory"
    email = "akhihaani@gmail.com"
    privateKeySecretRef = {
      name = "letsencrypt-dns01-account-key"
  }
    solvers = [
    { dns01 = {
        route53 = {
          # AWS region where your Route53 hosted zone resides
          region = "eu-west-2"

          # When using IRSA, no need to specify credentials
          # cert-manager uses the service account's IAM role
        }
        }
        }
        ]
      }
    }
  }
}