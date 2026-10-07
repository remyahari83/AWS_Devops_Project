module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.7.3"

  name = var.VPC_NAME
  cidr = var.VpcCIDR

  azs = [
    var.Zone1,
    var.Zone2,
    var.Zone3
  ]

  private_subnets = [
    var.PrivSub1CIDR,
    var.PrivSub2CIDR,
    var.PrivSub3CIDR
  ]

  public_subnets = [
    var.PubSub1CIDR,
    var.PubSub2CIDR,
    var.PubSub3CIDR
  ]

  # ---------------------------------------------------------
  # NAT
  # ---------------------------------------------------------
  #
  # Keep this initially for reliable EKS operation.
  # Later we can replace this with VPC endpoints.
  #
  enable_nat_gateway = true
  single_nat_gateway = true

  # ---------------------------------------------------------
  # DNS
  # ---------------------------------------------------------

  enable_dns_hostnames = true
  enable_dns_support   = true

  # ---------------------------------------------------------
  # Default Network ACL
  # ---------------------------------------------------------

  manage_default_network_acl = false

  # ---------------------------------------------------------
  # Public subnet instances get public IPv4
  # ---------------------------------------------------------

  map_public_ip_on_launch = true

  # ---------------------------------------------------------
  # General VPC tags
  # ---------------------------------------------------------

  tags = {
    Terraform   = "true"
    Environment = "Prod"
  }

  vpc_tags = {
    Name = var.VPC_NAME
  }

  # =========================================================
  # EKS SUBNET TAGS
  # =========================================================

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}