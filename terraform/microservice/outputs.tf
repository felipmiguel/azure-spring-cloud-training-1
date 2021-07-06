output "app_id" {
    value = azurerm_spring_cloud_app.micro_app.id  
}
output "green_deployment_id" {
    value = azurerm_spring_cloud_java_deployment.green_deployment.id  
}

output "blue_deployment_id" {
    value = azurerm_spring_cloud_java_deployment.blue_deployment.id  
}