# modules/rg_module/variables.tf

variable "resource_group_name" {
  type    = string
  default = "default_rg"
}

variable "location" {
  type    = string
  default = "East US"
}
