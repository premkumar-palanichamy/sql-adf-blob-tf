variable "create_resource_group" {
  description = "Whether to create or reuse resource group"
  default     = false
  type        = bool
}

variable "name" {
  type        = string
  description = "(Required) Specifies the name of the Log Analytics Workspace. Workspace name should include 4-63 letters, digits or '-'. The '-' shouldn't be the first or the last symbol. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which the Log Analytics workspace is created. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "law_sku" {
  type        = string
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are PerNode, Standalone, Unlimited, CapacityReservation, and PerGB2018. Defaults to PerGB2018. Premium and Standard do not work as per testing."
  default     = "PerGB2018"
}

variable "retention_in_days" {
  type        = number
  description = "(Optional) The workspace data retention in days. Possible values are in the range between 30 and 730."
  default     = 30
  validation {
    condition     = var.retention_in_days >= 30 && var.retention_in_days <= 730
    error_message = "retention_in_days should be between 30 to 730."
  }
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}

variable "managed_identity_type" {
  type        = string
  description = "(Optional) Specifies the identity type of the Log Analytics Workspace. Possible values are SystemAssigned (where Azure will generate a Service Principal for you) and UserAssigned where you can specify the Service Principal IDs in the identity_ids field."
  default     = null
}

variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine."
  default     = null
  type        = list(string)
}

# variable "identity" {
#   type = object({
#     type         = string
#     identity_ids = optional(list(string))
#   })
#   description = <<EOF
#   (Optional) A identity block as defined below.
#   - type Specifies the identity type of the Log Analytics Workspace. Possible values are SystemAssigned (where Azure will generate a Service Principal for you) and UserAssigned where you can specify the Service Principal IDs in the identity_ids field.
#   - identity_ids Specifies the list of User Assigned Identity IDs to be associated with the Log Analytics Workspace. This field is required when type is UserAssigned.
#   EOF
#   default     = null
# }

variable "local_authentication_disabled" {
  type        = bool
  description = "(Optional) Boolean flag to specify whether local authentication should be disabled. Defaults to false."
  default     = false
}