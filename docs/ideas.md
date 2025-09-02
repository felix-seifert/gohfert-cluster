# Ideas

List of potential improvement ideas:

* [x] Spin up k3s cluster through Ansible or custom Terraform and write ADR
    * [ADR#01](./adrs/01-deploy-k3s-through-ansible.md)
    * [PR#1](https://github.com/felix-seifert/gohfert-cluster/pull/1)
* [x] Investigate option to manage power remotely through wake-on-lan
    * MAAS supported wake-on-LAN for remote power management in older versions like `2.x`. The current versions `3.x` do
      not seem to offer this support anymore.
    * Activating wake-on-LAN in the BIOS of a Dell Wyse 5070 does not help. Physically connecting the fresh machine to
      the network does not result in the machine receiving a DHCP IP address.
* [ ] Unify usage experience of Ansible and Terraform through `Makefile`
* ~~[ ] Arrange post-install config with connecting to Kubernetes cluster
  via [cloud-init](./explanations/cloud-init.md)~~
  * [ADR#01](./adrs/01-deploy-k3s-through-ansible.md) justifies a different approach.
* [ ] Add installation of node-exporter to cloud-init to enable monitoring of baremetal machines
* ~~[ ] Use custom ISOs with K3s already installed/binary present~~
    * Not worth the effort as K3s binary has only around 70 MB and this introduces new dependency between image
      generation and Ansible config.
* [ ] Run Terraform through action containers
* [ ] Declare UCG router config in Terraform
* [ ] Dynamically reuse VPN created in UCG config in MAAS
* [ ] Secure the inter-machine connections with (m)TLS
* [ ] Replace MAAS with custom tool using declarative NixOS
