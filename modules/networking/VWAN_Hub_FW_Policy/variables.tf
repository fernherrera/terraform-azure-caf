variable "vwan_hub_fw_policy_variables" {
  description = "Map of vwan_hub_fw_policy objects. name, location, RG, etc."
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
  default = {}
}
