# ============================================================
# iam.tf
#
# IAM permissions for Terraform / GitLab Runner
#
# The GitLab Runner is an EC2 instance in the AWS default VPC.
#
# This role allows Terraform running on the Runner to:
#
#   - Create/manage EKS
#   - Manage EC2/VPC resources required by EKS
#   - Manage ECR
#   - Access Terraform state in S3
#   - Manage IAM roles/policies required by Terraform
#
# ============================================================


# ============================================================
# TERRAFORM / GITLAB RUNNER POLICY
# ============================================================

resource "aws_iam_policy" "terraform_eks_policy" {

  name = "${var.EKS_CLUSTER_NAME}-terraform-policy"

  description = "Permissions for GitLab Runner Terraform EKS deployment"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      # ======================================================
      # EKS
      # ======================================================

      {
        Effect = "Allow"

        Action = [
          "eks:*"
        ]

        Resource = "*"
      },


      # ======================================================
      # EC2 / VPC
      #
      # Required because Terraform creates the networking
      # infrastructure used by EKS.
      # ======================================================

      {
        Effect = "Allow"

        Action = [
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:CreateTags",
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:ReplaceRoute",
          "ec2:DeleteRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:CreateInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AllocateAddress",
          "ec2:ReleaseAddress",
          "ec2:CreateNatGateway",
          "ec2:DeleteNatGateway",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress"
        ]

        Resource = "*"
      },


      # ======================================================
      # IAM
      #
      # Terraform EKS module creates IAM roles and attaches
      # AWS managed policies.
      # ======================================================

      {
        Effect = "Allow"

        Action = [
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:UpdateRole",
          "iam:UpdateAssumeRolePolicy",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "iam:PassRole",
          "iam:CreatePolicy",
          "iam:DeletePolicy",
          "iam:CreateInstanceProfile",
          "iam:DeleteInstanceProfile",
          "iam:AddRoleToInstanceProfile",
          "iam:RemoveRoleFromInstanceProfile",
          "iam:TagRole",
          "iam:TagPolicy",
	  "s3:GetObject",
	  "s3:PutObject",
	  "s3:DeleteObject",
	  "s3:ListBucket"
        ]

        Resource = "*"
      },


      # ======================================================
      # ECR
      #
      # Required for your CRUD application pipeline.
      # ======================================================

      {
        Effect = "Allow"

        Action = [
          "ecr:GetAuthorizationToken"
        ]

        Resource = "*"
      },

      {
        Effect = "Allow"

        Action = [
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage",
          "ecr:BatchDeleteImage",
          "ecr:GetRepositoryPolicy",
          "ecr:SetRepositoryPolicy",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload"
        ]

        Resource = "arn:aws:ecr:${var.aws_region}:${data.aws_caller_identity.current.account_id}:repository/*"
      },


      # ======================================================
      # S3
      #
      # Terraform state bucket.
      # ======================================================

      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = "arn:aws:s3:::aws-gitlab-terraform-state-12345"
      },

      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = "arn:aws:s3:::aws-gitlab-terraform-state-12345/*"
      },


      # ======================================================
      # STS
      # ======================================================

      {
        Effect = "Allow"

        Action = [
          "sts:GetCallerIdentity"
        ]

        Resource = "*"
      }
    ]
  })
}


# ============================================================
# ATTACH POLICY TO EXISTING GITLAB RUNNER ROLE
# ============================================================
#
# Your existing Runner uses the IAM role:
#
#     instanceRole
#
# We attach the Terraform/EKS policy to that role.
#
# ============================================================

resource "aws_iam_role_policy_attachment" "terraform_eks_policy" {

  role = "instanceRole"

  policy_arn = aws_iam_policy.terraform_eks_policy.arn
}