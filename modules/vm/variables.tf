variable "location" {
  description = "The Azure region where the resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "The username for the virtual machine"
  type        = string
}

variable "admin_password" {
  description = "The password for the virtual machine"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "nic_id" {
  description = "The id of the network interface"
  type        = string
  
}

variable "public_ip" {
  description = "Whether to create a public IP"
  type        = bool
}

variable "adf_auth_key" {
  description = "The authentication key for the ADF integration runtime"
  type        = string
}

variable "tags" {
  description = "A map of tags to be applied to the resources"
  type        = map(string)
  default     = {}
}
