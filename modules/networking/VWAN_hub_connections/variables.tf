variable "vwan_hub_connections" {
  description = "Map of vwan_hub_connections objects. name, virtual_hub_name and VNet_name"
  type = map(object({
    name             = string
    virtual_hub_name = string
    #VNet_name          = string
    vnet_id             = string
    resource_group_name = string
  }))
  default = {}
}
