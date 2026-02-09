output "cluster_endpoint" {
  description = "EKS Cluster Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS Region"
  value       = var.region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "S3 Assets Bucket Name"
  value       = aws_s3_bucket.assets.id
}


# Developer credentials (sensitive)

output "dev_access_key_id" {
  value     = aws_iam_access_key.bedrock_dev.id
  sensitive = true
}

output "dev_secret_access_key" {
  value     = aws_iam_access_key.bedrock_dev.secret
  sensitive = true
}


