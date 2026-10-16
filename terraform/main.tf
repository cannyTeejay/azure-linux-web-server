terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cloud_project" {
  name     = "rg-cloud-project"
  location = "South Africa North"
}

resource "azurerm_virtual_network" "cloud_project" {
  name                = "vnet-cloud-project"
  location            = azurerm_resource_group.cloud_project.location
  resource_group_name = azurerm_resource_group.cloud_project.name
  address_space       = ["10.10.0.0/16"]
}

resource "azurerm_subnet" "web" {
  name                 = "snet-web"
  resource_group_name  = azurerm_resource_group.cloud_project.name
  virtual_network_name = azurerm_virtual_network.cloud_project.name
  address_prefixes     = ["10.10.1.0/24"]

  default_outbound_access_enabled = false
}