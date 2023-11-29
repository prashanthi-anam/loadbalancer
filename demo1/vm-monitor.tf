
resource "azurerm_monitor_data_collection_rule" "example" {


  name                = "vminsights"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location

  data_flow {
    destinations = ["log-analytics"]
    streams = [
      "Microsoft-Event",
      "Microsoft-InsightsMetrics",
      "Microsoft-Perf",
      "Microsoft-ServiceMap"
    ]
  }

  data_flow {
    destinations = ["monitor-metrics"]
    streams      = ["Microsoft-InsightsMetrics"]
  }

  data_sources {
    extension {
      extension_name = "DependencyAgent"
      name           = "DependencyAgentDataSource"
      streams        = ["Microsoft-ServiceMap"]
    }

    performance_counter {
      counter_specifiers            = ["\\VmInsights\\DetailedMetrics"]
      name                          = "insights-metrics"
      sampling_frequency_in_seconds = 60
      streams = [
        "Microsoft-InsightsMetrics",
        "Microsoft-Perf"
      ]
    }

    windows_event_log {
      name    = "windows-events"
      streams = ["Microsoft-Event"]
      x_path_queries = [
        "Application!*[System[(Level=1 or Level=2 or Level=3)]]",
        "System!*[System[(Level=1 or Level=2 or Level=3)]]"
      ]
    }
  }

  destinations {
    azure_monitor_metrics {
      name = "monitor-metrics"
    }

    log_analytics {
      name                  = "log-analytics"
      workspace_resource_id = azurerm_log_analytics_workspace.example.id
    }
  }
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
  name                        = "configurationAccessEndpoint"
  target_resource_id          = azurerm_windows_virtual_machine.example.id
  data_collection_endpoint_id = azurerm_monitor_data_collection_endpoint.example.id
  description                 = "example"
  depends_on                  = [azurerm_resource_group.rg1, azurerm_lb.example, azurerm_windows_virtual_machine.example, azurerm_monitor_data_collection_endpoint.example, azurerm_monitor_data_collection_rule.example]
}
/*resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example-diagnostic-setting"
  target_resource_id = azurerm_windows_virtual_machine.example.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}*/


