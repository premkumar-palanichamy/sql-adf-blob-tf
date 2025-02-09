variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space of the virtual network"
  type        = list(string)
}

variable "location" {
  description = "The Azure region where the resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "tags" {
  description = "A map of tags to be applied to the resources"
  type        = map(string)
  default     = {}
}

variable "public_address_prefix" {
  description = "List of public subnet address prefixes"
  type        = list(string)
}

variable "private_address_prefix" {
  description = "List of private subnet address prefixes"
  type        = list(string)
}

variable "public_ip_name" {
  description = "The name of the public IP"
  type        = string
}

variable "nic_name" {
  description = "The name of the network interface"
  type        = string
}

