terraform {
  backend "s3" {
    bucket = "aws-gitlab-terraform-state-12345"
    key    = "eks-bluegreen/terraform.tfstate"
    region = "us-east-1"
  }
}