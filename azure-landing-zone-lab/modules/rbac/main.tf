resource "azurerm_role_assignment" "platform_team" {
  scope                = var.platform_scope
  role_definition_name = "Contributor"
  principal_id         = var.platform_object_id
}

resource "azurerm_role_assignment" "workload_team" {
  scope                = var.workload_scope
  role_definition_name = "Contributor"
  principal_id         = var.workload_object_id
}