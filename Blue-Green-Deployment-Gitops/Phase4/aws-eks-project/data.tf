# =========================================================
# AWS Account
# =========================================================

data "aws_caller_identity" "current" {}

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


data "tls_certificate" "eks_oidc" {
  url = module.eks.cluster_oidc_issuer_url
}
