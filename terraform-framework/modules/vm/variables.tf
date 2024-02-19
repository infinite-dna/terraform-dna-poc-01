variable "subnet_id" {
  description = "The ID of the subnet to deploy the VM"
}

variable "vm_os" {
  description = "The operating system for the VM (e.g., Windows, Linux)"
}

variable "vm_additional_config" {
  description = "Additional configuration for the VM"
}
