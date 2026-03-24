variable "location" {
  type    = string
  default = "westeurope"
}

variable "virtual_machine" {
  type = object({
    size        = string
    user_name   = string
    public_key  = string
    private_key = string
    sku         = string
  })
  default = {
    size        = ""
    user_name   = "cc"
    public_key  = ""
    private_key = ""
    sku         = "7.7"
  }
}

variable "resource_group_name" {
  type    = string
  default = "example_resource_group_name"
}

variable "frontend_subnet_id" {
  type    = string
  default = ""
}

variable "backend_subnet_id" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(string)
  default = {
    "Owner" = "example_owner_name"
  }
}

variable "password" {
  type    = string
  default = ""
}

variable "network_security_group_id" {
  type    = string
  default = ""
}