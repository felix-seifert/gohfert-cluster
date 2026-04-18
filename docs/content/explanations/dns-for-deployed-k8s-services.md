# DNS for Deployed K8s Services

The Kubernetes ingress controller Traefik allows us to assign DNS names to services which we deploy within our
Kubernetes cluster. We can simply create a Kubernetes resource of the type `Ingress`. In there, we specify which DNS
name should forward to which service.

MetalLB ensures that the Traefik pods get an extarnally accessible IP address. In our case, there are two required
actions:

1. Point a DNS wilcard which covers all desired DNS names to the IP address of the Traefik pods; in our case this is
   `*gohfert.com`.
2. Allow HTTP(S) traffic from the consumer devices to the IP address of the Traefik pods.
