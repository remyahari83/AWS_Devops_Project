resource "kubernetes_namespace_v1" "qa" {
  metadata {
    name = "qa"
  }
}

resource "kubernetes_deployment" "qa_evaluator" {
  metadata {
    name      = "qa-evaluator"
    namespace = kubernetes_namespace_v1.qa.metadata[0].name

    labels = {
      app = "qa-evaluator"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "qa-evaluator"
      }
    }

    template {
      metadata {
        labels = {
          app = "qa-evaluator"
        }
      }

      spec {
        container {
          name  = "qa-evaluator"
          image = "521765619271.dkr.ecr.us-east-1.amazonaws.com/myapp:latest"

          image_pull_policy = "Always"

          port {
            container_port = 8000
          }
          env {
            name = "OPENAI_API_KEY"

            value_from {
              secret_key_ref {
                name = "qa-evaluator-secrets"
                key  = "OPENAI_API_KEY"
            }
           }
          }

          resources {
            requests = {
              cpu    = "250m"
              memory = "512Mi"
            }

            limits = {
              cpu    = "500m"
              memory = "1Gi"
            }
          }
        }
      }
    }
  }
}