---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Summary

A global service is a Service whose backends come from several clusters. It needs a Service with the same name in the same namespace in every cluster, and the annotation `service.cilium.io/global: "true"` on each of them. Cilium merges the pods that those Services select into one list of backends and balances requests across the list.

The annotation is read in each cluster separately. A cluster that does not carry it keeps using its local backends only, even when the other clusters share theirs. A cluster that lacks the Service does not take part at all.

By default, a global service is shared: a cluster offers its local backends to the other clusters and uses theirs. The annotation `service.cilium.io/shared: "false"` stops the offering. The cluster still uses the remote backends. The result is not symmetric: the cluster that sets `shared` to `false` sees all backends, and the other clusters see their own backends only.

Cilium keeps the merged backend list in each agent. A request to the Service name is answered by one backend of the list. Over many requests, the replies come from every cluster that offers backends.

- Same name and namespace in each cluster.
- The global annotation in each cluster.
- `shared: "false"` stops sharing, not using.

<!-- astrona:playground:destroy -->
