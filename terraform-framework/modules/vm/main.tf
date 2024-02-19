variable "subnet_id" {}
variable "vm_os" {}
variable "vm_additional_config" {}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.vm_os}-vm"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_profile {
    computer_name  = "${var.vm_os}-vm"
    admin_username = "adminuser"
    admin_password = "Password1234!"  # You should use a more secure method for providing passwords
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = var.vm_os == "Windows" ? "MicrosoftWindowsServer" : "RedHat"
    offer     = var.vm_os == "Windows" ? "WindowsServer" : "RHEL"
    sku       = var.vm_os == "Windows" ? "2019-Datacenter" : "8.4"
    version   = var.vm_os == "Windows" ? "latest" : "latest"
  }

  vm_size = "Standard_DS2_v2"
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_os}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}
