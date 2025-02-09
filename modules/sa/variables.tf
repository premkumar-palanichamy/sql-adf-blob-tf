########## Resource group Vars ##########
variable "create_resource_group" {
  description = "Whether to create or reuse resource group"
  default     = false
  type        = bool
}

variable "resource_group_name" {
  description = "name of the resource group name"
  type        = string
}

########## Storage Account Vars ##########
variable "name" {
  description = "Storage account name"
  type        = string
  default     = null
}

variable "location" {
  description = "Specifies the supported Azure location to MySQL server resource"
  type        = string
}

# variable "region_code" {
#   description = "Short code for the Azure region."
#   type        = string
#   default     = var.location == "North Europe" ? "ne" : var.location
# }

variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account (Standard or Premium)."
  type        = string
  default     = null
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts"
  type        = string
  default     = "Hot"

  validation {
    condition     = (contains(["hot", "cool"], lower(var.access_tier)))
    error_message = "The account_tier must be either \"Hot\" or \"Cool\"."
  }
}

variable "blob_last_access_time_enabled" {
  description = "Controls whether blob last access time recording is enabled for container usage."
  type        = bool
  default     = false
}

variable "replication_type" {
  description = "Storage account replication type - i.e. LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS."
  type        = string
}

variable "enable_large_file_share" {
  description = "Enable Large File Share."
  type        = bool
  default     = false
}

# variable "table_encryption_key_type" {
#   description = "Encryption type for table."
#   type        = bool
#   default     = Service
# }

# variable "queue_encryption_key_type" {
#   description = "Encryption type for queues"
#   type        = bool
#   default     = Service
# }

variable "enable_hns" {
  description = "Enable Hierarchical Namespace (can be used with Azure Data Lake Storage Gen 2)."
  type        = bool
  default     = false
}

variable "enable_sftp" {
  description = "Enable SFTP for storage account (enable_hns must be set to true for this to work)."
  type        = bool
  default     = false
}

variable "enable_https_traffic_only" {
  description = "Forces HTTPS if enabled."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "The minimum supported TLS version for the storage account."
  type        = string
  default     = "TLS1_2"
}

# variable "allow_nested_items_to_be_public" {
#   description = "Allow or disallow public access to all blobs or containers in the storage account."
#   type        = bool
#   default     = false
# }

# Note: make sure to include the IP address of the host from where "terraform" command is executed to allow for access to the storage
# Otherwise, creating container inside the storage or any access attempt will be denied.
variable "access_list" {
  description = "Map of CIDRs Storage Account access."
  type        = map(string)
  default     = {}
}

variable "service_endpoints" {
  description = "Creates a virtual network rule in the subnet_id (values are virtual network subnet ids)."
  type        = map(string)
  default     = {}
}

variable "traffic_bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None."
  type        = list(string)
  default     = ["None"]
}

variable "blob_delete_retention_days" {
  description = "Retention days for deleted blob. Valid value is between 1 and 365 (set to 0 to disable)."
  type        = number
  default     = 7
}

variable "blob_cors" {
  description = "blob service cors rules:  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule"
  type = map(object({
    allowed_headers    = list(string)
    allowed_methods    = list(string)
    allowed_origins    = list(string)
    exposed_headers    = list(string)
    max_age_in_seconds = number
  }))
  default = null
}

variable "enable_static_website" {
  description = "Controls if static website to be enabled on the storage account. Possible values are `true` or `false`"
  type        = bool
  default     = false
}

variable "cross_tenant_replication_enabled" {
  description = "Enable cross tenant replication when needed and valid reason. Possible values are `true` or `false`"
  type        = bool
  default     = false
}

variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Storage Account should exist. Changing this forces a new Storage Account to be created."
}

variable "allow_nested_items_to_be_public" {
  type        = bool
  default     = false
  description = "(Optional) Allow or disallow nested items within this Account to opt into being public. Defaults to `false`."
}

variable "index_path" {
  description = "path from your repo root to index.html"
  type        = string
  default     = null
}

variable "custom_404_path" {
  description = "path from your repo root to your custom 404 page"
  type        = string
  default     = null
}

variable "encryption_scopes" {
  description = "Encryption scopes, keys are scope names. more info https://docs.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable?tabs=portal"
  type = map(object({
    enable_infrastructure_encryption = optional(bool)
    source                           = optional(string)
  }))

  default = {}
}

variable "infrastructure_encryption_enabled" {
  description = "Is infrastructure encryption enabled? Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled? Changing this forces a new resource to be created"
  type        = bool
  default     = false
}

variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned to the Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned` and `SystemAssigned, UserAssigned`"
  default     = null
  type        = string
}

variable "default_network_rule" {
  description = "Specifies the default action of allow or deny when no other network rule(s) match"
  type        = string
  #default     = "Allow"

  validation {
    condition     = (contains(["deny", "allow"], lower(var.default_network_rule)))
    error_message = "The default_network_rule must be either \"Deny\" or \"Allow\"."
  }
}

variable "shared_access_key_enabled" {
  description = "Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Indicates whether the storage account is authorized to access from internet"
  type        = bool
}

variable "default_to_oauth_authentication" {
  description = "Set default authentication to storage account content"
  type        = bool
  default     = false
}

variable "blob_versioning_enabled" {
  description = "Controls whether blob object versioning is enabled."
  type        = bool
  default     = false
}

variable "container_delete_retention_days" {
  description = "Retention days for deleted container. Valid value is between 1 and 365 (set to 0 to disable)."
  type        = number
  default     = 7
}

variable "enable_advanced_threat_protection" {
  description = "Boolean flag which controls if advanced threat protection is enabled."
  default     = false
  type        = bool
}

variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine."
  default     = null
  type        = list(string)
}

########## Container Vars ##########
variable "container" {
  description = "List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}

########## Blob Vars ##########
variable "create_blob" {
  description = "Whether to create or reuse blob"
  default     = false
  type        = bool
}

variable "blob_name" {
  description = "The name of the blob"
  type        = string
}

variable "blob_type" {
  description = "The type of the blob"
  type        = string
  default     = "Block"
}

# variable "source_uri" {
#   description = "The URI of the source blob.  If not provided, the blob will be created without content."
#   type        = string
# }

variable "source_path" {
  description = "The Path of the source blob.  If not provided, the blob will be created without content."
  type        = string
}

variable "content_type" {
  description = "The content type of the blob"
  type        = string
}

# Blob Definitions for multiple containers and storage accounts (Optional)
# variable "blob_definitions" {
#   type = map(object({
#     storage_account_name = string
#     container_name       = string
#     blob_name            = string
#     blob_type            = string
#     source_uri           = string
#     content_type         = string
#   }))
# }

# TF Vars values (Optional)
# blob_definitions = {
#   "blob1" = {
#     storage_account_name = "storageaccount1"
#     container_name       = "container1"
#     blob_name            = "blob1"
#     blob_type            = "Block"
#     source_uri           = "https://example.com/blob1"
#     content_type         = "application/octet-stream"
#   }
#   "blob2" = {
#     storage_account_name = "storageaccount2"
#     container_name       = "container2"
#     blob_name            = "blob2"
#     blob_type            = "Append"
#     source_uri           = "https://example.com/blob2"
#     content_type         = "text/plain"
#   }
# }

########## Storage Lifecycle Management Vars ##########
variable "lifecycles" {
  description = "Configure Azure Storage dynamically configure lifecycle rules for blobs"
  type        = list(object({ prefix_match = set(string), tier_to_cool_after_days = number, tier_to_archive_after_days = number, delete_after_days = number, snapshot_delete_after_days = number }))
  default     = []
}