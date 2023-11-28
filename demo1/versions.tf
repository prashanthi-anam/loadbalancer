/*terraform settings block
Here we will declare version of terraform cli version and provider version and also 
we can declare backend to store terraform state file*/
terraform {
  required_version = ">=1.0.0"
  #required_version = "~>=1.9.8"till date allows to change the right most number
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" #location of terraform provider
      version = ">=3.49.0"          #version of terraform provider
    }
  }
}
/* with out provider block we can't communicate with the provider we can declare additional 
features of perticular resource and it is applicable to every that perticular resource declare provider 
terraform will install the provider and use them*/
provider "azurerm" {
  features {


  }

}
# Provider-2 for WestUS Region
/*provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false # This will ensure when the Virtual Machine is destroyed, Disk is not deleted, default is true and we can alter it at provider level
    }
  }
  alias = "provider2-westus"
  #client_id = "XXXX"
  #client_secret = "YYY"
  #environment = "pppp"
  #subscription_id = "JJJJ"
}*/

