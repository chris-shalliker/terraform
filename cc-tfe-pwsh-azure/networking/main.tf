# provider "azurerm" {
#   features {}
# }

resource "azurerm_virtual_network" "ccvnet" {
  name                = var.virtual_network_name
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "frontend" {
  name                 = "frontend-snet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ccvnet.name
  # Generate a subnet using the CIDR of the VNet. Take the 1st element from the address_space as it's a list, with 1 member
  address_prefixes = [cidrsubnet(element(azurerm_virtual_network.ccvnet.address_space, 0), 2, 1)]
}

resource "azurerm_subnet" "backend" {
  name                 = "backend-snet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.ccvnet.name
  address_prefixes = [cidrsubnet(element(azurerm_virtual_network.ccvnet.address_space, 0), 2, 2)]
}

resource "azurerm_subnet_network_security_group_association" "cc" {
  subnet_id                 = azurerm_subnet.frontend.id
  network_security_group_id = azurerm_network_security_group.ccnsg.id
}