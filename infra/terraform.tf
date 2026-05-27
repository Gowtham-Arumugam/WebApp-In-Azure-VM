terraform {
  required_version = "> 1.15.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.73.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "= 0.7.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.2.1"
    }
  }
}
provider "azurerm" {
  features {}
}
