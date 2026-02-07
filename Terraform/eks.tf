module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.31"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  # Control plane logging (REQUIRED)
  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  # OPTIMIZED: Smaller instances + SPOT pricing
  eks_managed_node_groups = {
    bedrock_nodes = {
      min_size     = 2
      max_size     = 3  # Reduced from 4
      desired_size = 2

      instance_types = ["t3.small"]  # Changed from t3.medium
      capacity_type  = "SPOT"        # Changed from ON_DEMAND

      # EBS optimization
      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 20
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 125
            delete_on_termination = true
          }
        }
      }

      tags = {
        Project = "Bedrock"
      }
    }
  }

  create_cloudwatch_log_group = false
  enable_cluster_creator_admin_permissions = true

  tags = {
    Project = "Bedrock"
  }
}

# CloudWatch Observability Add-on (REQUIRED)
resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name = module.eks.cluster_name
  addon_name   = "amazon-cloudwatch-observability"
  
  depends_on = [module.eks]
}