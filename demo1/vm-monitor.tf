resource "azurerm_monitor_data_collection_rule" "example" {
  name                = "example-dcr"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  destinations {
    azure_monitor_metrics {
      name = "example-destination-metrics"
    }
  }
  data_flow {
    streams      = ["Microsoft-InsightsMetrics"]
    destinations = ["example-destination-metrics"]
  }
  depends_on = [azurerm_resource_group.rg1, azurerm_lb.example, azurerm_windows_virtual_machine.example]
}

resource "azurerm_monitor_data_collection_endpoint" "example" {
  name                = "example-dce"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  depends_on          = [azurerm_resource_group.rg1, azurerm_lb.example, azurerm_windows_virtual_machine.example, azurerm_monitor_data_collection_rule.example]

}

# associate to a Data Collection Rule
resource "azurerm_monitor_data_collection_rule_association" "example1" {
  name                    = "example1-dcra"
  target_resource_id      = azurerm_windows_virtual_machine.example.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.example.id
  description             = "example"
  depends_on              = [azurerm_monitor_data_collection_rule.example]
}

# associate to a Data Collection Endpoint
resource "azurerm_monitor_data_collection_rule_association" "example2" {
  target_resource_id          = azurerm_windows_virtual_machine.example.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.example.id
  description                 = "example"
  depends_on                  = [azurerm_resource_group.rg1, azurerm_lb.example, azurerm_windows_virtual_machine.example, azurerm_monitor_data_collection_endpoint.example]
}
resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostic-setting"
  target_resource_id = azurerm_windows_virtual_machine.example.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}