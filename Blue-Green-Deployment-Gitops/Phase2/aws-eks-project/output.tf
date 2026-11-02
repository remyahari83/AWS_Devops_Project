# =========================================================
# VPC OUTPUTS
# =========================================================

output "vpc_id" {
  description = "ID of the EKS VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "nat_gateway_ids" {
  description = "NAT Gateway IDs"
  value       = module.vpc.natgw_ids
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
#===========================================================================
# Deployment, service and load LoadBalancer
#============================================================================
output "qa_evaluator_load_balancer_hostname" {
  description = "QA evaluator AWS Load Balancer hostname"
  value       = try(kubernetes_service.qa_evaluator.status[0].load_balancer[0].ingress[0].hostname, "pending")
}