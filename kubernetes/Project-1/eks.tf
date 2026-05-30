module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"

  # In v21 of the module, `cluster_name` was renamed to `name`.
  name = local.name

  # `cluster_version` was renamed to `kubernetes_version`.
  # 1.35 is a current EKS standard-support version as of 2026-03-26.
  kubernetes_version = "1.35"

  # In v21, the endpoint arguments dropped the `cluster_` prefix.
  # Leaving public access enabled matches the original tutorial behavior.
  endpoint_public_access       = true
  endpoint_public_access_cidrs = ["0.0.0.0/0"]

  # Keep IRSA enabled because `irsa.tf` depends on the cluster's OIDC provider.
  enable_irsa = true

  # This grants the IAM identity running Terraform cluster-admin access.
  # It makes first-time access easier with newer EKS access management.
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id # I faced an error when i wrote module.vpc.id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # In older module versions, these settings often lived in
  # `eks_managed_node_group_defaults`.
  # In your installed v21 module, that input is no longer exposed, so the node
  # group settings need to be defined directly inside each node group.
  # Cluster addons are AWS-managed plugins that handle core Kubernetes networking.
  # These four are the standard set every EKS cluster needs.
  # `before_compute = true` means EKS installs that addon before launching any
  # nodes — critical for vpc-cni, since nodes can't get a VPC IP (and therefore
  # can't register with the cluster) until the CNI plugin is ready.
  addons = {
    # Assigns real AWS VPC IP addresses to nodes and pods so they can
    # communicate within the cluster network. Must be ready before nodes boot.
    vpc-cni = {
      before_compute = true
    }

    # Handles DNS resolution inside the cluster (e.g. service discovery).
    coredns = {}

    # Manages iptables rules on each node so traffic reaches the right pod.
    kube-proxy = {}

    # Enables EKS Pod Identity — a newer way to give pods AWS IAM permissions
    # without IRSA. Must be ready before nodes boot.
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    default = {
      # Keep the same worker node disk size from the tutorial.
      disk_size = 50

      # Keep the same instance families, but place them on the actual node
      # group because this module version expects per-node-group settings.
      instance_types = ["t3a.large", "t3.large"]
    }
  }

  tags = local.tags
}