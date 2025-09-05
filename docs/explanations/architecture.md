# Architecture

The following architecture diagram gives an idea of how the bare metal machines form a K3s Kubernetes cluster.

![Architecture Diagram](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.githubusercontent.com/felix-seifert/gohfert-cluster/refs/heads/main/docs/explanations/architecture.pumls)

Even though it might look slightly confusing, we indeed have [several master nodes](./k3s-high-availability-cluster.md)
for achieving a high availability architecture.
