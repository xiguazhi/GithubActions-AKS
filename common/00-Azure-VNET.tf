data "azurerm_resource_group" "rgrp" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name = upper(format("%s-VNET", var.resource_prefix))
  location = data.azurerm_resource_group.rgrp.location
  resource_group_name = var.resource_group_name
  address_space = ["10.0.2.0/16"]
  dns_servers = ["168.63.129.16"]

}


resource "azurerm_subnet" "subnet" {
  name = upper(format("%s-%s-SUB", var.resource_prefix, var.subnet_name))
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["10.0.2.10/24"]
  service_endpoints = [
  "Microsoft.AzureActiveDirectory",
  "MicrosoftContainerRegistry", 
  "Microsoft.Storage", 
  "Microsoft.KeyVault"
  ]
    delegation {
    name = "delegation" 
    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}