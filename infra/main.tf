resource "azurerm_resource_group" "RG1" {
  name     = "learn-terraform-rg-${formatdate("DD-MMM", timestamp())}"
  location = "eastus"
  lifecycle {
    ignore_changes = [ name ]
  }
}
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  address_space       = ["10.0.0.0/8"]
  depends_on          = [azurerm_resource_group.RG1]
}
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.0.0/16"]
  depends_on           = [azurerm_virtual_network.vnet]
}
resource "azurerm_network_interface" "nic" {
  name                = "nic1"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  depends_on          = [azurerm_subnet.subnet]
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.1.0.10"
    public_ip_address_id          = azurerm_public_ip.publicIP.id
  }
}
# 
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg1"
  resource_group_name = azurerm_resource_group.RG1.name
  location            = azurerm_resource_group.RG1.location
  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
# 
}
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "vm1"
  resource_group_name             = azurerm_resource_group.RG1.name
  location                        = azurerm_resource_group.RG1.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.nic.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  # Spot VM settings
  priority        = "Spot"
  eviction_policy = "Deallocate"
  # -1 means pay up to on-demand price
  max_bid_price = -1
  custom_data = base64encode(
    templatefile("${path.module}/scripts/cloud-init.yaml", {})
  )
  lifecycle {
    create_before_destroy = true
  }
}
# Associate NSG with Subnet
resource "azurerm_subnet_network_security_group_association" "subnet_nsg_association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "cloudflare_dns_record" "gowtham_living" {
  zone_id         = "${var.zone_ID}"
  name            = "webapp.gowtham.living"
  ttl             = 60
  type            = "A"
  comment         = "Domain verification record"
  content         = "2.2.2.2" #azurerm_public_ip.publicIP.ip_address
  private_routing = false
  proxied         = false
  settings = {
    ipv4_only = false
    ipv6_only = false
  }
  provisioner "local-exec" {
    command =  "ip=$(terraform output -raw test) >> $GITHUB_OUTPUT" #need to public IP here instead of test output
  }
}