terraform {
  required_providers {
    maas = {
      source  = "canonical/maas"
      version = "~>2.6.0"
    }
  }
}

resource "maas_machine" "this" {
  architecture     = var.architecture
  hostname         = var.hostname
  power_parameters = var.power_params
  power_type       = var.power_type
  pxe_mac_address  = var.pxe_mac
}

resource "maas_network_interface_physical" "this" {
  mac_address = var.pxe_mac
  machine     = maas_machine.this.hostname
  name        = "eth0"
}

resource "maas_instance" "this" {
  depends_on = [maas_machine.this, maas_network_interface_physical.this]

  allocate_params {
    hostname = maas_machine.this.hostname
  }

  deploy_params {
    distro_series  = var.distro_series
    enable_hw_sync = true
    user_data = templatefile("${path.module}/cloud-init.tpl", {
      admin_user_name      = var.admin_user_name
      admin_public_ssh_key = var.admin_public_ssh_key
      service_accounts     = var.service_accounts
    })
  }

  network_interfaces {
    name        = maas_network_interface_physical.this.name
    subnet_cidr = "192.168.150.0/24"
  }

  lifecycle {
    ignore_changes = [
      deploy_params[0].user_data
    ]
  }
}
