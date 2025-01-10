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
  account_kind                      = var.account_kind
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  queue_encryption_key_type         = var.queue_encryption_key_type
  table_encryption_key_type         = var.table_encryption_key_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled

  dynamic "custom_domain" {
    for_each = var.custom_domain[*]
    content {
      name          = custom_domain.value.name
      use_subdomain = custom_domain.value.use_subdomain
    }
  }

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

resource "azurerm_storage_account_static_website" "this" {
  count              = var.static_website == null ? 0 : 1
  storage_account_id = azurerm_storage_account.this.id
  index_document     = var.static_website.index_document
  error_404_document = var.static_website.error_404_document
}

resource "azurerm_storage_container" "this" {
  for_each              = var.containers
  name                  = each.key
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = each.value.access_type
}

resource "azurerm_storage_share" "this" {
  for_each           = var.shares
  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
  quota              = each.value.quota
}
