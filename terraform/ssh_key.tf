
resource "azurerm_ssh_public_key" "my-generic-keypair" {
  name                = "my-generic-keypair"
  resource_group_name = azurerm_resource_group.quickie.name
  location            = azurerm_resource_group.quickie.location
  public_key          = file("ssh_key/id_rsa.pub")
}
