terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "network_rg" {
  name     = "bhup0006-cst8918-network-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "main_vnet" {
  name                = "bhup0006-vnet"
  address_space       = ["10.0.0.0/14"]
  location            = azurerm_resource_group.network_rg.location
  resource_group_name = azurerm_resource_group.network_rg.name
}

resource "azurerm_subnet" "prod_subnet" {
  name                 = "prod-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "test_subnet" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "dev_subnet" {
  name                 = "dev-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "admin_subnet" {
  name                 = "admin-subnet"
  resource_group_name  = azurerm_resource_group.network_rg.name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = ["10.3.0.0/16"]
}

output "resource_group_name" {
  value = azurerm_resource_group.network_rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.main_vnet.name
}

output "subnet_ids" {
  value = {
    prod  = azurerm_subnet.prod_subnet.id
    test  = azurerm_subnet.test_subnet.id
    dev   = azurerm_subnet.dev_subnet.id
    admin = azurerm_subnet.admin_subnet.id
  }
}