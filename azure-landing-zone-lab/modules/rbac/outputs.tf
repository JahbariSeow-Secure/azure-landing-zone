output "platform_assignment_id" {
  value = azurerm_role_assignment.platform_team.id
}

output "workload_assignment_id" {
  value = azurerm_role_assignment.workload_team.id
}