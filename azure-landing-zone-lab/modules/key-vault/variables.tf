
variable "key_vault_name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type = string
}

variable "pipeline_principal_id" {
  type = string
}

variable "admin_principal_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "action_group_id" {
  type = string
}
