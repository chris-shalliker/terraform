variable "prefix" {
  type    = string
  default = "cc"
}

variable "location" {
  type    = string
  default = ""
}

variable "vnet_address_space" {
  type    = list(string)
  default = [""]
}

variable "resource_name" {
  type    = string
  default = "example_resource_name"
}

variable "tags" {
  type = map(string)
  default = {
    "Owner" = "example_owner_name"
  }
}

variable "location_prefix" {
  type = map(string)
  default = {
    "westeurope"  = "euw"
    "northeurope" = "eun"
    "uksouth"     = "uks"
    "ukwest"      = "ukw"
  }
}

variable "virtual_machine" {
  type = object({
    size = string
    sku  = string
  })
  default = {
    size = ""
    sku  = "7.7"
  }
}
