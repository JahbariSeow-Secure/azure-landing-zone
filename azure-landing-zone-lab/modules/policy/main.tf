resource "azurerm_policy_definition" "require_tag_environment" {
  name                = "require-tag-environment"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Require environment tag"
  management_group_id = var.scope

  policy_rule = <<POLICY
{
  "if": {
    "field": "tags['environment']",
    "equals": ""
  },
  "then": {
    "effect": "deny"
  }
}
POLICY
}
resource "azurerm_management_group_policy_assignment" "require_tag_environment_assignment" {
  name                 = "require-tag-env"
  display_name         = "Require environment tag"
  management_group_id  = var.scope
  policy_definition_id = azurerm_policy_definition.require_tag_environment.id
}