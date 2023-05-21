variable "instance_name" {
    type = string
    description = "Instance name"
    default = "no-name"
    sensitive = false
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

resource "azurerm_network_interface" "main" {
  name                = "${var.instance_name}-nic"
  resource_group_name = "nn-resources"
  location            = "eastus"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "/subscriptions/06279288-ad3e-4f1a-8a28-bba3c378996c/resourceGroups/nn-resources/providers/Microsoft.Network/virtualNetworks/nn-network/subnets/internal"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                            = var.instance_name
  resource_group_name             = "nn-resources"
  location                        = "eastus"
  size                            = "Standard_F2"
  admin_username                  = "adminuser"
  disable_password_authentication = false
  admin_password                  = "!AdminPass"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}