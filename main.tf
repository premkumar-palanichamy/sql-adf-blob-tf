module "adf" {
  source              = "./modules/adf"
  data_factory_name   = var.data_factory_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_zone_link_name  = var.data_factory_dns_zone_link_name
  virtual_network_id  = module.vnet.vnet_id
  subnet_id           = module.vnet.public_subnet_id[0]
  ir_type             = var.integration_runtime_type
  ir_cname            = var.integration_custom_name
  ir_desp             = var.integration_runtime_description
  ir_config           = var.integration_runtime_config

  github_account_name    = var.github_account_name
  github_repository_name = var.github_repository_name
  github_branch_name     = var.github_branch_name
  github_root_folder     = var.github_root_folder
  github_url             = var.github_url

  private_endpoint_blob_name           = var.private_endpoint_blob_name
  sql_username                         = var.sql_username
  private_service_connection_blob_name = var.private_service_connection_blob_name
  sql_server_name                      = var.sql_server_name
  sql_password                         = var.sql_password
  sql_database_name                    = var.sql_database_name
  private_service_connection_adf_name  = var.private_service_connection_adf_name
  private_endpoint_adf_name            = var.private_endpoint_adf_name
}

module "vnet" {
  source                 = "./modules/vnet"
  vnet_name              = var.vnet_name
  address_space          = var.address_space
  location               = var.location
  resource_group_name    = var.resource_group_name
  tags                   = var.tags
  public_address_prefix  = var.public_address_prefix
  private_address_prefix = var.private_address_prefix
  public_ip_name         = var.public_ip_name
  nic_name               = var.nic_name
}

module "sa" {
  source                            = "./modules/sa"
  resource_group_name               = var.resource_group_name
  location                          = var.location
  name                              = var.storage_account_name
  tags                              = var.tags
  account_kind                      = var.account_kind
  account_tier                      = var.account_tier
  access_tier                       = var.access_tier
  replication_type                  = var.replication_type
  enable_hns                        = var.enable_hns
  enable_sftp                       = var.enable_sftp
  enable_https_traffic_only         = var.enable_https_traffic_only
  min_tls_version                   = var.min_tls_version
  shared_access_key_enabled         = var.shared_access_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled
  enable_advanced_threat_protection = var.enable_advanced_threat_protection
  container                         = var.container
  create_blob                       = var.create_blob
  blob_name                         = var.blob_name
  blob_type                         = var.blob_type
  default_to_oauth_authentication   = var.default_to_oauth_authentication
  source_path                       = "${path.module}/files/sample.txt"
  content_type                      = var.content_type
  access_list                       = var.access_list

  managed_identity_type = var.managed_identity_type
  managed_identity_ids  = var.managed_identity_ids

  default_network_rule = var.default_network_rule

  # Blob lifecycle policies (optional)
  lifecycles = var.lifecycles

  # Encryption scope (optional)
  encryption_scopes = var.encryption_scopes
}

module "kv" {
  source                           = "./modules/kv"
  kv_name                          = var.kv_name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  skuname                          = var.kv_skuname
  enabled_for_deployment           = var.enabled_for_deployment
  enabled_for_disk_encryption      = var.enabled_for_disk_encryption
  enabled_for_template_deployment  = var.enabled_for_template_deployment
  soft_delete_retention_days       = var.soft_delete_retention_days
  purge_protection_enabled         = var.purge_protection_enabled
  enable_rbac_authorization        = var.enable_rbac_authorization
  tags                             = var.tags
  principal_ids                    = var.principal_ids
  role_definition_name             = var.role_definition_name
  scope_id                         = var.scope_id
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}

module "law" {
  source                        = "./modules/law"
  name                          = var.law_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  law_sku                       = var.law_sku
  retention_in_days             = var.retention_in_days
  tags                          = var.tags
  managed_identity_type         = var.managed_identity_type
  managed_identity_ids          = var.managed_identity_ids
  local_authentication_disabled = var.local_authentication_disabled
}

module "vm" {
  source              = "./modules/vm"
  vm_name             = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  nic_id              = module.network.nic_id
  vnet_name           = module.vnet.vnet_name
  subnet_name         = module.vnet.subnet_name
  public_ip           = module.vnet.public_ip
  # storage_account_key  = module.sa.storage_account_primary_access_key
  tags         = var.tags
  adf_auth_key = module.adf.auth_key_1
}

################################################
# PowerBI Automation
################################################

resource "azurerm_key_vault_secret" "pbi_client_id" {
  name         = "powerbi-client-id"
  value        = var.pbi_client_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "pbi_client_secret" {
  name         = "powerbi-client-secret"
  value        = var.pbi_client_secret
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "pbi_tenant_id" {
  name         = "powerbi-tenant-id"
  value        = var.pbi_tenant_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "pbi_group_id" {
  name         = "powerbi-group-id"
  value        = var.pbi_group_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "pbi_dataset_id" {
  name         = "powerbi-dataset-id"
  value        = var.pbi_dataset_id
  key_vault_id = azurerm_key_vault.kv.id
}

resource "azurerm_automation_account" "automation" {
  name                = "pbiAutomation"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
}


data "local_file" "powerbi_ps1" {
  filename = "${path.module}/refresh_powerbi.ps1"
}
resource "azurerm_automation_runbook" "refresh_powerbi" {
  name                    = "PowerBI_Refresh"
  location                = var.location
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation.name
  log_verbose             = "true"
  log_progress            = "true"
  runbook_type            = "PowerShell"
  content                 = data.local_file.powerbi_ps1 # Uploads PowerShell script
}
resource "azurerm_automation_schedule" "schedule" {
  name                    = "EveryHour"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation.name
  frequency               = "Hour"
  interval                = 1
  timezone                = "UTC"
}

resource "azurerm_automation_job_schedule" "powerbi_refresh_schedule" {
  automation_account_name = azurerm_automation_account.automation.name
  resource_group_name     = var.resource_group_name
  runbook_name            = azurerm_automation_runbook.refresh_powerbi.name
  schedule_name           = azurerm_automation_schedule.schedule.name
}
