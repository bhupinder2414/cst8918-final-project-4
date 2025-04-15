terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "redis_rg" {
  name     = "bhup0006-cst8918-redis-rg"
  location = "East US"
}

resource "azurerm_redis_cache" "weather_redis" {
  name                = "bhup0006-redis"
  location            = azurerm_resource_group.redis_rg.location
  resource_group_name = azurerm_resource_group.redis_rg.name
  capacity            = 1
  family              = "C"
  sku_name            = "Basic"
  non_ssl_port_enabled = false
  minimum_tls_version = "1.2"

  redis_configuration {
    maxmemory_reserved = 2
    maxmemory_delta    = 2
    maxmemory_policy   = "allkeys-lru"
  }
}

output "resource_group_name" {
  value = azurerm_resource_group.redis_rg.name
}

output "redis_hostname" {
  value = azurerm_redis_cache.weather_redis.hostname
}

output "redis_port" {
  value = azurerm_redis_cache.weather_redis.ssl_port
}

output "redis_password" {
  value     = azurerm_redis_cache.weather_redis.primary_access_key
  sensitive = true
}