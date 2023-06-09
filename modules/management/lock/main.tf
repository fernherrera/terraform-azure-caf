#----------------------------------------------------------
# Resource Group level Lock
#----------------------------------------------------------
resource "azurerm_management_lock" "resource_group" {
  name       = var.name
  scope      = var.scope
  lock_level = var.lock_level
  notes      = try(var.notes, null)
}
