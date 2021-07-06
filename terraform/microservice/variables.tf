variable "app_name" {
  type        = string
  description = "application name"
}

variable "resource_group_name" {
  type        = string
  description = "Azure Spring Cloud resource group"
}

variable "asc_name" {
  type        = string
  description = "Azure Spring Cloud service name"
}

variable "is_public" {
  type        = bool
  description = "Is public application"
  default     = false
}

variable "blue_environment_variables" {
  type        = map(string)
  description = "Environment variables for blue deployment"
  default     = null
}

variable "green_environment_variables" {
  type        = map(string)
  description = "Environment variables for green deployment"
  default     = null
}
