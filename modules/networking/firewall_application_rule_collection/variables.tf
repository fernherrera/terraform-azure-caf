variable "name" {
  description = "(Required) Specifies the name of the Application Rule Collection which must be unique within the Firewall. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group in which the Firewall exists. Changing this forces a new resource to be created."
}

variable "azure_firewall_name" {
  description = "(Required) Specifies the name of the Firewall in which the Application Rule Collection should be created. Changing this forces a new resource to be created."
}

variable "priority" {
  description = "(Required) Specifies the priority of the rule collection. Possible values are between 100 - 65000."
}

variable "action" {
  description = "(Required) Specifies the action the rule will apply to matching traffic. Possible values are Allow and Deny."
}

variable "rules" {
  description = "(Required) One or more rule blocks"
}