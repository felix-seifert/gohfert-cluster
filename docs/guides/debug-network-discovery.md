# Debug Discovering Thin Clients With MAAS

Before following the [provisioning flow on MAAS](../explanations/provisioning-flow.md), a machine will have to be
discovered on the network, and this discovery involves some hidden complexity.

* Ensure that MAAS is the [only DHCP server](../references/router-settings-for-maas.md) on your subnet.
* Ensure via the BIOS settings of the thin clients that [PXE is enabled](../references/client-settings-for-maas.md#pxe)
  and/or sits first in the boot order.
* Check the MAAS GUI for the used IP leases of the VLAN (`Subnets` > Your subnet range > `Used IP addresses`).
    * If your IP lease succeeds, DHCP and PXE info was sent.
    * If the machine/MAC address does not show up there, the DHCP requests might not be passed successfully.
    * You can SSH to the MAAS server and investigate the live traffic between DHCP/TFTP server and thin client after you
      have rebooted the thin client:
      `sudo tcpdump -i <network-interface-for-PXE> port 67 or port 69 or port 4011`.
