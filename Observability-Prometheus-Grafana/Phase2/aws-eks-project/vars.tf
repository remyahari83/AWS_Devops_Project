# ============================================================
# VPC VARIABLES
# ============================================================

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "VPC_NAME" {
  description = "Name of the VPC"
  type        = string
  default     = "eks-observability-vpc"
}

variable "VpcCIDR" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "Zone1" {
  description = "First availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "Zone2" {
  description = "Second availability zone"
  type        = string
  default     = "us-east-1b"
}

variable "Zone3" {
  description = "Third availability zone"
  type        = string
  default     = "us-east-1c"
}

variable "PrivSub1CIDR" {
  description = "Private subnet 1 CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "PrivSub2CIDR" {
  description = "Private subnet 2 CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "PrivSub3CIDR" {
  description = "Private subnet 3 CIDR"
  type        = string
  default     = "10.0.3.0/24"
}

variable "PubSub1CIDR" {
  description = "Public subnet 1 CIDR"
  type        = string
  default     = "10.0.101.0/24"
}

variable "PubSub2CIDR" {
  description = "Public subnet 2 CIDR"
  type        = string
  default     = "10.0.102.0/24"
}

variable "PubSub3CIDR" {
  description = "Public subnet 3 CIDR"
  type        = string
  default     = "10.0.103.0/24"
}


# ============================================================
# EKS VARIABLES
# ============================================================

variable "EKS_CLUSTER_NAME" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-observability"
}

variable "EKS_VERSION" {
  description = "Kubernetes version for EKS"
  type        = string
  default     = "1.33"
}

variable "EKS_NODE_INSTANCE_TYPE" {
  description = "EC2 instance type for EKS worker nodes"
  type        = string
  default     = "t3.small"
}