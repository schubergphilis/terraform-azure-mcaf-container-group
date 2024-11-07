# terraform-azure-mcaf-container-group
Terraform module to generate a container group

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_container_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_group) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aci"></a> [aci](#input\_aci) | - `image` = (Required) - The image to use for the container.<br>- `cpu` = (Optional) - The CPU to allocate to the container. Defaults to 1.<br>- `memory` = (Optional) - The memory to allocate to the container. Defaults to 1.<br>- `ports` = (Required) - A list of ports to expose on the container.<br>- `volumes` = (Optional) - A map of volumes to mount to the container.<br>- `environment_variables` = (Optional) - A map of environment variables to set in the container.<br>- `secure_environment_variables` = (Optional) - A map of secure environment variables to set in the container.<br>- `commands` = (Optional) - A list of commands to run in the container. | <pre>map(object({<br>    image  = string<br>    name   = optional(string)<br>    cpu    = optional(number, "1")<br>    memory = optional(number, "1")<br>    ports = list(object({<br>      port     = number<br>      protocol = string<br>    }))<br>    volumes = optional(map(object({<br>      mount_path           = string<br>      name                 = string<br>      read_only            = optional(bool, false)<br>      empty_dir            = optional(bool, false)<br>      secret               = optional(map(string), null)<br>      storage_account_name = optional(string, null)<br>      storage_account_key  = optional(string, null)<br>      share_name           = optional(string, null)<br>      git_repo = optional(object({<br>        url       = optional(string, null)<br>        directory = optional(string, null)<br>        revision  = optional(string, null)<br>      }))<br>    })), {})<br>    environment_variables        = optional(map(string), {})<br>    secure_environment_variables = optional(map(string), {})<br>    commands                     = optional(list(string), null)<br>  }))</pre> | n/a | yes |
| <a name="input_container_group"></a> [container\_group](#input\_container\_group) | This object describes the configuration for an Azure Container Instance.<br><br>  - `name` = (Required) - The name of the container group.<br>  - `location` = (Optional) - The location of the container group. Defaults to the location of the resource group.<br>  - `resource_group_name` = (Optional) - The name of the resource group in which to create the container group. Defaults to the resource group of the resource.<br>  - `os_type` = (Optional) - The operating system type of the container group. Defaults to Linux.<br>  - `subnet_ids` = (Optional) - A list of subnet IDs to use for the container group.<br>  - `restart_policy` = (Optional) - The restart policy for the container group. Defaults to OnFailure.<br>  - `priority` = (Optional) - The priority for the container group. Defaults to Regular.<br>  - `key_vault_key_id` = (Optional) - The key vault key ID to use for the container group.<br>  - `key_vault_user_assigned_identity_id` = (Optional) - The user-assigned identity ID to use for the key vault.<br>  - `dns_name_label` = (Optional) - The DNS name label for the container group.<br>  - `dns_name_label_reuse_policy` = (Optional) - The DNS name label reuse policy for the container group.<br>  - `role_assignments` = (Optional) - A map of role assignments to assign to the container group.<br>  - `managed_identities` = (Optional) - The managed identities to assign to the container group.<br><br>  Example Inputs:<pre>hcl<br>  module "aci" {<br>    name = "mycontainergroup"<br>    subnet_ids = [<br>      azurerm_subnet.this.id<br>    ]<br>  }</pre> | <pre>object({<br>    name                                = string<br>    location                            = optional(string)<br>    resource_group_name                 = optional(string)<br>    os_type                             = optional(string, "Linux")<br>    subnet_ids                          = optional(list(string))<br>    restart_policy                      = optional(string, "OnFailure")<br>    priority                            = optional(string, "Regular")<br>    key_vault_key_id                    = optional(string)<br>    key_vault_user_assigned_identity_id = optional(string)<br>    dns_name_label                      = optional(string)<br>    dns_name_label_reuse_policy         = optional(string)<br>    role_assignments = optional(map(object({<br>      principal_id = string<br>      role         = string<br>    })))<br>    managed_identities = optional(object({<br>      system_assigned            = optional(bool, false)<br>      user_assigned_resource_ids = optional(set(string), [])<br>    }), {})<br>    zones = optional(list(string), [])<br>  })</pre> | n/a | yes |
| <a name="input_diagnostics_log_analytics"></a> [diagnostics\_log\_analytics](#input\_diagnostics\_log\_analytics) | The Log Analytics workspace configuration for diagnostics. | <pre>object({<br>    workspace_id  = string<br>    workspace_key = string<br>  })</pre> | `null` | no |
| <a name="input_dns_name_label"></a> [dns\_name\_label](#input\_dns\_name\_label) | The DNS name label for the container group. | `string` | `null` | no |
| <a name="input_dns_name_servers"></a> [dns\_name\_servers](#input\_dns\_name\_servers) | A list of DNS name servers to use for the container group. | `list(string)` | `[]` | no |
| <a name="input_exposed_ports"></a> [exposed\_ports](#input\_exposed\_ports) | A list of ports to expose on the container group.<br><br>- `port` = (Required) - The port to expose.<br>- `protocol` = (Required) - The protocol to use for the port. Valid options are TCP and UDP. | <pre>list(object({<br>    port     = number<br>    protocol = string<br>  }))</pre> | `[]` | no |
| <a name="input_image_registry_credential"></a> [image\_registry\_credential](#input\_image\_registry\_credential) | The credentials for the image registry. | <pre>map(object({<br>    user_assigned_identity_id = optional(string, null)<br>    server                    = string<br>    username                  = optional(string, null)<br>    password                  = optional(string, null)<br>  }))</pre> | `{}` | no |
| <a name="input_liveness_probe"></a> [liveness\_probe](#input\_liveness\_probe) | - `exec` = (Optional) - The exec probe configuration.<br>- `period_seconds` = (Required) - The period in seconds between probe checks.<br>- `failure_threshold` = (Required) - The number of failures before the probe is considered failed.<br>- `success_threshold` = (Required) - The number of successes before the probe is considered successful.<br>- `timeout_seconds` = (Required) - The timeout in seconds for the probe.<br>- `initial_delay_seconds` = (Required) - The initial delay in seconds before the first probe check.<br>- `http_get` = (Optional) - The HTTP GET probe configuration.<br>- `tcp_socket` = (Optional) - The TCP socket probe configuration. | <pre>object({<br>    exec = object({<br>      command = list(string)<br>    })<br>    period_seconds        = number<br>    failure_threshold     = number<br>    success_threshold     = number<br>    timeout_seconds       = number<br>    initial_delay_seconds = number<br>    http_get = object({<br>      path         = string<br>      port         = number<br>      http_headers = map(string)<br>    })<br>    tcp_socket = object({<br>      port = number<br>    })<br>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the resource should be deployed. | `string` | `null` | no |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | Controls the Managed Identity configuration on this resource. The following properties can be specified:<br><br>  - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.<br>  - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource. | <pre>object({<br>    system_assigned            = optional(bool, false)<br>    user_assigned_resource_ids = optional(set(string), [])<br>  })</pre> | `{}` | no |
| <a name="input_readiness_probe"></a> [readiness\_probe](#input\_readiness\_probe) | - `exec` = (Optional) - The exec probe configuration.<br>- `period_seconds` = (Required) - The period in seconds between probe checks.<br>- `failure_threshold` = (Required) - The number of failures before the probe is considered failed.<br>- `success_threshold` = (Required) - The number of successes before the probe is considered successful.<br>- `timeout_seconds` = (Required) - The timeout in seconds for the probe.<br>- `initial_delay_seconds` = (Required) - The initial delay in seconds before the first probe check.<br>- `http_get` = (Optional) - The HTTP GET probe configuration.<br>- `tcp_socket` = (Optional) - The TCP socket probe configuration. | <pre>object({<br>    exec = object({<br>      command = list(string)<br>    })<br>    period_seconds        = number<br>    failure_threshold     = number<br>    success_threshold     = number<br>    timeout_seconds       = number<br>    initial_delay_seconds = number<br>    http_get = object({<br>      path         = string<br>      port         = number<br>      http_headers = map(string)<br>    })<br>    tcp_socket = object({<br>      port = number<br>    })<br>  })</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Container Registry. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_fqdn"></a> [fqdn](#output\_fqdn) | The FQDN of the container group derived from `dns_name_label` |
| <a name="output_ip_address"></a> [ip\_address](#output\_ip\_address) | The IP address allocated to the container group |
| <a name="output_name"></a> [name](#output\_name) | Name of the container group |
| <a name="output_resource"></a> [resource](#output\_resource) | The container group resource |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | Name of the container group resource group |
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | Resource ID of Container Group Instance |
| <a name="output_system_assigned_mi_principal_id"></a> [system\_assigned\_mi\_principal\_id](#output\_system\_assigned\_mi\_principal\_id) | The principal ID of the system assigned managed identity |
<!-- END_TF_DOCS -->

## License

**Copyright:** Schuberg Philis

```text
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
