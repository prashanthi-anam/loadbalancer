resource "azurerm_public_ip" "example" {
  name                = "PublicIPForLB1"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  #sku                 = "Standard"
  sku               = "Basic" # Use "Basic" SKU to match the Load Balancer SKU
  allocation_method = "Static"
}

resource "azurerm_lb" "example" {
  name                = "TestLoadBalancer"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}
resource "azurerm_lb_backend_address_pool" "pool" {
  name            = "pool1"
  loadbalancer_id = azurerm_lb.example.id
  /*virtual_network_id = azurerm_virtual_network.example.id
  connection {
    host = azurerm_windows_virtual_machine.example.id
  }*/

  depends_on = [azurerm_lb.example]

}

resource "azurerm_lb_probe" "example" {
  loadbalancer_id = azurerm_lb.example.id
  name            = "win-running-probe"
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}
resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.example.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}
resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id    = azurerm_network_interface.example.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id
}
/*resource "azurerm_lb_outbound_rule" "example" {
  name                    = "OutboundRule"
  loadbalancer_id         = azurerm_lb.example.id
  protocol                = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.pool.id

  frontend_ip_configuration {
    name = "PublicIPAddress"
  }
}*/
