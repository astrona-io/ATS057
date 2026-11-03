---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Summary

In a mesh, a pod of one cluster can reach pods of every connected cluster by default. Cilium decides on the security identity of the source pod. The identity is derived from the labels of the pod, and the labels include the name of the cluster in the key `io.cilium.k8s.policy.cluster`.

A policy is enforced in the cluster that owns the protected pod. An ingress rule belongs in the cluster of the destination. An egress rule belongs in the cluster of the source. Cilium does not copy policies between clusters, so the same rule must be applied in every cluster that needs it.

In Cilium 1.19 and later, a selector in a policy matches endpoints of the local cluster only, unless the selector names a cluster. A rule that must allow a remote workload therefore names its cluster with the cluster label. In Cilium 1.18 and earlier, a selector without a cluster matched endpoints of all clusters.

A selector that lists the workload labels and the cluster label allows one workload of one cluster. A pod with the same workload labels in another cluster does not match. A selector that uses the `Exists` operator on the cluster label matches any cluster.

- Apply the policy in the cluster that enforces it.
- Name the cluster of the source.
- Test with a pod of the same labels in the wrong cluster.

<!-- astrona:playground:destroy -->
