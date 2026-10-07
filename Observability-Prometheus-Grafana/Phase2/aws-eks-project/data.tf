# ============================================================
# data.tf
# Phase 1 - EKS foundation
# ============================================================

# Current AWS account / IAM principal
data "aws_caller_identity" "current" {}

# Current AWS region
data "aws_region" "current" {}

# Available AZs in the selected region
data "aws_availability_zones" "available" {
  state = "available"
}

#===============================================================
# deployment
#================================================================
data "aws_eks_cluster" "this" {
  name = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}
#==============================================================