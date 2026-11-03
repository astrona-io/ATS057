---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Cluster Mesh Architecture And Prerequisites

Two Kubernetes clusters do not share pods, Services or network policy. Cluster Mesh is the Cilium feature that lets the pods and Services of several clusters reach each other while each cluster keeps its own control plane. Before you connect two clusters, you must know what the mesh exchanges, which components do the work, and which conditions each cluster must meet. A repeated cluster name, an overlapping address range or a different certificate authority stops a connection before it starts.

The module has four parts. The first explains what Cluster Mesh connects, the components of a mesh, the trust domain and the prerequisites. The second reads each prerequisite from two live clusters. The third explains the network ports and the routing modes between clusters. The fourth explains the limits on cluster IDs and the size of a mesh. A graded lab asks you to repair a cluster whose identity collides with the identity of the other cluster.

## Learning objectives

After this module you can:

- Name the benefits of Cluster Mesh: pod-to-pod reach across clusters, global Services and cluster-aware policy.
- Describe the `clustermesh-apiserver` and say which traffic uses the control path and which uses the data path.
- List the prerequisites: unique cluster name and ID, non-overlapping pod ranges, node connectivity, one datapath mode and a shared certificate authority.
- Read the cluster name and ID of a running cluster and change them with `cilium upgrade`.
- Explain why all clusters of a mesh form one trust domain.
- Name the ports and protocols that clusters must reach, and compare tunnel routing with native routing.
- State the limit on cluster IDs and the effect of `maxConnectedClusters` on the size of a mesh.

## Before you start

You need Kubernetes basics: pods, Services, namespaces and `kubectl`. You also need to know that Cilium is the networking plugin that runs on every node.

The playground has two single-node kind clusters running Kubernetes 1.35, named `west` and `east`, both running Cilium. Cluster Mesh is not enabled yet. Each cluster runs the example workloads `probe`, `bridge` and `scout` and a client pod `shuttle` in the namespace `starfleet`.

Launch the playground now and keep it next to you while you read:

<!-- astrona:playground -->
