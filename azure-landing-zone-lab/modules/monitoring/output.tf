output "workspace_id" {
  value = azurerm_log_analytics_workspace.main.id
}

output "workspace_name" {
  value = azurerm_log_analytics_workspace.main.name
}
output "action_group_id" {
  value = azurerm_monitor_action_group.main.id
}
