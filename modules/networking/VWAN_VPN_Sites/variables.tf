variable "vwan_vpn_site_variables" {
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    address_cidrs       = list(string)
    link_name           = string
    link_ip_address     = string
    provider_name       = string
    speed_in_mbps       = string
    device_vendor       = string
  }))
  default = {}
}
