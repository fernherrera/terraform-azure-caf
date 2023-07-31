resource "azurerm_key_vault_secret" "secret" {
  depends_on = [module.initial_policy]

  for_each = {
    for key, value in try(var.settings.secrets, {}) : key => value
    if try(value.ignore_changes, false) == false
  }

  key_vault_id    = local.id
  name            = each.value.name
  value           = try(each.value.is_value_filepath, false) ? base64encode(file(each.value.value)) : each.value.value
  content_type    = try(each.value.content_type, null)
  not_before_date = try(each.value.not_before_date, null)
  expiration_date = try(each.value.expiration_date, null)
  tags            = try(each.value.tags, null)
}

# workaround until support for https://github.com/hashicorp/terraform/issues/25534
resource "azurerm_key_vault_secret" "secret_ignore_changes" {
  depends_on = [module.initial_policy]

  for_each = {
    for key, value in try(var.settings.secrets, {}) : key => value
    if try(value.ignore_changes, false) == true
  }

  key_vault_id    = local.id
  name            = each.value.name
  value           = try(each.value.is_value_filepath, false) ? base64encode(file(each.value.value)) : each.value.value
  content_type    = try(each.value.content_type, null)
  not_before_date = try(each.value.not_before_date, null)
  expiration_date = try(each.value.expiration_date, null)
  tags            = try(each.value.tags, null)

  lifecycle {
    ignore_changes = [value]
  }
}