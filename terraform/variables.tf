variable "location" {
  type        = string
  description = "Azure region to host all services"
  default     = "westeurope"
}

# resource "random_string" "cosmos_account_suffix" {
#   length  = 12
#   lower   = true
#   special = false
# }

# variable "cosmos_account_base_name" {
#   type        = string
#   description = "CosmosDb account name"
#   default     = "asclab"
# }

variable "cosmos_failover_location" {
  type        = string
  default     = "northeurope"
  description = "Azure region for cosmosdb failover"

}

variable "asc_rg" {
  type        = string
  description = "resource group that contains Azure Spring Cloud deployment"
}

variable "asc_service_name" {
  type        = string
  description = "Azure Spring Cloud service name. It should be unique in the world, so it is a good idea to add your alias in the name"
}

variable "config_repo_uri" {
  type        = string
  description = "repository that hosts the configuration"

}

variable "config_repo_username" {
  type        = string
  description = "username of githu configuration repository"
}

variable "config_repo_pat" {
  type        = string
  description = "personal access token for github configuration repository"
}

##

variable "gateway" {
  type    = string
  default = "gateway"
}
variable "simple_microservice" {
  type    = string
  default = "simple-microservice"
}
variable "spring_cloud_microservice" {
  type    = string
  default = "spring-cloud-microservice"
}
variable "city_service" {
  type    = string
  default = "city-service"
}
variable "weather_service" {
  type    = string
  default = "weather-service"
}
variable "all_cities_weather_service" {
  type    = string
  default = "all-cities-weather-service"
}
variable "hystrix_service" {
  type    = string
  default = "hystrix-turbine"
}

variable "mysql_server_admin_name" {
  type    = string
  default = "sqladmin"
}

variable "mysql_database_name" {
  type    = string
  default = "azure-spring-cloud-training"
}
