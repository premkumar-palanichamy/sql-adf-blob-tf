output "id" {
  description = "The Log Analytics Workspace ID."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.id
}

output "workspace_id" {
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.workspace_id
}

output "name" {
  description = "The Log Analytics Workspace name."
  value       = var.name
}

output "primary_shared_key" {
  description = "Value of the primary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.primary_shared_key
}

output "secondary_shared_key" {
  description = "Value of the secondary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.log_analytics_workspace.secondary_shared_key

}