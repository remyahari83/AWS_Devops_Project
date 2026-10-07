# =========================================================
# Grafana Bastion - IAM + Instance Profile + EKS Access
# =========================================================

# ---------------------------------------------------------
# IAM Role for Grafana Bastion
# ---------------------------------------------------------

resource "aws_iam_role" "grafana_bastion" {
  name = "grafana-bastion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Environment = "lab"
    Terraform   = "true"
    Purpose     = "Grafana access"
  }
}


# ---------------------------------------------------------
# Allow Bastion to describe the EKS cluster
# ---------------------------------------------------------

resource "aws_iam_role_policy" "grafana_bastion_eks" {
  name = "grafana-bastion-eks"
  role = aws_iam_role.grafana_bastion.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "eks:DescribeCluster"
        ]

        Resource = module.eks.cluster_arn
      }
    ]
  })
}


# ---------------------------------------------------------
# EC2 Instance Profile
# ---------------------------------------------------------

resource "aws_iam_instance_profile" "grafana_bastion" {
  name = "grafana-bastion-profile"
  role = aws_iam_role.grafana_bastion.name

  tags = {
    Environment = "lab"
    Terraform   = "true"
    Purpose     = "Grafana access"
  }
}


# ---------------------------------------------------------
# EKS Access Entry
# ---------------------------------------------------------
# Allows this IAM role to authenticate to the EKS cluster.
# Kubernetes permissions are granted below.

resource "aws_eks_access_entry" "grafana_bastion" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.grafana_bastion.arn
  type          = "STANDARD"

  kubernetes_groups = ["grafana-portforward"]
}


# ---------------------------------------------------------
# EKS Access Policy
# ---------------------------------------------------------
# Gives the bastion read-only Kubernetes access.
#
# This is enough for:
#   kubectl get nodes
#   kubectl get pods
#   kubectl get svc
#   kubectl describe ...
#
# Port-forward also requires appropriate namespace permissions,
# so we use AmazonEKSViewPolicy here initially and can add a
# narrower/custom policy if required.

resource "aws_eks_access_policy_association" "grafana_bastion" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.grafana_bastion.arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.grafana_bastion
  ]
}


# =========================================================
# Existing Grafana Bastion
# =========================================================

data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = [
      "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
    ]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


# ---------------------------------------------------------
# Bastion Security Group
# ---------------------------------------------------------

resource "aws_security_group" "bastion_sg" {
  name        = "grafana-bastion-sg"
  description = "Allow SSH access to Grafana bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH from my public IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

    cidr_blocks = ["103.5.134.163/32"]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "grafana-bastion-sg"
    Environment = "lab"
    Terraform   = "true"
  }
}


# ---------------------------------------------------------
# Bastion EC2
# ---------------------------------------------------------

resource "aws_instance" "grafana_bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  # PUBLIC subnet
  subnet_id = module.vpc.public_subnets[0]

  # Assign public IPv4 address
  associate_public_ip_address = true

  # Attach IAM instance profile
  iam_instance_profile = aws_iam_instance_profile.grafana_bastion.name

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  # Existing AWS EC2 key pair
  key_name = "rg"

  tags = {
    Name        = "grafana-bastion"
    Environment = "lab"
    Terraform   = "true"
    Purpose     = "Grafana access"
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_to_eks_api" {
  security_group_id            = "sg-014eec448db2707a2"
  referenced_security_group_id = aws_security_group.bastion_sg.id

  from_port = 443
  to_port   = 443
  ip_protocol = "tcp"

  description = "Allow Grafana bastion to access EKS API"
}


resource "kubernetes_role" "grafana_portforward" {
  metadata {
    name      = "grafana-portforward"
    namespace = "monitoring"
  }

  rule {
    api_groups = [""]
    resources  = ["pods/portforward"]
    verbs      = ["create"]
  }
}

resource "kubernetes_role_binding" "grafana_portforward" {
  metadata {
    name      = "grafana-portforward"
    namespace = "monitoring"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.grafana_portforward.metadata[0].name
  }

  subject {
    kind      = "Group"
    name      = "grafana-portforward"
    api_group = "rbac.authorization.k8s.io"
  }
}