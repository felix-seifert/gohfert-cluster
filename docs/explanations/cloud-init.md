# cloud-init

When using MAAS to provision machines, the cloud-init script is executed once after finishing the OS installation; it
can be used to execute an initial configuration, like ensuring the presence of certain users, SSH keys or packages. If
the cloud-init script does not perform any relevant changes, the server becomes available with the SSH key from the MAAS
profile and the username `ubuntu`.

When introducing changes to the cloud-init script, Terraform will suggest to destroy the relevant `maas_instance`
and [deploy](./provisioning-flow.md) a new one. This means that propagating cloud-init changes requires reinstalling the
OS completely
