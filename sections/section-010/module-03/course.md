---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Cross-Cluster Connectivity And Network Policy

A connected mesh lets any pod reach any other pod, in every cluster, until a policy says otherwise. That is a benefit and a risk. This module explains how Cilium identifies a pod from a remote cluster, how a policy names the cluster of a source pod and where a policy must be applied, because Cilium does not copy policies between clusters.

The module has two parts. The first follows one request across the mesh and shows how identity and the cluster label decide the policy result. The second writes policies that allow only a named workload of a named cluster. A graded lab asks you to restrict access to the `probe` pods of one cluster.

## Learning objectives

After this module you can:

- Explain how a pod of a remote cluster is identified in a policy decision.
- Use the label `io.cilium.k8s.policy.cluster` to allow or deny a source by cluster.
- Say in which cluster a policy must be applied for ingress and for egress.
- Write a `CiliumNetworkPolicy` that allows only a named workload of a named cluster.
- Predict which pods of each cluster a policy allows, including pods with the same labels in the wrong cluster.

## Before you start

You need `CiliumNetworkPolicy` basics: an `endpointSelector` chooses the protected pods, and a rule such as `ingress` lists the allowed sources. You also need to know what a label selector is.

The playground has two kind clusters, `west` and `east`, already connected with Cluster Mesh. The `shuttle` pod runs in `starfleet` of both clusters. The `drifter` pod runs in the namespace `outpost` of `west`. No policy exists yet.

Launch the playground now:

<!-- astrona:playground -->
