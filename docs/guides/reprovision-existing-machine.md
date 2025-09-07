# Reprovision Existing Machines

As seen in the description of the [lifecycle of machines in MAAS](../explanations/provisioning-flow.md), the
provisioning step consists out of the two distinctive steps of first _commissioning_ a machine and then _deploying_ it.
The machine will afterwards be available again. However, the machine will not be part of the K3s cluster then.

## Recommission

If we experience some physical issues with the machine, want to replace some hardware or the whole machine, we might be
interested in recommissioning it. After performing our physical changes, we have to edit the machine data in
`data/machines.csv` and mark the `maas_machines` as tainted before running a new `apply`.

0. Perform needed (physical) changes
1. Update machine data in `data/machines.csv`
2. `make mark-for-recommissionning HOSTNAME=<host-to-recommission>`
3. `make plan`
4. `make apply`

## Redeploy

For redeploying, we just reinstall all the software on a machine. For this, we tell Terraform to first destroy and then
recreate the respective `maas_instance`. We simply mark the `maas_instance` as tainted before running a new `apply`.

1. `make mark-for-redeployment HOSTNAME=<host-to-redeploy>`
2. `make plan`
3. `make apply`

> When recommissioning or redeploying machines, remember to reboot the machines so that they PXE boot into MAAS'
> ephemeral OS and MAAS can perform changes on them.
