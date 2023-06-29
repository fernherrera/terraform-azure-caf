module "mysql_databases" {
  source     = "./modules/databases/mysql_flexible_database"
  depends_on = [module.mysql_servers]
  for_each   = local.database.mysql_flexible_databases

  name                = each.value.name
  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].resource_group_name, null)
  server_name         = can(each.value.server_name) ? each.value.server_name : try(module.mysql_servers[each.value.server_key].name)
  charset             = each.value.charset
  collation           = each.value.collation
}

output "mysql_databases" {
  value = module.mysql_databases
}