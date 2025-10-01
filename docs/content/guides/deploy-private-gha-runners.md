# Deploy Private GHA Runners

A [self-hosted GitHub Actions runner](../explanations/gha-runners.md) can be provisioned with the public playbook
`ansible/playbooks/gha_runners.yaml`. Remember that the relevant variables are declared in
`ansible/inventory/group_vars/gha_runners/`. Before creating a self-hosted runner, the playbook requires
a [GitHub PAT with
`repo` scope](https://github.com/MonolithProjects/ansible-github_actions_runner?tab=readme-ov-file#requirements) in the
appropriate Ansible vault.

To then trigger workflows in a private repo as a `repository_dispatch` event require a [GitHub PAT with
`contents: read & write` for the targeted repo](https://github.com/peter-evans/repository-dispatch?tab=readme-ov-file#token).
In the private repo, appropriate SSH keys might have to be available.
