# main.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }
  }
  backend "azurerm" {
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {}

# Variables
variable "environment" {
  type        = string
  description = "Environment (dev, staging, prod)"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
}

# Local variables for environment-specific settings
locals {
  env_config = {
    dev = {
      sku_storage     = "Standard_LRS"
      sku_app_service = "Y1"
      tier           = "Dynamic"
    }
    staging = {
      sku_storage     = "Standard_LRS"
      sku_app_service = "Y1"
      tier           = "Dynamic"
    }
    prod = {
      sku_storage     = "Standard_GRS"
      sku_app_service = "Y1"  # Changed to match your current setup
      tier           = "Dynamic"  # Changed to match your current setup
    }
  }
  resource_suffix = "${var.project_name}-${var.environment}"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.resource_suffix}"
  location = var.location
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "st${replace(local.resource_suffix, "-", "")}"
  resource_group_name      = azurerm_resource_group.main.name
  location                = azurerm_resource_group.main.location
  account_tier            = "Standard"
  account_replication_type = local.env_config[var.environment].sku_storage

  tags = {
    environment = var.environment
  }
}

# Function App
resource "azurerm_service_plan" "main" {
  name                = "plan-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  os_type            = "Linux"
  sku_name           = local.env_config[var.environment].sku_app_service
}

resource "azurerm_linux_function_app" "main" {
  name                       = "func-${local.resource_suffix}"
  resource_group_name        = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  service_plan_id           = azurerm_service_plan.main.id
  storage_account_name      = azurerm_storage_account.main.name
  storage_account_access_key = azurerm_storage_account.main.primary_access_key

  site_config {
    application_stack {
      python_version = "3.11"  # Matching your GitHub Actions Python version
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
    SCM_DO_BUILD_DURING_DEPLOYMENT = "true"
    ENABLE_ORYX_BUILD = "true"
  }

  tags = {
    environment = var.environment
  }
}

# Get Function App publish profile
resource "azurerm_resource_group_template_deployment" "publish_profile" {
  name                = "get-publish-profile"
  resource_group_name = azurerm_resource_group.main.name
  deployment_mode     = "Incremental"
  
  template_content = <<TEMPLATE
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {},
    "variables": {},
    "resources": [],
    "outputs": {
        "publishProfile": {
            "type": "string",
            "value": "[list(resourceId('Microsoft.Web/sites/config', '${azurerm_linux_function_app.main.name}', 'publishingcredentials'), '2021-02-01').properties.publishingPassword]"
        }
    }
}
TEMPLATE
  
  depends_on = [azurerm_linux_function_app.main]
}

# Outputs for GitHub Actions
output "function_app_name" {
  value = azurerm_linux_function_app.main.name
  description = "The name of the Function App"
}

output "publish_profile" {
  value = azurerm_resource_group_template_deployment.publish_profile.output_content
  sensitive = true
  description = "Function App publish profile"
}