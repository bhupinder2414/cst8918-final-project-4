resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.resource_prefix}-aks-admin"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_prefix}-admin"
  kubernetes_version  = var.kubernetes_version
 
  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = var.aks_vm_size
    vnet_subnet_id  = var.admin_subnet_id
  }
 
  identity {
    type = "SystemAssigned"
  }
 
  network_profile {
    network_plugin = "azure"
    dns_service_ip = var.aks_dns_service_ip
    service_cidr   = var.aks_service_cidr
  }
 
   tags = {
    Environment = var.environment
  }
}
