variable "name" {}

variable "rg" {
  type = object({
    name     = string
    location = string
  })
}

variable "randomize_name" {
  default  = true
  nullable = false
}

variable "account_tier" {
  default  = "Standard"
  nullable = false
}

variable "account_replication_type" {
  default  = "LRS"
  nullable = false
}

variable "queue_encryption_key_type" {
  default  = "Service"
  nullable = false
}

variable "table_encryption_key_type" {
  default  = "Service"
  nullable = false
}

variable "infrastructure_encryption_enabled" {
  default  = true
  nullable = false
}

variable "containers" {
  type = map(object({
    access_type = string
  }))
  default  = {}
  nullable = false
}

variable "shares" {
  type = map(object({
    quota            = number
    access_tier      = optional(string, "Hot")
    enabled_protocol = optional(string, "SMB")
  }))
  default  = {}
  nullable = false
}