output "Resource_group_name" {
  value = azurerm_resource_group.RG1.name
}
output "msg" {
    value = "The IP address of the webapp.gowtham.living is ${azurerm_public_ip.publicIP.ip_address}"
  
}