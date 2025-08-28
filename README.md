# Gohfert Cluster

In this repo, I codified some of the knowledge needed to set up my own bare metal computing cluster. This knowledge
should help future me and others being interested in this project. Furthermore, this code tries to make the taken steps
reproducible.

The overall plan is to run Kubernetes on a bare metal cluster of thin clients. The thin clients are managed
by [Metal as a Service (MaaS)](https://maas.io/) running on a separate machine.

MaaS simplifies provisioning these machines with minimal physical interaction. The Ansible playbook `maas_ops.yaml` is
for setting up the MaaS controller machine. The `Makefile` simplifies the relevant Ansible command options.
