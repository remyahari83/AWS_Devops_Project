module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"
  name = var.VPC_NAME
  cidr = var.VpcCIDR
  azs             = [var.Zone1, var.Zone2, var.Zone3]
  private_subnets = [var.PrivSub1CIDR, var.PrivSub2CIDR, var.PrivSub3CIDR]
  public_subnets  = [var.PubSub1CIDR, var.PubSub2CIDR, var.PubSub3CIDR]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  manage_default_network_acl = false
  # Automatically assign public IPv4 addresses
  # to instances launched in public subnets
  map_public_ip_on_launch = true
  tags = {
    Terraform   = "true"
    Environment = "Prod"
  }

  vpc_tags = {
    Name = var.VPC_NAME
  }
}

  # =========================================================
  # EKS SUBNET TAGS
  # =========================================================

resource "aws_ec2_tag" "public_subnet_elb" {
  for_each = toset(module.vpc.public_subnets)

  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "private_subnet_internal_elb" {
  for_each = toset(module.vpc.private_subnets)

  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}