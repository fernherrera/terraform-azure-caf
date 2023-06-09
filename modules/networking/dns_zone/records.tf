
module "records" {
  source     = "./records"
  count      = try(var.records, null) == null ? 0 : 1
  depends_on = [azurerm_dns_zone.dns_zone]

  zone_name           = var.name
  resource_group_name = var.resource_group_name
  records             = var.records
  resource_ids        = var.resource_ids
  tags                = var.tags
}