variable "subscription_id" {
  description = "The Azure Subscription ID"
  type        = string
}

variable "domain_name" {
  description = "The Azure AD domain name"
  type        = string
}

variable "user_password" {
  description = "Password for the prod-ci-user"
  type        = string
  sensitive   = true
}

variable "role_name" {
  description = "Name for the Azure AD application (role)"
  default     = "prod-ci-role"
}

variable "policy_name" {
  description = "Name for the custom role definition (policy)"
  default     = "prod-ci-policy"
}

variable "group_name" {
  description = "Name for the Azure AD group"
  default     = "prod-ci-group"
}

variable "user_name" {
  description = "Name for the Azure AD user"
  default     = "prod-ci-user"
}

variable "client_id" {
  description = "The Azure Client ID"
  type        = string
  sensitive   = true
}

variable "client_secret" {
  description = "The Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "tenant_id" {
  description = "The Azure Tenant ID"
  type        = string
}
