provider "azurerm" {
  features {}
}


data "azurerm_kubernetes_service_versions" "current" {
  location       = "East US"
  version_prefix = "1.20.9"
}

resource "azurerm_resource_group" "Cloudguard-KubeResources"{ 
  name     = "Cloudguard-KubeResources"
  location = "East US"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "CloudGuard-Kube"
  location            = azurerm_resource_group.Cloudguard-KubeResources.location
  resource_group_name = azurerm_resource_group.Cloudguard-KubeResources.name
  dns_prefix = "gitlab"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

}

resource "azurerm_container_registry" "acr" {
  name                = "cloudguardregistry"
  resource_group_name = azurerm_resource_group.Cloudguard-KubeResources.name
  location            = azurerm_resource_group.Cloudguard-KubeResources.location
  sku = "Standard"
  admin_enabled       = true
}

variable "gitlab_access_token"{
    type = string
}
 
provider "gitlab" {
    token = var.gitlab_access_token
}
 
data "gitlab_project" "example_project" {
    id = 30945345
}
 
resource "gitlab_project_variable" "sample_project_variable" {
    project = data.gitlab_project.example_project.id
    key = "DOCKER_USER"
    value = azurerm_container_registry.acr.admin_username
}

resource "gitlab_project_variable" "sample_project_variable2" {
    project = data.gitlab_project.example_project.id
    key = "DOCKER_PASSWD"
    value = azurerm_container_registry.acr.admin_password
}

resource "gitlab_project_variable" "sample_project_variable3" {
    project = data.gitlab_project.example_project.id
    key = "registry"
    value = azurerm_container_registry.acr.login_server
}

