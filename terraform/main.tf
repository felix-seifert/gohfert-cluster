locals {
  data_dir         = "${path.root}/../data"
  machine_data     = csvdecode(file("${local.data_dir}/machines.csv"))
  service_accounts = yamldecode(file("${local.data_dir}/service_accounts.yaml"))
  service_accounts_normalised = [
    for acct in local.service_accounts : merge(acct, {
      allow_connections_from = acct.allow_connections_from == null ? [] : (
        can(tolist(acct.allow_connections_from)) ? tolist(acct.allow_connections_from) : [acct.allow_connections_from]
      )
    })
  ]
}

module "servers" {
  source   = "./modules/server"
  for_each = { for m in local.machine_data : m["hostname"] => m }

  hostname             = each.key
  pxe_mac              = each.value["nic_mac_address"]
  distro_series        = each.value["ubuntu_distro"]
  admin_user_name      = each.value["admin_user_name"]
  admin_public_ssh_key = each.value["admin_public_ssh_key"]
  service_accounts     = local.service_accounts_normalised
}
