output "resource_group_name" {
  description = "Created resource group."
  value       = azurerm_resource_group.this.name
}

output "storage_account_name" {
  description = "Created Storage Account name."
  value       = azurerm_storage_account.this.name
}

output "static_website_url" {
  description = "Public static website endpoint. Website files are publicly readable by design."
  value       = azurerm_storage_account.this.primary_web_endpoint
}
