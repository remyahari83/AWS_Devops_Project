aws-gitlab-runner-demo
Phase 1 – Cloud Infrastructure and EKS Setup

These steps configure the AWS environment with:

Public and private subnets
An Amazon EKS cluster
An EKS managed node group with two worker nodes
Required IAM permissions for GitLab-based Terraform deployment
Required IAM Access

GitLab Runner Instance Role

The GitLab Runner EC2 instance is assigned an IAM instance role. This role provides the AWS permissions required by the GitLab CI pipeline to perform infrastructure and EKS-related operations.

Terraform Admin – EKS Access

The terraform_admin EKS access entry is associated with the AmazonEKSClusterAdminPolicy at the cluster scope.

This allows the terraform-gitlab IAM identity used by the GitLab pipeline to perform Kubernetes administrative operations on the EKS cluster.

Execution

Push the changes to gitlab-ci.yml to trigger the GitLab CI pipeline and provision the infrastructure.