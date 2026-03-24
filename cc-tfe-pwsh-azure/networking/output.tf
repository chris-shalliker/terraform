output "frontend_subnet_id" {
  value = azurerm_subnet.frontend.id
}

output "backend_subnet_id" {
  value = azurerm_subnet.backend.id
}

output "nsg_id" {
  value = azurerm_network_security_group.ccnsg.id
}