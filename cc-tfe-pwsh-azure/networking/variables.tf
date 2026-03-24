variable "location" {
  type    = string
  default = "westeurope"
}

variable "virtual_network_name" {
  type    = string
  default = "example_vnet_name"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.0.0.0/16"]
}

variable "resource_group_name" {
  type    = string
  default = "example_resourcegroup_name"
}

variable "tags" {
  type = map(string)
  default = {
    "Owner" = "example_owner_name"
  }
}

variable "network_security_group_name" {
  type    = string
  default = "example_network_security_group_name"
}