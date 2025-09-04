output "service_account_name" {
  value = kubernetes_service_account.this.metadata[0].name
}

output "cluster_role_name" {
  value = kubernetes_cluster_role.this.metadata[0].name
}

output "secret_name" {
  value = kubernetes_secret_v1.this.metadata[0].name
}