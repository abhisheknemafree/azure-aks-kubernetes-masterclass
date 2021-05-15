terraform {
  required_version = ">= 0.12.26"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "k8s" {
  name     = "aksdemo-rg"
  location = "eastus"
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "aksdemo-01"
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = "aksdemo-01"

  default_node_pool {
    name       = "agentpool"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  #  service_principal {
  #    client_id     = var.client_id
  #    client_secret = var.client_secret
  #  }
}

resource "local_file" "kubeconfig" {
  content  = azurerm_kubernetes_cluster.k8s.kube_config_raw
  filename = "kubeconfig"

  depends_on = [
    azurerm_kubernetes_cluster.k8s
  ]
}