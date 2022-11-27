
# Network Parts
resource "azurerm_virtual_network" "quick-network" {
  name                = "quick-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.quickie.location
  resource_group_name = azurerm_resource_group.quickie.name
}

resource "azurerm_subnet" "quick-internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.quickie.name
  virtual_network_name = azurerm_virtual_network.quick-network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "ns1-public" {
  name                = "ns1-public"
  resource_group_name = azurerm_resource_group.quickie.name
  location            = azurerm_resource_group.quickie.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ns1" {
  name                = "ns1-nic"
  location            = azurerm_resource_group.quickie.location
  resource_group_name = azurerm_resource_group.quickie.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.quick-internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ns1-public.id
  }
}

# Network Security parts
resource "azurerm_network_security_group" "all-tcp-ports-from-home" {
  name                = "all-tcp-ports-from-home"
  location            = azurerm_resource_group.quickie.location
  resource_group_name = azurerm_resource_group.quickie.name
}

resource "azurerm_network_security_rule" "port-53" {
  name                        = "port 53"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "73.153.20.161/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.quickie.name
  network_security_group_name = azurerm_network_security_group.all-tcp-ports-from-home.name
}



# VM bit
resource "azurerm_linux_virtual_machine" "ns1" {
  name                = "ns1.azure.playtechnique.io"
  resource_group_name = azurerm_resource_group.quickie.name
  location            = azurerm_resource_group.quickie.location
  size                = "Standard_D2as_v4"
  admin_username      = "wendy"

  priority = "Spot"
  eviction_policy = "Deallocate"
  network_interface_ids = [
    azurerm_network_interface.ns1.id,
  ]

  admin_ssh_key {
    username   = "wendy"
    public_key = azurerm_ssh_public_key.my-generic-keypair.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

output "ssh-instructions" {
  value = "${azurerm_linux_virtual_machine.ns1.admin_username}@${azurerm_linux_virtual_machine.ns1.public_ip_address}"
}

output "ns1-public-address" {
  value = "${azurerm_linux_virtual_machine.ns1.public_ip_address}"
}
