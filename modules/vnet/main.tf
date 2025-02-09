#---------------------------------------------------------
# Vnet block
#----------------------------------------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

#---------------------------------------------------------
# Public and Private Subnets
#---------------------------------------------------------
resource "azurerm_subnet" "pub_subnet" {
  count                           = length(var.public_address_prefix)
  name                            = "pub-subnet-${count.index + 1}"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.vnet.name
  address_prefixes                = [var.public_address_prefix[count.index]]
  default_outbound_access_enabled = true
}

resource "azurerm_subnet" "pvt_subnets" {
  count                           = length(var.private_address_prefix)
  name                            = "pvt-subnet-${count.index + 1}"
  resource_group_name             = var.resource_group_name
  virtual_network_name            = azurerm_virtual_network.vnet.name
  address_prefixes                = [var.private_address_prefix[count.index]]
  default_outbound_access_enabled = false
}

#---------------------------------------------------------
# Public Ip
#---------------------------------------------------------
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"
}

#---------------------------------------------------------
# NIC
#---------------------------------------------------------
resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}