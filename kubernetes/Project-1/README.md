# Production grade EKS Cluster

- a big project to showcase what it looks like to host your applications in Kubernetes & expose them publicly securely via ingress controllers combined with signed SSL certs for HTTPS.

- We use tools like NGINX ingress controller, cert-manager with Let's encrypt to manage our certs, externalDNS to manage our DNS provider records

## The tools

The tools we will be using in this demo are:

- Helm (K9s package manager)
- NGINX Ingress Controller (ingress management)
- Let's Encrypt (Certificate authority)
- cert-manager (to automate certificate management)
- external-dns (automate & sync services with your DNS provider, in this case Route53)
- Add ArgoCD (optional)

## What we will do

- Set up AWS Resources: We'll kick things off by creating the necessary AWS resources, including a VPC and the EKS cluster

- Deploy Helm Charts: Next, we'll use Helm to deploy tools like cert-manager, NGINX Ingress Controller, and externalDNS.

- Deploy and Test Apps: We'll deploy a test app, set up ingress, and verify that everything works with HTTPS

- Bonus-ArgoCD Integration: We'll also touch on integrating ArgoCD to automate your deployments