/*locals we can accesible with in the block,variables we can accessible 
 any where in the configuration file globally to avoid multiple declarations and 
 customise the values*/


locals {
  owners          = var.Business
  environment     = var.environment
  resource_prefix = "uat"
  common_tags = {
    owners      = local.owners,
    environment = local.environment
  }
}
  