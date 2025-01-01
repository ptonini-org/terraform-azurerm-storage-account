resource "random_id" "this" {
  count = var.randomize_name ? 1 : 0
  keepers = {
    name = var.name
  }
  byte_length = 8
}

resource "azurerm_storage_account" "this" {
  name                              = var.randomize_name ? substr("${var.name}${random_id.this[0].dec}", 0, 24) : var.name
  resource_group_name               = var.rg.name
  location                          = var.rg.location
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  queue_encryption_key_type         = var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  lifecycle {
    ignore_changes = [
      tags["business_unit"],
      tags["environment"],
      tags["product"],
      tags["subscription_type"],
      tags["environment_finops"]
    ]
  }
}

resource "azurerm_storage_container" "this" {
  for_each              = var.containers
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = each.value.access_type
}

resource "azurerm_storage_share" "this" {
  for_each             = var.shares
  name                 = each.key
  storage_account_name = azurerm_storage_account.this.name
  quota                = each.value.quota
}
