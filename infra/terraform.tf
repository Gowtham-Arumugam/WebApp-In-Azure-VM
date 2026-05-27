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
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}
provider "azurerm" {
  features {}
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
