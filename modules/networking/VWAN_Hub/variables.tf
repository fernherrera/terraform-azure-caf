variable "vwan_hub_variables" {
  description = "Map of vwan_hub objects. name, location, RG, etc."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    address_prefixes    = string
  }))
  default = {}
}
