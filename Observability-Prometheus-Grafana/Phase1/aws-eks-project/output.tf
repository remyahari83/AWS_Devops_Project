# ============================================================
# VPC OUTPUTS
# ============================================================

output "vpc_id" {
  description = "ID of the EKS VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "nat_gateway_public_ips" {
  description = "Elastic IP addresses used by NAT Gateway"
  value       = module.vpc.nat_public_ips
}


# ============================================================
# EKS OUTPUTS
# ============================================================

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS Kubernetes API endpoint"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_version" {
  description = "EKS Kubernetes version"
  value       = module.eks.cluster_version
}

output "eks_cluster_arn" {
  description = "EKS cluster ARN"
  value       = module.eks.cluster_arn
}

output "eks_cluster_security_group_id" {
  description = "EKS cluster security group ID"
  value       = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  description = "EKS node security group ID"
  value       = module.eks.node_security_group_id
}


# ============================================================
# KUBECONFIG
# ============================================================

output "configure_kubectl" {
  description = "AWS CLI command to configure kubectl"
  value = "aws eks update-kubeconfig --region us-east-1 --name ${module.eks.cluster_name}"
}


# ============================================================
# EKS NODE GROUP
# ============================================================

output "eks_node_group_arn" {
  description = "EKS managed node group ARN"
  value       = try(
    module.eks.eks_managed_node_groups["application"].node_group_arn,
    null
  )
}


