output "hostname" {
  value = var.hostname
}

output "ip_address" {
  value = maas_instance.this.ip_addresses
}