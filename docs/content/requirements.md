# Requirements

To deploy and operate your own Kubernetes cluster from scratch with the described methods, you require setting up the
following specific tooling:

* Python (not too old, 3.12 and newer sounds suitable)
* Terraform
* kubectl
    1. For letting kubectl connect to your Kubernetes cluster from your local machine on your network, copy the
       `$Home/.kube/config` from one of your master nodes to your local machine at the same location.
        * The used Ansible collection `techno_tim.k3s_ansible` already copies the kubeconfig to its playbook dir and you
          can also take it from there.
    2. On the master nodes, kubectl already intends to connect to the virtual IP of the master nodes, i.e. any available
       master node, and the address will not have to be adjusted anymore.
