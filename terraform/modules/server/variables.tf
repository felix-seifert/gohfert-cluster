variable "hostname" { type = string }
variable "pxe_mac" { type = string }
variable "distro_series" { type = string }
variable "admin_user_name" { type = string }
variable "admin_public_ssh_key" { type = string }
variable "architecture" {
  type    = string
  default = "amd64/generic"
}
variable "power_type" {
  type    = string
  default = "manual"
}
variable "power_params" {
  type    = string
  default = "{}"
}
