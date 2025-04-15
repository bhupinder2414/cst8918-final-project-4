terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "kubernetes" {
  host                   = var.kube_host
  client_certificate     = base64decode(var.kube_client_cert)
  client_key             = base64decode(var.kube_client_key)
  cluster_ca_certificate = base64decode(var.kube_cluster_ca)
}

data "azurerm_resource_group" "app_rg" {
  name     = "bhup0006-cst8918-app-rg"
  location = "East US"
}

resource "azurerm_container_registry" "weather_acr" {
  name                = "bhup0006acr"
  resource_group_name = azurerm_resource_group.app_rg.name
  location            = azurerm_resource_group.app_rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "kubernetes_deployment" "weather_app" {
  metadata {
    name = "weather-app"
    labels = {
      app = "weather-app"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "weather-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "weather-app"
        }
      }

      spec {
        container {
          image = "${azurerm_container_registry.weather_acr.login_server}/weather-app:latest"
          name  = "weather-app"

          env {
            name  = "REDIS_HOST"
            value = var.redis_host
          }

          env {
            name  = "REDIS_PORT"
            value = var.redis_port
          }

          env {
            name  = "REDIS_PASSWORD"
            value = var.redis_password
          }

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "weather_app" {
  metadata {
    name = "weather-app"
  }

  spec {
    selector = {
      app = kubernetes_deployment.weather_app.metadata[0].labels.app
    }

    port {
      port        = 80
      target_port = 3000
    }

    type = "LoadBalancer"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.app_rg.name
}

output "acr_name" {
  value = azurerm_container_registry.weather_acr.name
}

output "service_ip" {
  value = kubernetes_service.weather_app.status[0].load_balancer[0].ingress[0].ip
}