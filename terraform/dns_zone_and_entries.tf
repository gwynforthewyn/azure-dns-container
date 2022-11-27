
resource "azurerm_dns_zone" "azure_pt_io" {
  name                = "azure.playtechnique.io"
  resource_group_name = azurerm_resource_group.quickie.name
}

resource "azurerm_dns_a_record" "ns1" {
  name                = "ns1"
  zone_name           = azurerm_dns_zone.azure_pt_io.name
  resource_group_name = azurerm_resource_group.quickie.name
  ttl                 = 5
  records              = [azurerm_linux_virtual_machine.ns1.public_ip_address]
}
