
variable "data_factory_name" {
  description = "Name of the Azure Data Factory"
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "public_network_enabled" {
  description = "Boolean flag to enable/disable public network access"
  type        = bool
  default     = false
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone"
  type        = string
  default     = "privatelink.datafactory.azure.net"
}

variable "dns_zone_link_name" {
  description = "Name of the private DNS zone link"
  type        = string
  default     = "datafactory-dns-link"
}

variable "virtual_network_id" {
  description = "ID of the virtual network to link with the private DNS zone"
  type        = string
}

variable "private_endpoint_adf_name" {
  description = "Name of the private endpoint for adf service"
  type        = string
}

variable "private_endpoint_blob_name" {
    description = "Name of the private endpoint for blob storage"
    type        = string
}

variable "private_service_connection_adf_name" {
  description = "Name of the private service connection for adf service"
  type        = string 
}

variable "private_service_connection_blob_name" {
  description = "Name of the private service connection for blob storage"
  type        = string 
}

variable "subnet_id" {
  description = "ID of the subnet where the private endpoint will be created"
  type        = string
}



variable "ir_desp" {
  description = "Integration runtime description"
  type        = string
  default     = null
}

variable "ir_type" {
  description = "Specifies the integration runtime type. Possible values are `Azure`, `AzureSSIS` and `SelfHosted`"
  type        = string
  default     = null

  validation {
    condition     = contains(["Azure", "SelfHosted", "AzureSSIS", null], var.ir_type)
    error_message = "Possible values for `integration_runtime_type` variable are \"Azure\", \"AzureSSIS\" and \"SelfHosted\"."
  }
}

variable "ir_config" {
  description = <<EOF
  Parameters used to configure `AzureSSIS` integration runtime:
    `node_size` (optional, defaults to `Standard_D2_v3`)
    `number_of_nodes` (optional, defaults to `1`)
    `max_parallel_executions_per_nodes` (optional, defaults to `1`)
    `edition` (optional, defaults to `Standard`)
    `license_type` (optional, defaults to `LicenseIncluded`)
  Parameters used to configure `Azure` integration runtime
    `cleanup_enabled` (optional, defaults to `true`)
    `compute_type` (optional, defaults to `General`)
    `core_count` (optional, defaults to `8`)
    `time_to_live_min` (optional, defaults to `0`)
    `virtual_network_enabled` (optional, defaults to `false`)
  EOF
  type        = map(any)
  default     = {}
}

variable "ir_cname" {
  description = "Name of the integration_runtime resource"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "nested mode: NestingSingle, min items: 0, max items: 0"
  type = set(object(
    {
      create = string
      delete = string
      read   = string
      update = string
    }
  ))
  default = []
}

variable "additional_properties" {
  description = "(optional)"
  type        = map(string)
  default     = null
}

variable "annotations" {
  description = "(optional)"
  type        = list(string)
  default     = null
}

variable "description" {
  description = "(optional)"
  type        = string
  default     = null
}

variable "parameters" {
  description = "(optional)"
  type        = map(string)
  default     = null
}

variable "sql_server_name" {
  description = "Sql server name for data source"
  type        = number
}

variable "sql_database_name" {
  description = "Database name for the sql data source."
  type        = string
}

variable "sql_username" {
  description = "Username for accessing the sql data source."
  type        = string
}

variable "sql_password" {
  description = "Password for accessing the sql data source."
  type        = string
  sensitive   = true
}

variable "sql_parameters" {
  description = "parameter to use for the connection (e.g., 0 for no encryption)."
    type        = map(any)
  default     = {}
}


variable "github_account_name" {
  description = "The name of the GitHub account."
  type        = string 
}

variable "github_repository_name" {
  description = "The name of the GitHub repository."
  type        = string 
}

variable "github_branch_name" {
  description = "The name of the branch."
  type        = string 
}

variable "github_root_folder" {
  description = "The root folder of the repository."
  type        = string 
}

variable "github_url" {
  description = "The URL of the Git repository."
  type        = string
}