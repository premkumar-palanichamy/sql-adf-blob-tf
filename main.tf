module "adf" {
  source              = "./modules/adf"
  data_factory_name   = var.data_factory_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_zone_link_name  = var.data_factory_dns_zone_link_name
  virtual_network_id  = "/subscriptions/e8d19c40-8211-40d2-985f-800fd1402b70/resourceGroups/bkn301-production-resource-group/providers/Microsoft.Network/virtualNetworks/bkn301-production-vnet-north-italy"
  subnet_id           = "/subscriptions/e8d19c40-8211-40d2-985f-800fd1402b70/resourceGroups/bkn301-production-resource-group/providers/Microsoft.Network/virtualNetworks/bkn301-production-vnet-north-italy/subnets/bkn301-production-vnet-north-italy-private-subnet-4"
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
