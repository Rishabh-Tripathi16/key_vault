provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

/*
data "external" "thisAccount" {
  program = ["az","ad","signed-in-user","show","--query","{displayName: displayName,objectId: objectId,objectType: objectType}"]
}
*/

resource "azurerm_resource_group" "example_rg" {
  name     = "example-resources"
  location = "East US"
}

resource "azurerm_key_vault" "example" {
  name                        = "examplekeyvault-test1"
  location                    = azurerm_resource_group.example_rg.location
  resource_group_name         = azurerm_resource_group.example_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = "*****************************"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  
  sku_name = "standard"

  access_policy {
    tenant_id = "**************************************"
    #object_id = "${data.external.thisAccount.result.objectId}"
    object_id = "************************************"
    
    key_permissions = [
      "Get",
      "Create",
      "Delete",
      "List",
      "Update",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "Delete",
      "List",
    ]

  }
}


resource "azurerm_key_vault_secret" "example_secret" {
  count = length(var.secret_maps)
  name         = keys(var.secret_maps)[count.index]
  value        = values(var.secret_maps)[count.index]
  key_vault_id = azurerm_key_vault.example.id

}

resource "local_file" "secret" {
   content = <<-EOT
   ---- Key Value Pair ------
   %{for i in range(length(var.secret_maps)) ~}
   ${azurerm_key_vault_secret.example_secret[i].name} = ${azurerm_key_vault_secret.example_secret[i].value}
   %{endfor ~}
   EOT
  filename = "${path.module}/secrets_properties.txt"
}
                                                                                                                               69,1          Bot                                                                                                                               25,11         44%
  
