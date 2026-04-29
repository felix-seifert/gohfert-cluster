# Certificates for TLS

Services accessible via HTTP with the ingress controller Traefik can
[receive a DNS name](./dns-for-deployed-k8s-services.md) and are accessible within the cluster's local network. To
receive a certificate for TLS from a public certification authority, the DNS name would also have to exist on the
public internet. Even though these names could be published without making the content accessible outside of the local
network, we avoid interacting too much with external services and keep DNS and issueing CA certificates local. We hence
issue them via a _cert manager_ within the local K3s cluster and allow local clients to
[installl these certs manually](../references/ca-certs.md).
