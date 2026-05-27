resource "azurerm_public_ip" "publicIP" {
  name                = "public_IP"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  sku                 = "Standard"
  allocation_method   = "Static"
  depends_on          = [azurerm_resource_group.RG1]
}
output "Public_IP" {
  value = azurerm_public_ip.publicIP.ip_address
}
