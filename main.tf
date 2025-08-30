locals {
  data_dir     = "${path.module}/baremetal-data"
  machine_data = csvdecode(file("${local.data_dir}/machines.csv"))
}

module "servers" {
  source   = "./modules/server"
  for_each = { for m in local.machine_data : m["hostname"] => m }

  hostname             = each.key
  pxe_mac              = each.value["nic_mac_address"]
  distro_series        = each.value["ubuntu_distro"]
  admin_user_name      = each.value["admin_user_name"]
  admin_public_ssh_key = each.value["admin_public_ssh_key"]
}
