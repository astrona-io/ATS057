---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Summary

Affinity decides which backends of a global service a cluster prefers. The annotation `service.cilium.io/affinity` is read in the cluster that sets it and has three values. `none` is the default and balances across all clusters. `local` prefers healthy backends of the same cluster and uses remote backends only when no local backend is healthy. `remote` prefers backends of other clusters and uses local backends only when no remote backend is healthy.

Affinity changes the choice of the clients of the cluster that carries the annotation. Other clusters keep their own choice. The agent can print the preferred backends, marked as preferred, with `cilium-dbg service list --clustermesh-affinity`.

A failure of a remote cluster does not remove its backends at once. When the connection to a remote cluster fails, the agent keeps the data that it already read. By default the value `clustermesh.cacheTTL` is `0s`, and cached data of an unreachable cluster is never revoked. A positive value removes the cached data after that time.

Global NodePort Services and clients in the host network are balanced across clusters only when `kubeProxyReplacement` is enabled, or with the socket load balancer in the host namespace. Pod clients use the usual path.

- `local` falls back to remote when no local backend is healthy.
- Affinity is a per-cluster choice.
- The cache keeps data of an unreachable cluster until `cacheTTL` ends.

<!-- astrona:playground:destroy -->
