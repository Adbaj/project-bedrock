variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "project-bedrock-cluster"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "project-bedrock-vpc"
}

variable "student_id" {
  description = "Your Student ID"
  type        = string
  default     = "12345"  
}

variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "retail-app"
}