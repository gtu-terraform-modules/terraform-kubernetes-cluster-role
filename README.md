# Terraform Kubernetes Cluster Role Module

This Terraform module creates the following Kubernetes resources:
- A Service Account
- A ClusterRole
- A ClusterRoleBinding
- A Secret containing the bearer token for the Service Account

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "kubernetes_cluster_role" {
  source                   = "./terraform-kubernetes-cluster-role"
  service_account_name     = "example-service-account"
  cluster_role_name        = "example-cluster-role"
  cluster_role_binding_name = "example-cluster-role-binding"
  namespace                = "default"
  cluster_role_permissions = [
    {
      api_groups = [""]
      resources  = ["pods"]
      verbs      = ["get", "list", "watch"]
    }
  ]
}
```

## Inputs

| Name                     | Description                                           | Type                                                                 | Default   | Required |
|--------------------------|-------------------------------------------------------|----------------------------------------------------------------------|-----------|:--------:|
| service_account_name     | The name of the Service Account                       | `string`                                                            | n/a       |   yes    |
| cluster_role_name        | The name of the ClusterRole                           | `string`                                                            | n/a       |   yes    |
| cluster_role_binding_name| The name of the ClusterRoleBinding                    | `string`                                                            | n/a       |   yes    |
| namespace                | The namespace in which to create the resources        | `string`                                                            | `"default"` |   no     |
| cluster_role_permissions | A list of permissions for the ClusterRole             | `list(object({ api_groups = list(string), resources = list(string), verbs = list(string) }))` | n/a       |   yes    |

## Outputs

| Name                     | Description                                           |
|--------------------------|-------------------------------------------------------|
| service_account_name     | The name of the created Service Account               |
| cluster_role_name        | The name of the created ClusterRole                   |
| cluster_role_binding_name| The name of the created ClusterRoleBinding            |
| bearer_token             | The bearer token for the Service Account              |

## Example

Refer to the `examples/example.tf` file for a complete example of how to use this module.

## Requirements

- Terraform 0.12 or later
- Kubernetes provider

## Author

This module is maintained by [Your Name or Organization].

## License

This module is licensed under the MIT License. See the LICENSE file for more details.