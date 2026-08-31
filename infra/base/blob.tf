
resource "azurerm_storage_account" "public-storage-account" {
  name                     = "${var.prefix}psa"
  resource_group_name      = data.azurerm_resource_group.azure-resource.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = true  
}

resource "azurerm_storage_container" "public-storage-container" {
  name                  = "${var.prefix}psc"
  storage_account_id  = azurerm_storage_account.public-storage-account.id
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "blob-static" {
  name                   = "static"
  storage_container_id = azurerm_storage_container.public-storage-container.id
  type                   = "Block"
}

output "url_blob" {
  value = "https://${azurerm_storage_account.public-storage-account.name}.blob.core.windows.net/${azurerm_storage_container.public-storage-container.name}/static/"
}


