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
  platform_object_id = "ca1f12a4-4a72-4d81-a114-0d6608c8571b"
  workload_object_id = "ca1f12a4-4a72-4d81-a114-0d6608c8571b"
}