resource "azurerm_spring_cloud_app" "micro_app" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  service_name        = var.asc_name
  is_public           = var.is_public
}

resource "azurerm_spring_cloud_java_deployment" "blue_deployment" {
  name                  = "blue"
  spring_cloud_app_id   = azurerm_spring_cloud_app.micro_app.id
  cpu                   = 1
  instance_count        = 1
  memory_in_gb          = 1
  jvm_options           = "-Xms1024m -Xmx1024m"
  runtime_version       = "Java_8"
  environment_variables = var.blue_environment_variables
}

resource "azurerm_spring_cloud_java_deployment" "green_deployment" {
  name                  = "micro"
  spring_cloud_app_id   = azurerm_spring_cloud_app.micro_app.id
  cpu                   = 1
  instance_count        = 1
  memory_in_gb          = 1
  jvm_options           = "-Xms1024m -Xmx1024m"
  runtime_version       = "Java_8"
  environment_variables = var.green_environment_variables
}


resource "azurerm_spring_cloud_active_deployment" "micro_active_deployment" {
  spring_cloud_app_id = azurerm_spring_cloud_app.micro_app.id
  deployment_name     = azurerm_spring_cloud_java_deployment.blue_deployment.name
}
