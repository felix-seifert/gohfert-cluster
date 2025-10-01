# K3s High Availability Cluster

A K3s cluster consists out of several compute nodes, and these nodes can have different roles. Classically, a cluster
has one master node and several worker nodes. And as this master node's availability is crucial for the availability of
the whole cluster, this node is a bottleneck.

To circumvent this, it is possible to create a cluster with several master nodes. Usually, this would require a shared
database for all the master nodes. A solution with slightly less performance is having a local etcd data store for each
master node to implement a highly available K3s cluster. Just keep in mind to have an
[odd number of master nodes](https://docs.k3s.io/datastore/ha-embedded) because the several etcd instances must reach
quorum.

With our Ansible playbook for setting up a K3s cluster, we use the data from `data/machines.csv` to spin up the cluster.
The role defining variable is `is_k3s_master`: when the value is `true`, the node will be a K3s master. Remember to have
an odd number of `true` values for this variable.
