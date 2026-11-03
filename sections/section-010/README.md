---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity

Separate Kubernetes clusters do not share pods, Services or network policy. This section shows what Cilium Cluster Mesh connects, how to connect two clusters and how to restrict the traffic that the connection allows. Every step runs on two kind clusters, `west` and `east`, that both run Cilium.

The section has four modules. The first explains the architecture of a mesh and its prerequisites. The second enables Cluster Mesh and connects the clusters. The third explains cluster identity in policy and writes cluster-aware network policies. The fourth operates a running mesh: it reads the status, explains the components, troubleshoots a broken connection and removes a connection. Each module has a playground and a graded lab. A capstone lab combines the first three modules, and a quiz closes the section.

## Learning Outcomes

- Explain the benefits of Cluster Mesh and the components that provide them.
- Check the prerequisites: unique name and ID, pod ranges, node connectivity, datapath mode and trust.
- Enable and connect Cluster Mesh and verify the control plane and the data path.
- Write a `CiliumNetworkPolicy` that allows one workload of one named cluster.
