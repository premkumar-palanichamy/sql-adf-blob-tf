resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [var.nic_id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-smalldisk"
    version   = "latest"
  }

  tags = var.tags
}

# Install ADF Self-Hosted Integration Runtime
resource "azurerm_virtual_machine_extension" "adf_runtime" {
  name                 = "ADFIntegrationRuntime"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["${path.module}/install_adf_runtime.ps1"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File install_adf_runtime.ps1"
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -Command [System.Environment]::SetEnvironmentVariable('ADF_AUTH_KEY', '${var.adf_auth_key}', 'Machine'); powershell -ExecutionPolicy Unrestricted -File install_adf_runtime.ps1"
    }
PROTECTED_SETTINGS
}