# Architecture

The following architecture diagram gives an idea of how the bare metal machines form a K3s Kubernetes cluster.

```plantuml
!include explanations/architecture.puml
```

Even though it might look slightly confusing, we indeed have [several master nodes](./k3s-high-availability-cluster.md)
for achieving a high availability architecture.
