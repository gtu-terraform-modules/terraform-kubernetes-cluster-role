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

  # Rules for resources
  dynamic "rule" {
    for_each = [for r in var.cluster_role_permissions : r if length(r.resources) > 0]
    content {
      api_groups = rule.value.api_groups
      resources  = rule.value.resources
      verbs      = rule.value.verbs
    }
  }

  # Rules for nonResourceURLs
  dynamic "rule" {
    for_each = [for r in var.cluster_role_permissions : r if length(r.non_resource_urls) > 0]
    content {
      non_resource_urls = rule.value.non_resource_urls
      verbs             = rule.value.verbs
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