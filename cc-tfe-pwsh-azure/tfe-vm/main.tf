resource "azurerm_network_interface" "cctfenic" {
  name                = local.tfe_vm_nic_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.backend_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cctfepip.id
  }
}

resource "azurerm_public_ip" "cctfepip" {
  name                    = local.tfe_vm_pip_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30
  domain_name_label       = local.resource_name
  tags                    = var.tags
}

resource "azurerm_linux_virtual_machine" "cctfevm" {
  name                  = local.tfe_vm_name
  location              = var.location
  size                  = var.virtual_machine.size
  admin_username        = var.virtual_machine.user_name
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.cctfenic.id]
  custom_data           = base64encode(file("scripts/deploy-tfe.sh"))

  os_disk {
    name                 = "${local.tfe_vm_name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    disk_size_gb         = 60
  }

  source_image_reference {
    publisher = "openlogic"
    offer     = "centos"
    sku       = var.virtual_machine.sku
    version   = "latest"
  }

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.virtual_machine.user_name
    public_key = var.virtual_machine.public_key
  }

  connection {
    type        = "ssh"
    user        = var.virtual_machine.user_name
    private_key = var.virtual_machine.private_key
    host        = azurerm_public_ip.cctfepip.fqdn
  }

  provisioner "file" {
    source      = "scripts/tfe_license.rli"
    destination = "/tmp/license.rli"
  }

  provisioner "file" {
    source      = "scripts/settings.json"
    destination = "/tmp/settings.json"
  }

    provisioner "file" {
    source      = "scripts/Config-Terraform-Azure.ps1"
    destination = "/tmp/Config-Terraform-Azure.ps1"
  }

  tags = var.tags
}