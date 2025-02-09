variable "kv_name" {
  description = "Name of key vault account."
  type        = string
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  type        = bool
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  type        = string
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  type        = string
}

variable "skuname" {
  description = "The SKUs supported by Microsoft Key Vault. Valid options are premium, standard"
  type        = string
  default     = "standard"
}

variable "enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to `false`."
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to `false`."
  type        = bool
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted."
  type        = number
  default     = 7
}


variable "purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault?."
  type        = bool
  default     = false
}

# variable "access_policies" {
#   description = "Map of access policies for an object_id (user, service principal, security group) to backend."
#   type = list(object({
#     object_id               = string,
#     certificate_permissions = list(string),
#     key_permissions         = list(string),
#     secret_permissions      = list(string),
#     storage_permissions     = list(string),
#   }))
#   default = []
# }

variable "role_definition_name" {
    type        = string
    description = "The name of the Role to assign to the chosen Scope."
}

# variable "role_definition_id" {
#     type        = string
#     description = "The id of the Role to assign to the chosen Scope."
# }


variable "scope_id" {
  type        = string
  description = "The ID of the scope where the role should be assigned."
}

variable "principal_ids" {
  type        = list(string)
  description = "The ID of the principal that is to be assigned the role at the given scope. Can be User, Group or SPN."
}


variable "skip_service_principal_aad_check" {
  type        = bool
  description = "If the Principal is a newly created Service Principal, setting this to `true` will skip AAD checks (sometimes fails due to replication lag). Only applies to Service Principals."
  default     = false
}

variable "network_acls" {
  description = "Network rules to apply to key vault."
  type = object({
    bypass                     = string,
    default_action             = string,
    ip_rules                   = list(string),
    virtual_network_subnet_ids = list(string),
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}