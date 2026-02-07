# Namespace already exists, keep it
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

# Retail Store UI Deployment
resource "kubernetes_deployment" "retail_ui" {
  metadata {
    name      = "retail-ui"
    namespace = kubernetes_namespace.retail_app.metadata[0].name
    labels = {
      app = "retail-ui"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "retail-ui"
      }
    }

    template {
      metadata {
        labels = {
          app = "retail-ui"
        }
      }

      spec {
        container {
          name  = "ui"
          image = "public.ecr.aws/aws-containers/retail-store-sample-ui:latest"

          port {
            container_port = 8080
          }
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.retail_app]
}

# Expose UI via LoadBalancer
resource "kubernetes_service" "retail_ui" {
  metadata {
    name      = "retail-ui"
    namespace = kubernetes_namespace.retail_app.metadata[0].name
  }

  spec {
    selector = {
      app = "retail-ui"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }

  depends_on = [kubernetes_deployment.retail_ui]
}
