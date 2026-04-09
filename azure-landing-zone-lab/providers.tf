terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.80.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate8274"
    container_name       = "tfstate"
    key                  = "landing-zone.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "7b3cde72-e4eb-4411-bab1-dcd81a2f7ca3"
}
