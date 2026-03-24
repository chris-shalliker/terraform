# Location for all resources
location = "westeurope"

# Prefix used by all resources and used as the Admin username
prefix = "tfe"

# Name used by all resources
resource_name = "chris-shalliker"

# VNet address space
vnet_address_space = ["192.168.73.0/24"]

# List of tags to apply to all resources
tags = {
  "Owner"       = "Chris Shalliker"
  "Environment" = "Development"
  "Application" = "TFE"
}

virtual_machine = {
  size = "Standard_B4ms"
  sku  = "7.7"
}