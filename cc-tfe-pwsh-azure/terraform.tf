# Remote state location
terraform {
  backend "azurerm" {
    resource_group_name  = "cc-euw-tfstate-rg"
    storage_account_name = "cceuwstate"
    container_name       = "terraform-tfe"
    key                  = "terraform-cs.tfstate"
  }
}
