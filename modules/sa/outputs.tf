######## Outputs ########
output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, azurerm_resource_group.rg.*.id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

output "sa" {
  value       = azurerm_storage_account.sa
  sensitive   = true
  description = "The Storage Account object."
}

output "name" {
  value       = azurerm_storage_account.sa.name
  description = "The name of the Storage Account."
}

output "id" {
  value       = azurerm_storage_account.sa.id
  description = "The ID of the Storage Account."
}

output "primary_access_key" {
  value       = azurerm_storage_account.sa.primary_access_key
  sensitive   = true
  description = "The primary access key for the storage account."
}

output "secondary_access_key" {
  value       = azurerm_storage_account.sa.secondary_access_key
  sensitive   = true
  description = "The secondary access key for the storage account."
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.sa.primary_blob_endpoint
  description = "The endpoint URL for blob storage in the primary location."
}

output "primary_blob_host" {
  value       = azurerm_storage_account.sa.primary_blob_host
  description = "The endpoint host for blob storage in the primary location."
}

output "secondary_blob_endpoint" {
  value       = azurerm_storage_account.sa.secondary_blob_endpoint
  description = "The endpoint URL for blob storage in the secondary location."
}

output "secondary_blob_host" {
  value       = azurerm_storage_account.sa.secondary_blob_host
  description = "The endpoint host for blob storage in the secondary location."
}

output "primary_connection_string" {
  value       = azurerm_storage_account.sa.primary_connection_string
  sensitive   = true
  description = "The connection string associated with the primary location."
}

output "secondary_connection_string" {
  value       = azurerm_storage_account.sa.secondary_connection_string
  sensitive   = true
  description = "The connection string associated with the secondary location."
}

output "primary_blob_connection_string" {
  value       = azurerm_storage_account.sa.primary_blob_connection_string
  sensitive   = true
  description = "The connection string associated with the primary blob location."
}

output "secondary_blob_connection_string" {
  value       = azurerm_storage_account.sa.secondary_blob_connection_string
  sensitive   = true
  description = "The connection string associated with the secondary blob location."
}

output "principal_id" {
  value       = azurerm_storage_account.sa.identity.0.principal_id
  description = "The Principal ID for the Service Principal associated with the Identity of this Storage Account."
}

output "tenant_id" {
  value       = azurerm_storage_account.sa.identity.0.tenant_id
  description = "The Tenant ID for the Service Principal associated with the Identity of this Storage Account."
}

output "encryption_scope_ids" {
  description = "encryption scope info."
  value = { for k, v in var.encryption_scopes :
    k => azurerm_storage_encryption_scope.scope[k].id
  }
}