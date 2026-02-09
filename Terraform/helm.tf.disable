# Create namespace
resource "kubernetes_namespace" "retail_app" {
  metadata {
    name = var.namespace
    
    labels = {
      name    = var.namespace
      project = "bedrock"
    }
  }

  depends_on = [module.eks]
}

# Application deployed manually via kubectl
# See README.md for deployment instructions

# Data source to get LoadBalancer URL
data "kubernetes_service" "ui" {
  metadata {
    name      = "ui"
    namespace = var.namespace
  }

  depends_on = [kubernetes_namespace.retail_app]
}