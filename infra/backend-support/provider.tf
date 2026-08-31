terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "news4321_rg_joi_interview"
    storage_account_name = "news4321joiinterview"
    container_name       = "news4321terraformcontainerjoiinterview"
    key                  = "base/terraform.tfstate"
  }  
}

provider "azurerm" {
  features {}
}