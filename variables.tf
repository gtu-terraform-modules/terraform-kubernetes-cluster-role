variable "service_account_name" {
  description = "The name of the Service Account to create"
  type        = string
}

variable "service_account_namespace" {
  description = "The namespace in which to create the resources"
  type        = string
  default     = "default"
}

variable "cluster_role_name" {
  description = "The name of the ClusterRole to create"
  type        = string
}

variable "cluster_role_binding_name" {
  description = "The name of the ClusterRoleBinding to create"
  type        = string
}

variable "cluster_role_permissions" {
  description = "Permissions for the cluster role"
  type = list(object({
    api_groups        = list(string)
    resources         = list(string)
    verbs             = list(string)
    non_resource_urls = optional(list(string)) # Добавлено поле non_resource_urls
  }))
}
