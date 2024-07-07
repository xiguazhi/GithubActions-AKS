resource "random_pet" "azurerm_kubernetes_cluster_name" {
  prefix = "cluster"
}

resource "random_pet" "azurerm_kubernetes_cluster_dns_prefix" {
  prefix = "dns"
}

resource "random_pet" "acr" {
  prefix = "acr"
}
resource "azurerm_kubernetes_cluster" "aks" {
  name = random_pet.azurerm_kubernetes_cluster_name.id
  location = data.azurerm_resource_group.rgrp.location
  resource_group_name = var.resource_group_name
   dns_prefix          = random_pet.azurerm_kubernetes_cluster_dns_prefix.id

  default_node_pool {
    name = "agentpool"
    node_count = 1
    vm_size = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.subnet.id
  }
  identity {
    type = "SystemAssigned"
  }
  linux_profile {
    admin_username = var.username
    ssh_key {
      key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  tags = {
    Environment = "Production"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks" {
  name = lower("GHAAKSpool")
  vm_size = "Standard_DS2_v2"
  priority = "Spot"
  
  node_count = 1
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
}


resource "azurerm_container_registry" "acr" {
  name = lower(random_pet.acr.id)
  resource_group_name = var.resource_group_name
  location = data.azurerm_resource_group.rgrp.location
  sku = "Standard"
}

resource "azurerm_role_assignment" "aks" {
  principal_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope = azurerm_container_registry.acr.id
  skip_service_principal_aad_check = true
}