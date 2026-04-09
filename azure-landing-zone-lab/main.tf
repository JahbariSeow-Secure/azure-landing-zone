@"
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
"@ | Out-File -FilePath main.tf -Encoding utf8
