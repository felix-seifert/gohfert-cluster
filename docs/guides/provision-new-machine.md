# Provision New Machine

For provisioning new machines which can be used for the K3s cluster, all machine-specific data is put into
`data/machines.csv`.

* `hostnames` follow a [specific schema](../references/machine-names.md) encoding some helpful information.
* The `nic_mac_address` is the MAC address of the relevant NIC and can be found via the BIOS of a machine.
* The admin is relevant for being able to connect to the machine.
* Several master nodes are needed for implementing an
  [HA K3s cluster](../explanations/k3s-high-availability-cluster.md).

When the necessary data of the new machine is keyed in, simply run a `make plan` followed by a `make apply`.

> As the used machines have no remote power management, remember to boot the machines again when required.
