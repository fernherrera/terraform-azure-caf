global_settings = {
  environment    = "sbx"
  default_region = "region1"
  regions = {
    region1 = "eastus2"
  }
}

resource_groups = {
  rg1 = {
    name = "staticsite-rg"
  }
}

web = {
  static_sites = {
    s1 = {
      name               = "staticsite"
      resource_group_key = "rg1"
      sku_tier           = "Standard"
      sku_size           = "Standard"
    }
  }
}