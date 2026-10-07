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