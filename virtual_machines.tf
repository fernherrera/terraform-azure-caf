#----------------------------------------------------------
# Locals declarations
#----------------------------------------------------------
locals {
  # Managed identities
  virtual_machine_managed_identities = {
    for managed_identity in
    flatten(
      [
        for sa_key, sa in local.compute.virtual_machines : {
          sa_key = sa_key
          type   = try(sa.identity.type, "SystemAssigned")
          managed_identities = concat(
            try(sa.identity.managed_identity_ids, []),
            flatten([
              for managed_identity_key in try(sa.identity.managed_identity_keys, []) : [
                module.managed_identities[managed_identity_key].id
              ]
            ])
          )
        } if try(sa.identity, null) != null
      ]
    ) : format("%s", managed_identity.sa_key) => managed_identity
  }
}

#----------------------------------------------------------
# Windows App Functions
#----------------------------------------------------------
module "virtual_machines" {
  source   = "./modules/compute/virtual_machine"
  for_each = local.compute.virtual_machines

  resource_group_name = can(each.value.resource_group_name) ? each.value.resource_group_name : try(module.resource_groups[each.value.resource_group_key].name, null)
  location            = try(each.value.location, var.global_settings.regions[var.global_settings.default_region])
  tags                = merge(try(each.value.tags, {}), var.tags, local.global_settings.tags)

  # Configuration
  virtual_machine_name             = each.value.virtual_machine_name
  license_type                     = try(each.value.license_type, "None")
  os_flavor                        = try(each.value.os_flavor, null)
  patch_mode                       = try(each.value.patch_mode, "AutomaticByOS")
  virtual_machine_size             = try(each.value.virtual_machine_size, null)
  source_image_id                  = try(each.value.source_image_id, null)
  vm_time_zone                     = try(each.value.vm_time_zone, null)
  instances_count                  = try(each.value.instances_count, null)
  custom_image                     = try(each.value.custom_image, null)
  enable_automatic_updates         = try(each.value.enable_automatic_updates, false)
  domain_name_label                = try(each.value.domain_name_label, null)
  linux_distribution_name          = try(each.value.linux_distribution_name, null)
  windows_distribution_name        = try(each.value.windows_distribution_name, null)
  enable_proximity_placement_group = try(each.value.enable_proximity_placement_group, false)

  # Security
  admin_username                   = try(each.value.admin_username, null)
  admin_password                   = try(each.value.admin_password, null)
  disable_password_authentication  = try(each.value.disable_password_authentication, null)
  enable_encryption_at_host        = try(each.value.enable_encryption_at_host, null)
  random_password_length           = try(each.value.random_password_length, null)
  generate_admin_ssh_key           = try(each.value.generate_admin_ssh_key, false)
  admin_ssh_key_data               = try(each.value.admin_ssh_key_data, null)
  identity                         = try(local.virtual_machine_managed_identities[each.key], null)
  key_vault_certificate_secret_url = try(each.value.key_vault_certificate_secret_url, null)

  # Networking
  virtual_network_resource_group_name = can(each.value.virtual_network_resource_group_name) ? each.value.virtual_network_resource_group_name : try(module.virtual_subnets[each.value.virtual_network_key].resource_group_name, null)
  virtual_network_name                = can(each.value.virtual_network_name) ? each.value.virtual_network_name : try(module.virtual_subnets[each.value.virtual_network_key].virtual_network_name, null)
  subnet_name                         = can(each.value.subnet_name) ? each.value.subnet_name : try(module.virtual_subnets[each.value.virtual_network_key].subnets[each.value.subnet_key].name, null)
  private_ip_address                  = try(each.value.private_ip_address, null)
  private_ip_address_allocation_type  = try(each.value.private_ip_address_allocation_type, "Dynamic")
  nsg_inbound_rules                   = try(each.value.nsg_inbound_rules, [])
  enable_accelerated_networking       = try(each.value.enable_accelerated_networking, false)
  enable_ip_forwarding                = try(each.value.enable_ip_forwarding, false)
  enable_public_ip_address            = try(each.value.enable_public_ip_address, null)
  existing_network_security_group_id  = try(each.value.existing_network_security_group_id, null)
  public_ip_allocation_method         = try(each.value.public_ip_allocation_method, null)
  public_ip_availability_zone         = try(each.value.public_ip_availability_zone, null)
  public_ip_sku                       = try(each.value.public_ip_sku, null)
  public_ip_sku_tier                  = try(each.value.public_ip_sku_tier, null)
  dns_servers                         = try(each.value.dns_servers, null)
  internal_dns_name_label             = try(each.value.internal_dns_name_label, null)
  dedicated_host_id                   = try(each.value.dedicated_host_id, null)

  # Storage
  os_disk_name                               = try(each.value.os_disk_name, null)
  os_disk_caching                            = try(each.value.os_disk_caching, "ReadWrite")
  os_disk_storage_account_type               = try(each.value.os_disk_storage_account_type, "StandardSSD_LRS")
  data_disks                                 = try(each.value.data_disks, [])
  disk_size_gb                               = try(each.value.disk_size_gb, null)
  disk_encryption_set_id                     = try(each.value.disk_encryption_set_id, null)
  storage_account_name                       = try(each.value.storage_account_name, null)
  storage_account_uri                        = try(each.value.storage_account_uri, null)
  enable_os_disk_write_accelerator           = try(each.value.enable_os_disk_write_accelerator, false)
  enable_ultra_ssd_data_disk_storage_support = try(each.value.enable_ultra_ssd_data_disk_storage_support, false)

  # Availability + Scaling
  enable_vm_availability_set   = try(each.value.enable_vm_availability_set, false)
  platform_fault_domain_count  = try(each.value.platform_fault_domain_count, null)
  platform_update_domain_count = try(each.value.platform_update_domain_count, null)
  vm_availability_zone         = try(each.value.vm_availability_zone, null)

  # Diagnostics + Logging
  enable_boot_diagnostics                    = try(each.value.enable_boot_diagnostics, false)
  deploy_log_analytics_agent                 = try(each.value.deploy_log_analytics_agent, false)
  log_analytics_customer_id                  = try(each.value.log_analytics_customer_id, null)
  log_analytics_workspace_id                 = can(each.value.log_analytics_workspace_id) ? try(each.value.log_analytics_workspace_id, null) : try(local.combined_objects.log_analytics[each.value.log_analytics_workspace_key].id, null)
  log_analytics_workspace_primary_shared_key = try(each.value.log_analytics_workspace_primary_shared_key, null)
  nsg_diag_logs                              = try(each.value.nsg_diag_logs, null)

  custom_data                         = try(each.value.custom_data, null)
  additional_unattend_content         = try(each.value.additional_unattend_content, null)
  additional_unattend_content_setting = try(each.value.additional_unattend_content_setting, null)
  winrm_protocol                      = try(each.value.winrm_protocol, null)
}
