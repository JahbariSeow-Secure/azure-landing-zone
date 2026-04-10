
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-landing-zone"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "hub_vnet" {
  name                       = "diag-vnet-hub"
  target_resource_id         = var.hub_vnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "spoke_vnet" {
  name                       = "diag-vnet-spoke1"
  target_resource_id         = var.spoke_vnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_activity_log_alert" "policy_violation" {
  name                = "alert-policy-violation"
  resource_group_name = var.resource_group_name
  location            = "global"
  scopes              = [var.subscription_id]
  description         = "Alert when a policy denial occurs"

  criteria {
    category       = "Policy"
    operation_name = "Microsoft.Authorization/policies/deny/action"
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

resource "azurerm_monitor_action_group" "main" {
  name                = "ag-platform-team"
  resource_group_name = var.resource_group_name
  short_name          = "platform"

  email_receiver {
    name          = "platform-engineer"
    email_address = var.alert_email
  }
}

resource "azurerm_policy_definition" "deploy_diagnostic_settings" {
  name                = "deploy-diagnostic-settings"
  policy_type         = "Custom"
  mode                = "All"
  display_name        = "Deploy diagnostic settings to Log Analytics"
  management_group_id = var.management_group_id

  policy_rule = <<POLICY
{
  "if": {
    "field": "type",
    "equals": "Microsoft.Compute/virtualMachines"
  },
  "then": {
    "effect": "deployIfNotExists",
    "details": {
      "type": "Microsoft.Insights/diagnosticSettings",
      "existenceCondition": {
        "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
        "equals": "${azurerm_log_analytics_workspace.main.id}"
      },
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ],
      "deployment": {
        "properties": {
          "mode": "incremental",
          "template": {
            "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "resourceId": { "type": "string" },
              "workspaceId": { "type": "string" }
            },
            "resources": [{
              "type": "Microsoft.Insights/diagnosticSettings",
              "apiVersion": "2021-05-01-preview",
              "name": "auto-diag-settings",
              "scope": "[parameters('resourceId')]",
              "properties": {
                "workspaceId": "[parameters('workspaceId')]",
                "metrics": [{ "category": "AllMetrics", "enabled": true }]
              }
            }]
          },
          "parameters": {
            "resourceId": { "value": "[field('id')]" },
            "workspaceId": { "value": "${azurerm_log_analytics_workspace.main.id}" }
          }
        }
      }
    }
  }
}
POLICY
}

resource "azurerm_management_group_policy_assignment" "deploy_diagnostic_settings" {
  name                 = "deploy-diag-settings"
  management_group_id  = var.management_group_id
  policy_definition_id = azurerm_policy_definition.deploy_diagnostic_settings.id
  display_name         = "Deploy diagnostic settings to Log Analytics"

  identity {
    type = "SystemAssigned"
  }

  location = var.location
}
