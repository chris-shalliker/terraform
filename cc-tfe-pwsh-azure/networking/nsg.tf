data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
      ipaddress = ["${chomp(data.http.myip.body)}/32"]
}

resource "azurerm_network_security_group" "ccnsg" {
  name                = var.network_security_group_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "22-allow-ssh"
    description                = "Allow SSH access to the tfe VM"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = local.ipaddress
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "80-allow-http"
    description                = "Allow http access for tfe VM access"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = local.ipaddress
    destination_address_prefix = "*"
  }


  security_rule {
    name                       = "443-allow-https"
    description                = "Allow https access for tfe VM access"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = local.ipaddress
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "7990-allow-tfe-port"
    description                = "Allow tfe ports for tfe VM access"
    priority                   = 400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "7990"
    source_address_prefixes    = local.ipaddress
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "8800-allow-tfe-port"
    description                = "Allow tfe ports for tfe VM access"
    priority                   = 500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8800"
    source_address_prefixes    = local.ipaddress
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "8443allow-tfe-port"
    description                = "Allow tfe ports for tfe VM access"
    priority                   = 600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8443"
    source_address_prefixes    = local.ipaddress
    destination_address_prefix = "*"
  }

  tags = var.tags
}