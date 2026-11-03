---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Summary

Cluster Mesh is enabled in each cluster and then connected. Enabling deploys the `clustermesh-apiserver` and creates the certificates for it. The Cilium command-line tool does this with `cilium clustermesh enable`, and the Helm value `clustermesh.useAPIServer` does the same.

The `clustermesh-apiserver` must be reachable from the other clusters. A Service of type `LoadBalancer` fits clusters that have a load balancer. A Service of type `NodePort` fits environments such as kind, where nodes are reachable but a load balancer does not exist.

Connecting is one command. `cilium clustermesh connect` writes the address and the client certificate of each cluster into a secret of the other cluster, so the connection works in both directions after one run. The secret `cilium-clustermesh` in `kube-system` holds one entry for each remote cluster.

`cilium clustermesh status --wait` reports the health of the control plane. A healthy control plane does not prove the data path. The data path is proven by a request from a pod in one cluster to the pod IP address of a pod in the other.

- Enable in every cluster.
- Connect each pair once.
- Check the control plane and the data path separately.

<!-- astrona:playground:destroy -->
