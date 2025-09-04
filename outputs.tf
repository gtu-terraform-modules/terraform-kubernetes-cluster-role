output "service_account_name" {
  value = kubernetes_service_account.this.metadata[0].name
}

output "service_account_token" {
  value = kubernetes_secret_v1.this.data["token"]
}