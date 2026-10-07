# ============================================================
# iam.tf
#
# IAM permissions specifically required outside the EKS
# module.
#
# The terraform-aws-modules/eks module creates:
#   - EKS cluster IAM role
#   - EKS node IAM role
#   - required standard policies
#
## ============================================================


# ------------------------------------------------------------
# Explicit EKS access entry
#
# This gives the IAM identity running Terraform administrative
# access to Kubernetes.
# ------------------------------------------------------------

resource "aws_eks_access_entry" "terraform_admin" {

  cluster_name = module.eks.cluster_name

  principal_arn = data.aws_caller_identity.current.arn

  type = "STANDARD"

}


resource "aws_eks_access_policy_association" "terraform_admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = data.aws_caller_identity.current.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.terraform_admin
  ]
}