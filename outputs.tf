# Outputs for the ADF module
output "adf_id" {
  description = "The ID of the Azure Data Factory."
  value       = module.adf.adf_id
}

output "adf_name" {
  description = "The name of the Azure Data Factory."
  value       = module.adf.adf_name
}

output "adf_managed_virtual_network_enabled" {
  description = "Whether the managed virtual network is enabled for the Data Factory."
  value       = module.adf.adf_managed_virtual_network_enabled
}

output "adf_github_configuration" {
  description = "The GitHub configuration for the Data Factory."
  value       = module.adf.adf_github_configuration
}

output "adf_integration_runtime_id" {
  description = "The ID of the Integration Runtime."
  value       = module.adf.adf_integration_runtime_id
}

output "adf_private_endpoint_id" {
  description = "The ID of the Private Endpoint for the Data Factory."
  value       = module.adf.adf_private_endpoint_id
}

output "adf_private_dns_zone_id" {
  description = "The ID of the Private DNS Zone for the Data Factory."
  value       = module.adf.adf_private_dns_zone_id
}

# Outputs for the VNet module
output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = module.vnet.vnet_id
}

output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = module.vnet.vnet_name
}

output "public_subnet_id" {
  description = "The ID of the public subnet."
  value       = module.vnet.public_subnet_id
}

output "private_subnet_id" {
  description = "The ID of the private subnet."
  value       = module.vnet.private_subnet_id
}

output "public_ip_id" {
  description = "The ID of the public IP address."
  value       = module.vnet.public_ip_id
}

output "nic_id" {
  description = "The ID of the Network Interface."
  value       = module.vnet.nic_id
}

# Outputs for the Storage Account module
output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = module.sa.storage_account_id
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = module.sa.storage_account_name
}

output "storage_account_primary_access_key" {
  description = "The primary access key for the Storage Account."
  value       = module.sa.storage_account_primary_access_key
  sensitive   = true
}

output "storage_account_secondary_access_key" {
  description = "The secondary access key for the Storage Account."
  value       = module.sa.storage_account_secondary_access_key
  sensitive   = true
}

output "storage_container_id" {
  description = "The ID of the Storage Container."
  value       = module.sa.storage_container_id
}

output "storage_blob_id" {
  description = "The ID of the Storage Blob."
  value       = module.sa.storage_blob_id
}

output "storage_account_managed_identity_id" {
  description = "The ID of the Managed Identity associated with the Storage Account."
  value       = module.sa.storage_account_managed_identity_id
}

output "storage_account_encryption_scopes" {
  description = "The encryption scopes configured for the Storage Account."
  value       = module.sa.storage_account_encryption_scopes
}

output "storage_account_lifecycle_policies" {
  description = "The lifecycle policies configured for the Storage Account."
  value       = module.sa.storage_account_lifecycle_policies
}