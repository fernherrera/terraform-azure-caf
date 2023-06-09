#----------------------------------------------------------
# Local configuration - Default (required). 
#----------------------------------------------------------
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  tags                = merge(try(var.tags, {}), )
}

#----------------------------------------------------------
# Resource Group Creation or selection - Default is "false"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}


#----------------------------------------------------------
# Private DNS Zone
#----------------------------------------------------------
resource "azurerm_private_dns_zone" "private_dns" {
  name                = var.name
  resource_group_name = local.resource_group_name
  tags                = local.tags
}

#----------------------------------------------------------
# DNS Records
#----------------------------------------------------------
#-- A
resource "azurerm_private_dns_a_record" "a_records" {
  for_each = try(var.records.a_records, {})

  name                = each.value.name
  resource_group_name = local.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

#-- AAAA
resource "azurerm_private_dns_aaaa_record" "aaaa_records" {
  for_each = try(var.records.aaaa_records, {})

  name                = each.value.name
  resource_group_name = local.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

#-- CNAME
resource "azurerm_private_dns_cname_record" "cname_records" {
  for_each = try(var.records.cname_records, {})

  name                = each.value.name
  resource_group_name = local.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  record              = each.value.records
}

#-- MX
resource "azurerm_private_dns_mx_record" "mx_records" {
  for_each = try(var.records.mx_records, {})

  name                = each.value.name
  resource_group_name = local.resource_group_name
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
  resource_group_name = local.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl
  records             = each.value.records
}

#-- SRV
resource "azurerm_private_dns_srv_record" "srv_records" {
  for_each = try(var.records.srv_records, {})

  name                = each.value.name
  resource_group_name = local.resource_group_name
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
  resource_group_name = local.resource_group_name
  zone_name           = azurerm_private_dns_zone.private_dns.name
  ttl                 = each.value.ttl

  dynamic "record" {
    for_each = each.value.records

    content {
      value = record.value.value
    }
  }
}