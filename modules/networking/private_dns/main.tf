#----------------------------------------------------------
# Private DNS Zone
#----------------------------------------------------------
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags                = var.tags

  dynamic "soa_record" {
    for_each = try(var.soa_record, null) != null ? [1] : []

    content {
      email        = var.soa_record.email
      expire_time  = try(var.soa_record.expire_time, null)
      minimum_ttl  = try(var.soa_record.minimum_ttl, null)
      refresh_time = try(var.soa_record.refresh_time, null)
      retry_time   = try(var.soa_record.retry_time, null)
      ttl          = try(var.soa_record.ttl, null)
      tags         = try(var.soa_record.tags, {})
    }
  }
}

#----------------------------------------------------------
# DNS Records
#----------------------------------------------------------
#-- A
resource "azurerm_private_dns_a_record" "a_records" {
  for_each = try(var.records.a_records, {})

  name                = each.value.name
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

#-- AAAA
resource "azurerm_private_dns_aaaa_record" "aaaa_records" {
  for_each = try(var.records.aaaa_records, {})

  name                = each.value.name
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

#-- CNAME
resource "azurerm_private_dns_cname_record" "cname_records" {
  for_each = try(var.records.cname_records, {})

  name                = each.value.name
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  record              = each.value.records
}

#-- MX
resource "azurerm_private_dns_mx_record" "mx_records" {
  for_each = try(var.records.mx_records, {})

  name                = each.value.name
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      preference = record.value.preference
      exchange   = record.value.exchange
    }
  }
}

#-- PTR
resource "azurerm_private_dns_ptr_record" "ptr_records" {
  for_each = try(var.records.ptr_records, {})

  name                = each.value.name
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

#-- SRV
resource "azurerm_private_dns_srv_record" "srv_records" {
  for_each = try(var.records.srv_records, {})

  name                = each.value.name
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }
}

#-- TXT
resource "azurerm_private_dns_txt_record" "txt_records" {
  for_each = try(var.records.txt_records, {})

  name                = each.value.name
  resource_group_name = var.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      value = record.value.value
    }
  }
}