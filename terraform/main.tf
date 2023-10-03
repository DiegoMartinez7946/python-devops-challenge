resource "azuread_application" "main" {
  name = var.role_name
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "azurerm_role_definition" "main" {
  name        = var.policy_name
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Custom role to allow assuming the ${var.role_name}"

  permissions {
    actions     = ["Microsoft.Authorization/*/read"]
    not_actions = []
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}"
  ]
}

resource "azuread_group" "main" {
  name = var.group_name
}

resource "azuread_user" "main" {
  user_principal_name = "${var.user_name}@${var.domain_name}"
  display_name        = var.user_name
  password            = var.user_password
}

resource "azuread_group_member" "main" {
  group_object_id  = azuread_group.main.object_id
  member_object_id = azuread_user.main.object_id
}
