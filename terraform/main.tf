provider "azurerm" {
  features {}
}


## Azure Spring Cloud resources 
resource "azurerm_resource_group" "rg_asc" {
  name     = var.asc_rg
  location = var.location
}

locals {
  mysql_server_name  = "pcsms-db-${var.asc_rg}"
  cosmosdb_name      = "pcsms-cosmosdb-${var.asc_rg}"
  app_insights_name  = "pcsms-appinsights-${var.asc_rg}"
  log_analytics_name = "pcsms-log-${var.asc_rg}"
}

resource "azurerm_spring_cloud_service" "asc_service" {
  name                = var.asc_service_name
  resource_group_name = azurerm_resource_group.rg_asc.name
  location            = azurerm_resource_group.rg_asc.location

  config_server_git_setting {
    uri          = var.config_repo_uri
    label        = "main"
    search_paths = ["."]
    http_basic_auth {
      username = var.config_repo_username
      password = var.config_repo_pat
    }
  }

  trace {
    instrumentation_key = azurerm_application_insights.appinsights.instrumentation_key
  }
}

module "gateway" {
  source              = "./microservice"
  app_name            = var.gateway
  resource_group_name = azurerm_resource_group.rg_asc.name
  asc_name            = azurerm_spring_cloud_service.asc_service.name
  is_public           = true
}
module "simple_microservice" {
  source              = "./microservice"
  app_name            = var.simple_microservice
  resource_group_name = azurerm_resource_group.rg_asc.name
  asc_name            = azurerm_spring_cloud_service.asc_service.name
}
module "spring_cloud_microservice" {
  source              = "./microservice"
  app_name            = var.spring_cloud_microservice
  resource_group_name = azurerm_resource_group.rg_asc.name
  asc_name            = azurerm_spring_cloud_service.asc_service.name
  blue_environment_variables = {
    "spring.profiles.active" : "profile1"
  }
}
module "city_service" {
  source              = "./microservice"
  app_name            = var.city_service
  resource_group_name = azurerm_resource_group.rg_asc.name
  asc_name            = azurerm_spring_cloud_service.asc_service.name
}
module "weather_service" {
  source              = "./microservice"
  app_name            = var.weather_service
  resource_group_name = azurerm_resource_group.rg_asc.name
  asc_name            = azurerm_spring_cloud_service.asc_service.name
}
module "all_cities_weather_service" {
  source              = "./microservice"
  app_name            = var.all_cities_weather_service
  resource_group_name = azurerm_resource_group.rg_asc.name
  asc_name            = azurerm_spring_cloud_service.asc_service.name
}

module "hystrix_service" {
  source              = "./microservice"
  app_name            = var.hystrix_service
  resource_group_name = azurerm_resource_group.rg_asc.name
  asc_name            = azurerm_spring_cloud_service.asc_service.name
  is_public           = true
}



resource "azurerm_spring_cloud_app_mysql_association" "weather_mysql_bind" {
  name                = "weather-mysql-bind"
  spring_cloud_app_id = module.weather_service.app_id
  mysql_server_id     = azurerm_mysql_server.asc_mysql_server.id
  database_name       = azurerm_mysql_database.asc_petclinic_db.name
  username            = "${azurerm_mysql_server.asc_mysql_server.administrator_login}@${azurerm_mysql_server.asc_mysql_server.name}"
  password            = azurerm_mysql_server.asc_mysql_server.administrator_login_password
}

resource "random_password" "mysql_pwd" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_mysql_server" "asc_mysql_server" {
  name                = local.mysql_server_name
  location            = azurerm_resource_group.rg_asc.location
  resource_group_name = azurerm_resource_group.rg_asc.name

  sku_name = "B_Gen5_1"

  storage_mb                   = 5120
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login          = var.mysql_server_admin_name
  administrator_login_password = random_password.mysql_pwd.result
  version                      = "5.7"
  ssl_enforcement_enabled      = true
}

resource "azurerm_mysql_database" "asc_petclinic_db" {
  name                = var.mysql_database_name
  resource_group_name = azurerm_resource_group.rg_asc.name
  server_name         = azurerm_mysql_server.asc_mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_firewall_rule" "allazureips" {
  name                = "allAzureIPs"
  resource_group_name = azurerm_resource_group.rg_asc.name
  server_name         = azurerm_mysql_server.asc_mysql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_configuration" "mysql_timeout" {
  name                = "interactive_timeout"
  resource_group_name = azurerm_resource_group.rg_asc.name
  server_name         = azurerm_mysql_server.asc_mysql_server.name
  value               = "2147483"
}

resource "azurerm_mysql_configuration" "mysql_time_zone" {
  name                = "time_zone"
  resource_group_name = azurerm_resource_group.rg_asc.name
  server_name         = azurerm_mysql_server.asc_mysql_server.name
  value               = "+2:00" // Add appropriate offset based on your region.
}

# CosmosDB
resource "azurerm_cosmosdb_account" "cosmos_account" {
  name                = local.cosmosdb_name
  location            = azurerm_resource_group.rg_asc.location
  resource_group_name = azurerm_resource_group.rg_asc.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "EnableServerless"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

  geo_location {
    location          = azurerm_resource_group.rg_asc.location
    failover_priority = 0
  }

  geo_location {
    location          = azurerm_resource_group.rg_asc.location
    failover_priority = 0
  }

}

resource "azurerm_cosmosdb_sql_database" "cosmos_db" {
  name                = "azure-spring-cloud-cosmosdb"
  resource_group_name = azurerm_cosmosdb_account.cosmos_account.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmos_account.name
}
resource "azurerm_cosmosdb_sql_container" "cosmos_city_container" {
  name                  = "City"
  resource_group_name   = azurerm_cosmosdb_account.cosmos_account.resource_group_name
  account_name          = azurerm_cosmosdb_account.cosmos_account.name
  database_name         = azurerm_cosmosdb_sql_database.cosmos_db.name
  partition_key_path    = "/definition/name"
  partition_key_version = 1
}

resource "azurerm_spring_cloud_app_cosmosdb_association" "city_service_cosmosdb_binding" {
  name                       = "city-cosmosdb-bind"
  spring_cloud_app_id        = module.city_service.app_id
  cosmosdb_account_id        = azurerm_cosmosdb_account.cosmos_account.id
  cosmosdb_sql_database_name = azurerm_cosmosdb_sql_database.cosmos_db.name
  api_type                   = "sql"
  cosmosdb_access_key        = azurerm_cosmosdb_account.cosmos_account.primary_key
}

resource "azurerm_application_insights" "appinsights" {
  name                = local.app_insights_name
  location            = azurerm_resource_group.rg_asc.location
  resource_group_name = azurerm_resource_group.rg_asc.name

  application_type = "java"
}
