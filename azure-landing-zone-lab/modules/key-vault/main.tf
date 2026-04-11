
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                          = var.key_vault_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  rbac_authorization_enabled    = true
  public_network_access_enabled = true

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
}

resource "azurerm_role_assignment" "pipeline_secret_reader" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.pipeline_principal_id
}

resource "azurerm_role_assignment" "admin_secret_officer" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.admin_principal_id
}

resource "azurerm_private_endpoint" "key_vault" {
  name                = "pe-key-vault"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-key-vault"
    private_connection_resource_id = azurerm_key_vault.main.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  value        = "this-is-a-placeholder-value"
  key_vault_id = azurerm_key_vault.main.id

  depends_on = [
    azurerm_role_assignment.admin_secret_officer
  ]
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-key-vault"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_log {
    category = "AzurePolicyEvaluationDetails"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_activity_log_alert" "key_vault_delete" {
  name                = "alert-key-vault-delete"
  resource_group_name = var.resource_group_name
  location            = "global"
  scopes              = [var.subscription_id]
  description         = "Alert when Key Vault or secret is deleted"

  criteria {
    resource_id    = azurerm_key_vault.main.id
    category       = "Administrative"
    operation_name = "Microsoft.KeyVault/vaults/delete"
  }

  action {
    action_group_id = var.action_group_id
  }
}
