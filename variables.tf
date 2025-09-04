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
    api_groups        = optional(list(string))
    resources         = optional(list(string), [])
    non_resource_urls = optional(list(string), [])
    verbs             = list(string)
  }))

  validation {
    condition     = alltrue([
      for r in var.cluster_role_permissions :
      !(length(r.resources) > 0 && length(r.non_resource_urls) > 0)
    ])
    error_message = "Each rule in cluster_role_permissions must not have both resources and non_resource_urls defined at the same time."
  }
}
