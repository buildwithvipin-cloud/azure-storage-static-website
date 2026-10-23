variable "subscription_id" {
  description = "Azure subscription ID used for deployment. Supply via TF_VAR_subscription_id or a local, untracked tfvars file."
  type        = string
  sensitive   = true
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
  default     = "rg-static-website-demo"
}

variable "location" {
  description = "Azure region for the resource group and Storage Account."
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Globally unique Azure Storage Account name (3-24 lowercase letters and numbers)."
  type        = string
  default     = "buildvipinsitedemo123"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "Storage Account names must contain 3-24 lowercase letters and numbers only."
  }
}

variable "tags" {
  description = "Tags applied to Azure resources."
  type        = map(string)
  default = {
    project     = "static-website-demo"
    environment = "learning"
    managed-by  = "terraform"
  }
}
