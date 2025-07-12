terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.36.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "45d2c8fb-faba-4dc1-ab43-5ad9451eef1c"
}

resource "azurerm_resource_group" "practice" {
  name     = "practice_resource_group"
  location = "West Europe"
}
resource "azurerm_resource_group" "practice-2" {
  name     = "practice_resource_group-2"
  location = "West Europe"
}



resource "azurerm_storage_account" "practice1" {
  depends_on               = [azurerm_resource_group.practice]
  name                     = "practicestorage1234df"
  location                 = "West Europe"
  resource_group_name      = "practice_resource_group"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}



resource "azurerm_storage_container" "remotestate" {
  name                  = "remotestatefiles"
  storage_account_name  = azurerm_storage_account.practice1.name
  container_access_type = "private"
}


terraform {
  backend "azurerm" {
    resource_group_name  = "practice_resource_group"
    storage_account_name = "practicestorage1234df"
    container_name       = "remotestatefiles"
    key                  = "terraform.tfstate"
  }
}
