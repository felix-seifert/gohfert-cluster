# Gohfert Cluster

In this repo, I codified some of the knowledge needed to set up my own bare metal computing cluster. This knowledge should help future me and others being interested in this project. Furthermore, this code tries to make the taken steps reproducible.

The overall plan is to run Kubernetes on a bare metal cluster of thin clients. The thin clients are managed by [Metal as a Service (MaaS)](https://maas.io/) running on a separate machine.

MaaS simplifies provisioning these machines with minimal physical interaction. The Ansible playbook `maas_ops.yaml` is for setting up the MaaS controller machine. The `Makefile` simplifies the relevant Ansible command options.

## Learnings for Future Docs

* MaaS version should support OS version:
    * MaaS 3.6 requires Ubuntu 24.
    * MaaS 3.5 does not work on Ubuntu 24.
* Prefer apt over Snap on Raspberry Pi
    * Snap's containerisation is very confined and might not allow relevant access.
    * Consider `--classic` install to avoid sandboxing.
* Building from source is quite expensive and might not be the best choice for Raspberry Pi.
* To avoid set up problems, ensure that both region and rack controler are running.
* CLI commands in official documentation seem to be for older versions of MaaS.
