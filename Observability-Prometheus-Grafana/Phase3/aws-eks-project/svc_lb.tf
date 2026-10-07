resource "kubernetes_service" "qa_evaluator" {
  metadata {
    name      = "qa-evaluator"
    namespace = kubernetes_namespace_v1.qa.metadata[0].name
  }

  spec {
    selector = {
      app = "qa-evaluator"
    }

    type = "LoadBalancer"

    port {
      port        = 80
      target_port = 8000
      protocol    = "TCP"
    }
  }
}