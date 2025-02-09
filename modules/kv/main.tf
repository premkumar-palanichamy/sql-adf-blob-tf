#-------------------------------
# Local Declarations
#-------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp[*].name, azurerm_resource_group.rg[*].name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp[*].location, azurerm_resource_group.rg[*].location, [""]), 0)
}

data "azurerm_client_config" "current" {}

#---------------------------------------------------------
# Key-vault Creation or selection
#---------------------------------------------------------

resource "azurerm_key_vault" "kv" {
  name                = lower(var.kv_name)
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.skuname

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enable_rbac_authorization       = var.enable_rbac_authorization

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [true] : []
    content {
      bypass                     = var.network_acls.bypass
      default_action             = var.network_acls.default_action
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
    }
  }

  tags = merge({ "ResourceName" = lower(var.kv_name) }, var.tags, )
}

#---------------------------------------------------------
# Key-vault RBAC Policies
#---------------------------------------------------------

locals {
    principals = toset(var.principal_ids)
}

resource "azurerm_role_assignment" "role_assignment" {
    for_each = local.principals

    scope                            = var.scope_id
    role_definition_name             = var.role_definition_name
    principal_id                     = each.key
    skip_service_principal_aad_check = var.skip_service_principal_aad_check
}