resource "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                          = var.name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.law_sku
  retention_in_days             = var.retention_in_days
  tags                          = var.tags
  local_authentication_disabled = var.local_authentication_disabled

  dynamic "identity" {
    for_each = var.managed_identity_type != null ? [1] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }
}