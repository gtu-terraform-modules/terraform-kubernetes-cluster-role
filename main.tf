resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.service_account_name
    namespace = var.service_account_namespace
  }
}

resource "kubernetes_cluster_role" "this" {
  metadata {
    name = var.cluster_role_name
  }

  dynamic "rule" {
    for_each = var.cluster_role_permissions
    content {
      api_groups = rule.value.api_groups != null ? rule.value.api_groups : []
      resources  = rule.value.resources != null ? rule.value.resources : []
      verbs      = rule.value.verbs

      # Handle non_resource_urls as a regular block if it exists
      non_resource_urls = rule.value.non_resource_urls != null ? rule.value.non_resource_urls : []
    }
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
    namespace = var.service_account_namespace
  }
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    name      = "${kubernetes_service_account.this.metadata[0].name}-token"
    namespace = var.service_account_namespace
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account.this.metadata[0].name
    }
  }

  type = "kubernetes.io/service-account-token"
}