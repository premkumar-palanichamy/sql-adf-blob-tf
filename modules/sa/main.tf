#---------------------------------------------------------
# Random String Generation
#----------------------------------------------------------

resource "random_string" "random" {
  length  = 24
  special = false
  upper   = false
}

#---------------------------------------------------------
# Local Variables
#----------------------------------------------------------

locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  account_tier        = (var.account_tier == null ? (var.account_kind == "BlockBlobStorage" || var.account_kind == "FileStorage" ? "Premium" : "Standard") : var.account_tier)

  ########## Below local decalrations are optional #############
  static_website_enabled = (local.validate_static_website) ? [{}] : []

  validate_static_website = (var.enable_static_website ? ((var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ?
  true : file("ERROR: Account kind must be BlockBlobStorage or StorageV2 when enabling static website")) : false)

  validate_nfsv3 = (!var.nfsv3_enabled || (var.nfsv3_enabled && var.enable_hns) ?
  true : file("ERROR: NFS V3 can only be enabled when Hierarchical Namespaces are enabled"))

  validate_sftp = (!var.enable_sftp || (var.enable_sftp && var.enable_hns) ?
  true : file("ERROR: SFTP can only be enabled when Hierarchical Namespaces are enabled"))

  validate_nfsv3_network_rules = (!var.nfsv3_enabled || (var.nfsv3_enabled && lower(var.default_network_rule) == "deny") ?
  true : file("ERROR: Default network rule must be Deny when using NFS V3"))

  validate_network_rules = ((lower(var.default_network_rule) == "deny" && var.access_list == {} && var.service_endpoints == {}) ?
  file("ERROR: Storage account does not allow any ingress traffic. Storage account will not be managable after creation") : true)

  validate_encryption_rules = ((var.infrastructure_encryption_enabled && var.account_kind != "StorageV2") ?
  file("ERROR: Infrastructure encryption can only be enabled when account kind is StorageV2") : true)
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------

data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}
resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = lower(var.resource_group_name)
  location = var.location
  tags     = merge({ "ResourceName" = format("%s", var.resource_group_name) }, var.tags, )
}

#---------------------------------------------------------
# Storage Account
#----------------------------------------------------------

resource "azurerm_storage_account" "sa" {
  name                              = lower(var.name == null ? random_string.random.result : var.name)
  resource_group_name               = local.resource_group_name
  location                          = var.location
  account_kind                      = var.account_kind
  account_tier                      = local.account_tier
  account_replication_type          = var.replication_type
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  access_tier                       = var.access_tier
  edge_zone                         = var.edge_zone
  https_traffic_only_enabled        = var.enable_https_traffic_only
  min_tls_version                   = var.min_tls_version
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  is_hns_enabled                    = var.enable_hns
  nfsv3_enabled                     = var.nfsv3_enabled
  sftp_enabled                      = var.enable_sftp
  large_file_share_enabled          = var.enable_large_file_share
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  tags                              = var.tags

  dynamic "identity" {
    for_each = var.managed_identity_type != null ? [1] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  dynamic "blob_properties" {
    for_each = ((var.account_kind == "BlockBlobStorage" || var.account_kind == "StorageV2") ? [1] : [])
    content {
      versioning_enabled       = var.blob_versioning_enabled
      last_access_time_enabled = var.blob_last_access_time_enabled

      dynamic "delete_retention_policy" {
        for_each = (var.blob_delete_retention_days == 0 ? [] : [1])
        content {
          days = var.blob_delete_retention_days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = (var.container_delete_retention_days == 0 ? [] : [1])
        content {
          days = var.container_delete_retention_days
        }
      }

      dynamic "cors_rule" {
        for_each = (var.blob_cors == null ? {} : var.blob_cors)
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }
    }
  }

  dynamic "static_website" {
    for_each = local.static_website_enabled
    content {
      index_document     = var.index_path
      error_404_document = var.custom_404_path
    }
  }

  network_rules {
    default_action             = var.default_network_rule
    ip_rules                   = values(var.access_list)
    virtual_network_subnet_ids = values(var.service_endpoints)
    bypass                     = var.traffic_bypass
  }
  lifecycle {
    ignore_changes = [network_rules]
  }
}


resource "azurerm_storage_encryption_scope" "scope" {
  for_each = var.encryption_scopes

  name                               = each.key
  storage_account_id                 = azurerm_storage_account.sa.id
  source                             = coalesce(each.value.source, "Microsoft.Storage")
  infrastructure_encryption_required = coalesce(each.value.enable_infrastructure_encryption, var.infrastructure_encryption_enabled)
}

#-------------------------------
# Storage Container Creation
#-------------------------------
resource "azurerm_storage_container" "container" {
  count              = length(var.container)
  name               = var.container[count.index].name
  storage_account_id = azurerm_storage_account.sa.id
  #container_access_type = var.container[count.index].access_type
  container_access_type = "private"
}

#---------------------------------------------------------
# Blob for Single Container and Storage Account
#----------------------------------------------------------

resource "azurerm_storage_blob" "blob" {
  count                  = var.create_blob ? 1 : 0
  name                   = var.create_blob ? var.blob_name : null
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.container[count.index].name
  type                   = var.create_blob ? var.blob_type : null
  #source_uri             = var.create_blob ? var.source_uri : null
  source       = var.create_blob ? var.source_path : null
  content_type = var.create_blob ? var.content_type : null
}


# #---------------------------------------------------------
# #Blob for Multiple Containers and Storage Accounts (Optional)
# #----------------------------------------------------------

# resource "azurerm_storage_blob" "blob" {
#   for_each = var.blob_definitions

#   name                   = each.value.blob_name
#   storage_account_name   = each.value.storage_account_name
#   storage_container_name = each.value.container_name
#   type                   = each.value.blob_type
#   source_uri             = each.value.source_uri
#   content_type           = each.value.content_type
# }

#-------------------------------
# Storage Lifecycle Management
#-------------------------------
resource "azurerm_storage_management_policy" "lcpol" {
  count              = length(var.lifecycles) == 0 ? 0 : 1
  storage_account_id = azurerm_storage_account.sa.id

  dynamic "rule" {
    for_each = var.lifecycles
    iterator = rule
    content {
      name    = "rule${rule.key}"
      enabled = true
      filters {
        prefix_match = rule.value.prefix_match
        blob_types   = ["blockBlob"]
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than    = rule.value.tier_to_cool_after_days
          tier_to_archive_after_days_since_modification_greater_than = rule.value.tier_to_archive_after_days
          delete_after_days_since_modification_greater_than          = rule.value.delete_after_days
        }
        snapshot {
          delete_after_days_since_creation_greater_than = rule.value.snapshot_delete_after_days
        }
      }
    }
  }
}

#--------------------------------------
# Storage Advanced Threat Protection 
#--------------------------------------
resource "azurerm_advanced_threat_protection" "atp" {
  target_resource_id = azurerm_storage_account.sa.id
  enabled            = var.enable_advanced_threat_protection
}

