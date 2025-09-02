# Deploy K3s Cluster on MAAS-Provisioned Hardware

## Context

The baremetal servers are provisioned with MAAS through Terraform. Installing K3s and forming a cluster could be baked
into the used [cloud-init file used by MAAS](../explanations/cloud-init.md). However, cloud-init runs only once after
deployment, which means any change in the K3s configuration requires a full node redeployment. This makes iteration and
upgrades inefficient.

## Options

The following options are considered for addressing the “cloud-init runs once” problem:

1. Terraform-only approach (hacks/workarounds)
    * Extend Terraform logic to fetch server tokens, render new configs, and push updates
    * Would keep everything in one tool (Terraform)
    * Requires custom scripting or abuse of provisioners (remote-exec, local-exec)
    * State management becomes fragile, because Terraform is declarative but cluster lifecycle tasks are inherently
      imperative (e.g. rotating tokens, upgrading nodes)
2. Terraform + Ansible approach
    * Terraform provisions hardware (via MAAS)
    * Ansible configures and manages K3s, using a mature implementation like the
      [`k3s-ansible` collection](https://github.com/k3s-io/k3s-ansible)
    * Decouples infra provisioning (machines, networks) from cluster management (K3s install, upgrades, reconfiguration)
    * More flexible: re-running playbooks applies changes without redeploying servers
    * Slightly more complex toolchain (Terraform + Ansible)

## Decision

> Adopt Terraform for hardware provisioning (MAAS) and Ansible for K3s deployment

### Justification

* **Maintainability**: The `k3s-ansible` role is actively maintained and widely used. Reinventing this logic in
  Terraform would introduce complexity and technical debt.
* **Separation of concerns**: Terraform manages infrastructure state; Ansible manages configuration state. Each tool
  plays to its strengths.
* **Future-proofing**: Ansible can later be extended to handle upgrades or integration with monitoring/logging without
  touching the provisioning layer.

## Consequences

The toolchain now requires switching between tooling for different tasks:

1. Set up MAAS after provisioning the bare machine for it &rarr; Ansible
2. Provision bare machines using MAAS &rarr; Terraform
3. Deploy and modify K3s cluster &rarr; Ansible

This requires integrating the different tools slightly, e.g. Terraform outputs feeding into Ansible inventory.

> [!CAUTION]
> Depending on the networking setup, the local dev machine might not be able to access the machines provisioned by MAAS
> directly and require a jump host.
