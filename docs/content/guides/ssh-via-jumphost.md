# SSH Via Jumphost

Reaching the K3s nodes is often only [possible via a jump host](../explanations/ssh-into-k3s-nodes.md). These
information can be easily persisted in the SSH config (usually in `~/.ssh/config`). To use the correct machine data
repeatedly, use the Makefile.

1. Generate a config file from our machine data with `make generate-ssh-config`.
2. Like the generated config file in your local SSH config with `make install-ssh-config`.

You can then directly SSH to the K3s nodes via the jumphost using their hostname, e.g. `ssh dematu01`. Whenever the
used machine data changes, you can just update your SSH config with `make generate-ssh-config`.
