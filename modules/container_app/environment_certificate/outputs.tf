output "id" {
  description = "The ID of the Container App Environment Certificate"
  value       = azurerm_container_app_environment_certificate.cacc.id
}

output "expiration_date" {
  description = "The expiration date for the Certificate."
  value       = azurerm_container_app_environment_certificate.cacc.expiration_date
}

output "issue_date" {
  description = "The date of issue for the Certificate."
  value       = azurerm_container_app_environment_certificate.cacc.issue_date
}

output "issuer" {
  description = "The Certificate Issuer."
  value       = azurerm_container_app_environment_certificate.cacc.issuer
}

output "subject_name" {
  description = "The Subject Name for the Certificate."
  value       = azurerm_container_app_environment_certificate.cacc.subject_name
}

output "thumbprint" {
  description = "The Thumbprint of the Certificate."
  value       = azurerm_container_app_environment_certificate.cacc.thumbprint
}