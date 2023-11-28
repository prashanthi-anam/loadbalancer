resource "azurerm_resource_group" "rg1" {
  location = "West us"
  #name     = "${var.Business}-${var.environment}"
  name = "rg1"
  #name = "${var.Business}-${var.environment}-${random_string.random.id}"
  #tags = local.common_tags

}
/*resource "azurerm_resource_group" "rg2" {
  location = "west us"
  name     = "rg2"
  provider = azurerm.provider2-westus

}*/
