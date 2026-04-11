module "management_groups" {
  source       = "./modules/management-groups"
  display_name = "Landing Zone"
  name         = "mg-landing-zone"
}

module "policy" {
  source = "./modules/policy"
  scope  = module.management_groups.id
}

module "networking" {
  source   = "./modules/networking"
  location = "eastus"
}

module "rbac" {
  source             = "./modules/rbac"
  platform_scope     = module.networking.hub_vnet_id
  workload_scope     = module.networking.spoke1_vnet_id
  platform_object_id = "adf1cf26-8411-4be4-b76c-16ad514df6ad"
  workload_object_id = "adf1cf26-8411-4be4-b76c-16ad514df6ad"
}
module "monitoring" {
  source              = "./modules/monitoring"
  location            = "eastus"
  resource_group_name = "rg-hub"
  hub_vnet_id         = module.networking.hub_vnet_id
  spoke_vnet_id       = module.networking.spoke1_vnet_id
  subscription_id     = "/subscriptions/7b3cde72-e4eb-4411-bab1-dcd81a2f7ca3"
  management_group_id = module.management_groups.id
  alert_email         = "leeseow12@gmail.com"
}
module "key_vault" {
  source                     = "./modules/key-vault"
  key_vault_name             = "kv-landing-zone-lab"
  location                   = "eastus"
  resource_group_name        = "rg-hub"
  pipeline_principal_id      = "27931c5f-125f-4bb8-85a2-d1f412912974"
  admin_principal_id         = "adf1cf26-8411-4be4-b76c-16ad514df6ad"
  subnet_id                  = module.networking.hub_subnet_id
  log_analytics_workspace_id = module.monitoring.workspace_id
  subscription_id            = "/subscriptions/7b3cde72-e4eb-4411-bab1-dcd81a2f7ca3"
  action_group_id            = module.monitoring.action_group_id
}
