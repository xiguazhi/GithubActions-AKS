terraform {
  required_version = ">=1.9"

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~>1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.100"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "azurerm" {
  features {}
}

module "common" {
  source = "../common"
  resource_group_name = "BSORE-GHAKS-RGRP"
  resource_prefix = "BSORE-GHAKS"
  subnet_name = "runners"
}