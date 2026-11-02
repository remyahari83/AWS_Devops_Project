# ============================================================
# EKS CLUSTER
# ============================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.EKS_CLUSTER_NAME
  kubernetes_version = var.EKS_VERSION

  # ----------------------------------------------------------
  # Networking
  # ----------------------------------------------------------

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # ----------------------------------------------------------
  # Kubernetes API endpoint
  # ----------------------------------------------------------

  endpoint_public_access  = true
  endpoint_private_access = true

  # Terraform IAM identity receives access through
  # aws_eks_access_entry in eks_iam.tf.
  enable_cluster_creator_admin_permissions = false

  # ----------------------------------------------------------
  # EKS managed add-ons
  # ----------------------------------------------------------

  addons = {
    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

    kube-proxy = {
      most_recent = true
    }

    coredns = {
      most_recent = true
    }
  }

  # ----------------------------------------------------------
  # Managed node group
  # ----------------------------------------------------------

  eks_managed_node_groups = {
    application = {
      instance_types = [var.EKS_NODE_INSTANCE_TYPE]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }

  # ----------------------------------------------------------
  # Tags
  # ----------------------------------------------------------

  tags = {
    Environment = "prod"
    Project     = "eks-cicd-gitops"
    Terraform   = "true"
  }
}