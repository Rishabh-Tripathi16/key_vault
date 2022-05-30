output "instances" {
  sensitive = true
  value = tomap(
    {
    for k, secret in azurerm_key_vault_secret.example_secret : k => {
      key = secret.name
      secret = secret.value
    }
    }
  )

}