variable "resource_group_name" {
  description = "The name of the resource group for the Terraform backend"
  type        = string
  default     = "bhup0006-cst8918-backend-rg"
}

variable "location" {
  description = "The Azure region for the resources"
  type        = string
  default     = "East US"
}

variable "storage_account_name" {
  description = "The name of the storage account for the Terraform backend"
  type        = string
  default     = "bhup0006storage"
}