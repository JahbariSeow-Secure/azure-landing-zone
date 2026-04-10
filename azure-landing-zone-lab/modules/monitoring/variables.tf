
variable "location" {
  type    = string
  default = "eastus"
}

variable "resource_group_name" {
  type = string
}

variable "hub_vnet_id" {
  type = string
}

variable "spoke_vnet_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "management_group_id" {
  type = string
}

variable "alert_email" {
  type = string
}
