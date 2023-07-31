resource "azurerm_log_analytics_solution" "solution" {
  for_each = try(var.solutions_maps, {})

  solution_name         = each.key
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = local.id
  workspace_name        = local.name
  tags                  = var.tags

  plan {
    publisher      = lookup(each.value, "publisher")
    product        = lookup(each.value, "product")
    promotion_code = lookup(each.value, "promotion_code", null)
  }
}
