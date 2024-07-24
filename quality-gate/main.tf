
#Mimicking Code Smells to showcase Qaulity gate Rules:
##Remark 
#Avoid hardcoding values (use variables instead)
resource "azurerm_resource_group" "rg" {
  name     = "my-resources"  # This should use a variable
  location = "East US"       # This should use a variable
}


#Mimicking Bugs to showcase Qaulity gate Rules: 
##Remark 
#Ensure all referenced resources exist
resource "azurerm_virtual_network" "vnet" {
  name                = "example-network"
  address_space       = "10.0.0.0/16"  # Incorrect data type, should be a list
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.non_existent.name  # Incorrect reference
  address_prefixes     = ["10.0.2.0/24"]
}
 
#Mimicking Vulnerabilities to showcase Qaulity gate Rules:
##Remark 
#Avoid exposing sensitive data
resource "azurerm_network_interface" "nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "my-vm" {
  name                  = "example-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"  # Hardcoded password (vulnerability)
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }
}


# More vulnerabilities: Exposed sensitive data in Key Vault
resource "azurerm_key_vault" "k-vault" {
  name                = "examplekeyvault"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = "11111111-1111-1111-1111-111111111111"  # Hardcoded tenant ID
  sku_name            = "standard"

  access_policy {
    tenant_id = "11111111-1111-1111-1111-111111111111"  # Hardcoded tenant ID
    object_id = "22222222-2222-2222-2222-222222222222"  # Hardcoded object ID

    key_permissions = [
      "Get", "List", "Create", "Delete", "Update",
    ]

    secret_permissions = [
      "Get", "List", "Set", "Delete",
    ]
  }
}

resource "azurerm_key_vault_secret" "k-vault-secret" {
  name         = "ExamplePassword"
  value        = "MyS3cretP@ssw0rd"  # Hardcoded secret
  key_vault_id = azurerm_key_vault.k-vault.id
}

#Mimicking Duplications to showcase Qaulity gate Rules:
#Remark 
#Avoid duplicate blocks (use modules or for_each instead)
resource "azurerm_storage_account" "storage1" {
  name                     = "storageaccount1"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_account" "storage2" {
  name                     = "storageaccount2"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_account" "storage3" {
  name                     = "storageaccount3"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}



#Mimicking Complexity to showcase Qaulity to showcase Qaulity gate Rules:
#Remark Avoid overly complex resource configurations (Overly complex resource with many nested blocks)
resource "azurerm_virtual_machine" "my-vm1" {
  name                  = "complex-vm"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "complexosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.storage1.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }

  plan {
    name      = "plan-name"
    publisher = "plan-publisher"
    product   = "plan-product"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  tags = {
    environment = "production"
    project     = "example"
    department  = "IT"
    cost_center = "CC001"
    owner       = "john.doe@example.com"
  }
}
