terraform {
  required_version = ">= 1.8"

  backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4"
    }
  }
}

module "azure_naming" {
  source = "../.."

  customer_tla = "abc"
  environment  = "t01"
  application  = "dtwh"
  location     = "weu"
  workload     = "shrd"
}

output "naming_convention" {
  value = module.azure_naming
}
