resource "azurerm_management_group" "landing_zone" {
  display_name = var.display_name
  name         = var.name
}