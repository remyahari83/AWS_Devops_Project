terraform {
  backend "s3" {
    bucket = "aws-gitlab-terraform-state-12345"
    key    = "eks-project/terraform.tfstate"
    region = "us-east-1"
  }
}