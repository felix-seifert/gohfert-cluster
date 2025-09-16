# Required Router Settings to Enable MAAS to Discover and Manage Servers

A few network settings have to be adjusted so that MAAS works:

* On its VLAN, the MAAS server should be the only DHCP server. The router DHCP server functionality would therefore have
  to switched off.
* So that the MAAS server is still available without an overarching DHCP server, it needs to have a static IP address.
  As the router does not provide the DHCP server function anymore, locking the IP address on the router's side does not
  help; the IP address will have to be set on the server itself. This ios achieved with the Ansible role
  [custom_netplan_ip_setter](../../ansible/roles/custom_netplan_ip_setter).

For setting the IP address on the server, you first have to be able to connect to the server, i.e. it needs an IP
address. The following workflow might therefore be a good idea:

1. While the router's DHCP is still enabled, assign a DNS name to the MAAS server to make it easy to address it.
2. Set the static IP address on the MAAS server (e.g. via the `maas_ops.yaml` playbook).
3. Disable the DHCP server functionality of the router.
