---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Summary

A global service that does not balance is found by ordered checks: the mesh status, the Service in every cluster, the global annotation, matching ports, the shared and affinity annotations, ready backends and network policy. Most causes are an annotation missing in one cluster, mismatched ports or an affinity value that works as configured.

The Cilium agent merges the local backends with the backends learned from remote clusters and writes the result into eBPF maps. The command `cilium-dbg service list` shows the merged backends for each frontend address. The option `--clustermesh-affinity` shows the preference, and `cilium-dbg bpf lb list` shows what the kernel program uses. Comparing the backend count with the pods you expect separates a data problem from a choice problem.

A load balancing test writes its prediction first, sends enough requests and counts the replies by cluster. Each new connection is balanced alone, so a client that reuses one connection sends all requests to one backend. The same test shows the even split, the local preference and the fallback when preferred backends disappear.

A cluster is a failure domain. A global service moves requests away from a failed cluster, but the surviving cluster must hold enough capacity for the full load. Shared dependencies and releases that reach both clusters at once are not covered by the mesh.

- Check in order and stop at the first failure.
- Read the agent table before changing settings.
- Plan capacity for the loss of one cluster.

<!-- astrona:playground:destroy -->
