# SSH Into K3s Nodes

According to our [architecture](./architecture.md), the K3s nodes are in a different VLAN than the local developer's
machine and only reachable via jumping through the MAAS machine. For Ansible, we already define an env var in the
`.env` file for this. To be able to manually SSH into the nodes though, you will have to add the jump host information
to your SSH config (usually in `~/.ssh/config`). We simplified this approach with a
[Makefile script](../guides/ssh-via-jumphost.md).
