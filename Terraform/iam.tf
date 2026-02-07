# Developer IAM User
resource "aws_iam_user" "bedrock_dev" {
  name = "bedrock-dev-view"

  tags = {
    Project = "Bedrock"
  }
}

# Attach ReadOnlyAccess policy
resource "aws_iam_user_policy_attachment" "dev_readonly" {
  user       = aws_iam_user.bedrock_dev.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Create access keys
resource "aws_iam_access_key" "bedrock_dev" {
  user = aws_iam_user.bedrock_dev.name
}

# EKS access for developer (read-only)
resource "aws_eks_access_entry" "bedrock_dev" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_user.bedrock_dev.arn
  type          = "STANDARD"

  depends_on = [module.eks]
}

resource "aws_eks_access_policy_association" "bedrock_dev_view" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_user.bedrock_dev.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.bedrock_dev]
}