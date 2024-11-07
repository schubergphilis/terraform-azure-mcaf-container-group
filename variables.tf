variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Container Registry."
  default     = null
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "container_group" {
  type = object({
    name                                = string
    location                            = optional(string)
    resource_group_name                 = optional(string)
    os_type                             = optional(string, "Linux")
    subnet_ids                          = optional(list(string))
    restart_policy                      = optional(string, "OnFailure")
    priority                            = optional(string, "Regular")
    key_vault_key_id                    = optional(string)
    key_vault_user_assigned_identity_id = optional(string)
    dns_name_label                      = optional(string)
    dns_name_label_reuse_policy         = optional(string)
    role_assignments    = optional(map(object({
      principal_id = string
      role         = string
    })))
    managed_identities = optional(object({
      system_assigned            = optional(bool, false)
      user_assigned_resource_ids = optional(set(string), [])
    }), {})
    zones = optional(list(string), [])
  })
  default = {}
  description = <<ACI_DETAILS
  This object describes the configuration for an Azure Container Instance.

  - `name` = (Required) - The name of the container group.
  - `location` = (Optional) - The location of the container group. Defaults to the location of the resource group.
  - `resource_group_name` = (Optional) - The name of the resource group in which to create the container group. Defaults to the resource group of the resource.
  - `os_type` = (Optional) - The operating system type of the container group. Defaults to Linux.
  - `subnet_ids` = (Optional) - A list of subnet IDs to use for the container group.
  - `restart_policy` = (Optional) - The restart policy for the container group. Defaults to OnFailure.
  - `priority` = (Optional) - The priority for the container group. Defaults to Regular.
  - `key_vault_key_id` = (Optional) - The key vault key ID to use for the container group.
  - `key_vault_user_assigned_identity_id` = (Optional) - The user-assigned identity ID to use for the key vault.
  - `dns_name_label` = (Optional) - The DNS name label for the container group.
  - `dns_name_label_reuse_policy` = (Optional) - The DNS name label reuse policy for the container group.
  - `role_assignments` = (Optional) - A map of role assignments to assign to the container group.
  - `managed_identities` = (Optional) - The managed identities to assign to the container group.

  Example Inputs:

  ```hcl
  module "aci" {
    name = "mycontainergroup"
    subnet_ids = [
      azurerm_subnet.this.id
    ]
  }
  ```
  ACI_DETAILS
  nullable    = false
}

variable "aci" {
  type = map(object({
    image  = string
    name   = optional(string)
    cpu    = optional(number, "1")
    memory = optional(number, "1")
    ports = list(object({
      port     = number
      protocol = string
    }))
    volumes = optional(map(object({
      mount_path           = string
      name                 = string
      read_only            = optional(bool, false)
      empty_dir            = optional(bool, false)
      secret               = optional(map(string), null)
      storage_account_name = optional(string, null)
      storage_account_key  = optional(string, null)
      share_name           = optional(string, null)
      git_repo = optional(object({
        url       = optional(string, null)
        directory = optional(string, null)
        revision  = optional(string, null)
      }))
    })), {})
    environment_variables        = optional(map(string), {})
    secure_environment_variables = optional(map(string), {})
    commands                     = optional(list(string), null)
  }))
  default     = {}
  description = <<DESCRIPTION

- `image` = (Required) - The image to use for the container.
- `cpu` = (Optional) - The CPU to allocate to the container. Defaults to 1.
- `memory` = (Optional) - The memory to allocate to the container. Defaults to 1.
- `ports` = (Required) - A list of ports to expose on the container.
- `volumes` = (Optional) - A map of volumes to mount to the container.
- `environment_variables` = (Optional) - A map of environment variables to set in the container.
- `secure_environment_variables` = (Optional) - A map of secure environment variables to set in the container.
- `commands` = (Optional) - A list of commands to run in the container.

DESCRIPTION

}

variable "diagnostics_log_analytics" {
  type = object({
    workspace_id  = string
    workspace_key = string
  })
  default     = null
  description = "The Log Analytics workspace configuration for diagnostics."
}

variable "dns_name_label" {
  type        = string
  default     = null
  description = "The DNS name label for the container group."
}

variable "dns_name_servers" {
  type        = list(string)
  default     = []
  description = "A list of DNS name servers to use for the container group."
}

variable "exposed_ports" {
  type = list(object({
    port     = number
    protocol = string
  }))
  default     = []
  description = <<DESCRIPTION
A list of ports to expose on the container group.

- `port` = (Required) - The port to expose.
- `protocol` = (Required) - The protocol to use for the port. Valid options are TCP and UDP.
DESCRIPTION
}

variable "image_registry_credential" {
  type = map(object({
    user_assigned_identity_id = optional(string, null)
    server                    = string
    username                  = optional(string, null)
    password                  = optional(string, null)
  }))
  default     = {}
  description = "The credentials for the image registry."
}

variable "liveness_probe" {
  type = object({
    exec = object({
      command = list(string)
    })
    period_seconds        = number
    failure_threshold     = number
    success_threshold     = number
    timeout_seconds       = number
    initial_delay_seconds = number
    http_get = object({
      path         = string
      port         = number
      http_headers = map(string)
    })
    tcp_socket = object({
      port = number
    })
  })
  default     = null
  description = <<DESCRIPTION

- `exec` = (Optional) - The exec probe configuration.
- `period_seconds` = (Required) - The period in seconds between probe checks.
- `failure_threshold` = (Required) - The number of failures before the probe is considered failed.
- `success_threshold` = (Required) - The number of successes before the probe is considered successful.
- `timeout_seconds` = (Required) - The timeout in seconds for the probe.
- `initial_delay_seconds` = (Required) - The initial delay in seconds before the first probe check.
- `http_get` = (Optional) - The HTTP GET probe configuration.
- `tcp_socket` = (Optional) - The TCP socket probe configuration.

DESCRIPTION
}

variable "readiness_probe" {
  type = object({
    exec = object({
      command = list(string)
    })
    period_seconds        = number
    failure_threshold     = number
    success_threshold     = number
    timeout_seconds       = number
    initial_delay_seconds = number
    http_get = object({
      path         = string
      port         = number
      http_headers = map(string)
    })
    tcp_socket = object({
      port = number
    })
  })
  default     = null
  description = <<DESCRIPTION

- `exec` = (Optional) - The exec probe configuration.
- `period_seconds` = (Required) - The period in seconds between probe checks.
- `failure_threshold` = (Required) - The number of failures before the probe is considered failed.
- `success_threshold` = (Required) - The number of successes before the probe is considered successful.
- `timeout_seconds` = (Required) - The timeout in seconds for the probe.
- `initial_delay_seconds` = (Required) - The initial delay in seconds before the first probe check.
- `http_get` = (Optional) - The HTTP GET probe configuration.
- `tcp_socket` = (Optional) - The TCP socket probe configuration.

DESCRIPTION
}

variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
  Controls the Managed Identity configuration on this resource. The following properties can be specified:

  - `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
  - `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
  DESCRIPTION
  nullable    = false
}