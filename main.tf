resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = var.cluster_role_name
  }

  rule {
    api_groups = var.cluster_role_permissions.api_groups
    resources  = var.cluster_role_permissions.resources
    verbs      = var.cluster_role_permissions.verbs
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = var.cluster_role_binding_name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.this.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.this.metadata[0].name
    namespace = var.namespace
  }
}

resource "kubernetes_secret_v1" "bearer_token" {
  metadata {
    name      = "${kubernetes_service_account.this.metadata[0].name}-token"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.this.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}