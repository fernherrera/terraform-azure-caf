#--------------------------------------------------------------------
# Place default settings for resource objects here
# merge these defaults with variables passed into the modules.
#--------------------------------------------------------------------

locals {

  # Default linux web app settings
  default_linux_web_apps_settings = {
    site_config = {
      application_stack = {
        php_version = "8.1"
      }
      ftps_state = "Disabled"
    }
  }

  # Default windows web app settings
  default_windows_web_apps_settings = {
    site_config = {
      application_stack = {
        current_stack  = "dotnetcore"
        dotnet_version = "v6.0"
      }
      ftps_state = "Disabled"
    }
  }

  # Default windows function app settings
  default_windows_function_apps_settings = {
    site_config = {
      always_on = false
      application_stack = {
        dotnet_version = "v6.0"
      }
      use_32_bit_worker = false
    }
  }

}