output "data_factory_id" {
  description = "The ID of the Data Factory"
  value       = azurerm_data_factory.adf.id
}

output "data_factory_name" {
  description = "The name of the Data Factory"
  value       = azurerm_data_factory.adf.name
}

output "private_endpoint_id" {
  description = "The ID of the Private Endpoint"
  value       = azurerm_private_endpoint.pe_datafactory.id
}

output "private_dns_zone_id" {
  description = "The ID of the Private DNS Zone"
  value       = azurerm_private_dns_zone.dns_zone.id
}