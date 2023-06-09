
variable "vwan_hub_fw_variables" {
  description = "Map of vwan_hub_fw objects. name, location, RG, etc."
  type = map(object({
    name                = string
    hub_name            = string
    fw_policy_name      = string
    location            = string
    resource_group_name = string
    sku_name            = string
    sku_tier            = string
    // threat_intel_mode           = string
    public_ip_count = string
    fw_tags         = map(string)
  }))
  default = {}
}