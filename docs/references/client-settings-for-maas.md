# Required Settings for Computing Clients

## PXE

Before any server/client can become remotely accessible and go through
the [provisioning flow of MAAS](../explanations/provisioning-flow.md), MAAS needs to discover the client. To make
clients, especially thin clients, discoverable, they need to first try to boot via the network. This requires PXE to be
enabled an/or sitting first in the boot order.

For Dell Wyse 5070, the required default BIOS password is `Fireport`.

## Power Management

MAAS is designed for usage with industrial servers which have an OOB/BMC interface. As thin clients do not have the
power management functionality which comes with OOB interfaces, you will have to select `Manual` as the thin client's
power type.
