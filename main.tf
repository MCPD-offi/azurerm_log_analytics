provider "azurerm" {
 # version = "=2.1.0"
  features {}
}

module "tag-ressource" {
  source  = "app.terraform.io/PersoPierre/tag-ressource/azurerm"
  version = "0.0.1"

  namespace = {
    ent_code  =lookup(var.tags, "ent","")
    dept_code =lookup(var.tags, "dept","")
    env_code  =lookup(var.tags, "env","")
    type_code =lookup(var.tags, "type","")
  }
  free_name = var.log_name
}

data "azurerm_resource_group" "RG1" {
  name     = var.rg_name
}

resource "azurerm_automation_account" "aa" {
  name                = "${module.tag-ressource.generated_values.name}aa"
  location            = data.azurerm_resource_group.RG1.location
  resource_group_name = data.azurerm_resource_group.RG1.name
  sku_name            = "Basic"

  tags = {
    environment = "development"
  }
}

resource "azurerm_log_analytics_workspace" "log-workspace" {
  name                = "${module.tag-ressource.generated_values.name}workspace"
  location            = data.azurerm_resource_group.RG1.location
  resource_group_name = data.azurerm_resource_group.RG1.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_linked_service" "log-linkedservice" {
  resource_group_name = data.azurerm_resource_group.RG1.name
  workspace_id        = azurerm_log_analytics_workspace.log-workspace.id
  read_access_id      = azurerm_automation_account.aa.id
}