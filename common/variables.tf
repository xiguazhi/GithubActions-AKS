variable "resource_prefix" {}
variable "resource_group_name" {}
variable "subnet_name" {}
variable "username" {
  type        = string
  description = "The admin username for the new cluster."
  default     = "azureadmin"
}