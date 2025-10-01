# Gohfert Cluster

In this repo, I codified some of the knowledge needed to set up my own bare metal computing cluster. This knowledge
should help future me and others being interested in this project. Furthermore, this code tries to make the taken steps
reproducible.

The overall plan is to run Kubernetes on a bare metal cluster of thin clients. The thin clients are managed by
[Metal as a Service (MAAS)](https://maas.io/) running on a separate machine, and the Kubernetes cluster running on top
of the is a high availability K3s cluster.

## MAAS Setup

MAAS simplifies provisioning these machines with minimal physical interaction. The Ansible playbook `maas_ops.yaml` is
for setting up the MAAS controller machine. The `Makefile` simplifies the relevant Ansible command options.

## MAAS Actions via Terraform

MAAS is used to provision the thin clients in a usable state. To avoid unreproducable point-and-click configuration in
the MAAS web UI, Terraform is used to trigger the MAAS APIs. Furthermore, it shows an understandable model of the
infrastructure with the machine data in `data/machines.csv`.

## K3s Cluster Deployment

[I decided](./docs/adrs/01-deploy-k3s-through-ansible.md) to deploy the K3s Kubernetes cluster with Ansible on top of
the machines provisioned by MAAS. The cluster is implemented as a
[high availability](./docs/explanations/k3s-high-availability-cluster.md) cluster based on data in `data/machines.csv`.

## Architecture

To visualise the idea of how the different components are architected for deploying a K3s Kubernetes cluster, have a
look at the [architecture explanation](./docs/content/explanations/architecture.md).

![Architecture Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/felix-seifert/gohfert-cluster/refs/heads/main/docs/content/explanations/architecture.puml)
