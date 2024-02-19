variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default = "myresg"
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"  # You can provide a default 
}
