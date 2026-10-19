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

resource "azurerm_network_security_group" "web" {
  name                = "nsg-web"
  location            = azurerm_resource_group.cloud_project.location
  resource_group_name = azurerm_resource_group.cloud_project.name
}


variable "admin_ip" {
  description = "Your public IPv4 address, including /32"
  type        = string
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}

resource "azurerm_public_ip" "web" {
  name                = "pip-vm-web-01"
  location            = azurerm_resource_group.cloud_project.location
  resource_group_name = azurerm_resource_group.cloud_project.name

  allocation_method = "Static"
  sku               = "Standard"
  ip_version        = "IPv4"
  zones             = ["1"]
}

resource "azurerm_network_interface" "web" {
  name                = "vm-web-01851"
  location            = azurerm_resource_group.cloud_project.location
  resource_group_name = azurerm_resource_group.cloud_project.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web.id
  }
}

variable "admin_ssh_public_key" {
  description = "Existing SSH public key for the Linux VM"
  type        = string
}

resource "azurerm_linux_virtual_machine" "web" {
  name                = "vm-web-01"
  computer_name       = "vm-web-01"
  resource_group_name = azurerm_resource_group.cloud_project.name
  location            = azurerm_resource_group.cloud_project.location
  size                = "Standard_B2ats_v2"
  zone                = "1"

  admin_username                  = "cloudadmin"
  disable_password_authentication = true
  secure_boot_enabled             = true
  vtpm_enabled                    = true

  network_interface_ids = [
    azurerm_network_interface.web.id
  ]

  admin_ssh_key {
    username   = "cloudadmin"
    public_key = var.admin_ssh_public_key
  }

  os_disk {
    name                 = "vm-web-01_OsDisk_1_49b7e5b69e2c41b1b7cc442147431779"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 30
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "ubuntu-26_04-lts"
    sku       = "server"
    version   = "latest"
  }

  additional_capabilities {
    hibernation_enabled = false
    ultra_ssd_enabled   = false
  }

  boot_diagnostics {

  }
}