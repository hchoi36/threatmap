resource gitlab_project_cluster "bar" {
  project                       = 30945345
  name                          = "CloudGuard-Kube"
  enabled                       = true
  kubernetes_api_url            = azurerm_kubernetes_cluster.aks.kube_config.0.host
  kubernetes_token              = data.kubernetes_secret.gitlab-admin-token.data.token
  kubernetes_ca_cert            = trimspace(base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate))
  kubernetes_authorization_type = "rbac"
  environment_scope             = "staging"
}
