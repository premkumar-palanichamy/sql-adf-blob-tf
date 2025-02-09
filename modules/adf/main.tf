resource "azurerm_data_factory" "adf" {
  name                            = var.data_factory_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  public_network_enabled          = var.public_network_enabled
  managed_virtual_network_enabled = true

  github_configuration {
    account_name       = var.github_account_name
    repository_name    = var.github_repository_name
    branch_name        = var.github_branch_name
    root_folder        = var.github_root_folder
    git_url            = var.github_url
    publishing_enabled = true
  }
}

resource "azurerm_data_factory_integration_runtime_azure" "ir_azure" {
  count = var.ir_type == "Azure" ? 1 : 0

  data_factory_id = azurerm_data_factory.adf.id
  name            = var.ir_cname
  location        = var.location
  description     = var.ir_desp

  cleanup_enabled         = lookup(var.ir_config, "cleanup_enabled", null)
  compute_type            = lookup(var.ir_config, "compute_type", "General")
  core_count              = lookup(var.ir_config, "core_count", 8)
  time_to_live_min        = lookup(var.ir_config, "time_to_live_min", 60)
  virtual_network_enabled = lookup(var.ir_config, "virtual_network_enabled", true)
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "ir_self" {
  count = var.ir_type == "SelfHosted" ? 1 : 0

  data_factory_id = azurerm_data_factory.adf.id
  name            = var.ir_cname
  description     = var.ir_desp
}

resource "azurerm_data_factory_integration_runtime_azure_ssis" "ir_ssis" {
  count = var.ir_type == "AzureSSIS" ? 1 : 0

  data_factory_id = azurerm_data_factory.adf.id
  name            = var.ir_cname
  location        = var.location
  description     = var.ir_desp

  node_size                        = lookup(var.ir_config, "node_size", null)
  number_of_nodes                  = lookup(var.ir_config, "number_of_nodes", 1)
  max_parallel_executions_per_node = lookup(var.ir_config, "max_parallel_executions_per_node", 1)
  edition                          = lookup(var.ir_config, "edition", "Standard")
  license_type                     = lookup(var.ir_config, "license_type", "LicenseIncluded")
}

resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = var.dns_zone_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = var.private_dns_zone_name
  virtual_network_id    = var.virtual_network_id
}

# 🔹 Private Endpoint for Azure Data Factory
resource "azurerm_private_endpoint" "pe_datafactory" {
  name                = var.private_endpoint_adf_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_adf_name
    private_connection_resource_id = azurerm_data_factory.adf.id
    is_manual_connection           = false
    subresource_names              = ["dataFactory"]  # ✅ ADF private link
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone.id]
  }
}

# 🔹 Private Endpoint for Azure Blob Storage
resource "azurerm_private_endpoint" "pe_blob" {
  name                = var.private_endpoint_blob_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_blob_name
    private_connection_resource_id = azurerm_storage_account.storage.id
    is_manual_connection           = false
    subresource_names              = ["blob"]  # ✅ Blob private link
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone.id]
  }
}

# 🔹 Linked Service for On-Prem SQL Server
resource "azurerm_data_factory_linked_service_sql_server" "sql_linked_service" {
  name              = "OnPremSQLServerLinkedService"
  data_factory_id   = azurerm_data_factory.adf.id
  description       = "Linked Service to connect ADF with On-Prem SQL Server"
  
  # Use Self-Hosted IR for on-prem connectivity
  integration_runtime_name = azurerm_data_factory_integration_runtime_self_hosted.ir_self[0].name

  connection_string = <<-EOT
    Data Source=${var.sql_server_name};
    Initial Catalog=${var.sql_database_name};
    User ID=${var.sql_username};
    Password=${var.sql_password};
    Integrated Security=False;
  EOT

  parameters = var.sql_parameters
}


  # dynamic "timeouts" {
  #   for_each = var.timeouts
  #   content {
  #     create = timeouts.value["create"]
  #     delete = timeouts.value["delete"]
  #     read   = timeouts.value["read"]
  #     update = timeouts.value["update"]
  #   }
  # }