output "vnet_id" {
  description = "The ID of the created Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = azurerm_subnet.pub_subnet[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = azurerm_subnet.pvt_subnets[*].id
}

output "nic_id" {
  description = "The ID of the created Network Interface"
  value       = azurerm_network_interface.nic.id
}

output "public_ip_id" {
  description = "The ID of the created Public IP"
  value       = azurerm_public_ip.public_ip.id
}
