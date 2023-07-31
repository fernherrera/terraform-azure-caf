variable "name" {
  description = "(Required) The name of the ExpressRoute circuit. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the ExpressRoute circuit. Changing this forces a new resource to be created."
}

variable "express_route_circuit_name" {
  description = "(Required) The name of the Express Route Circuit in which to create the Authorization. Changing this forces a new resource to be created."
}