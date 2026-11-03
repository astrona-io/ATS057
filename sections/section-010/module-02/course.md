---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Enable And Connect Cluster Mesh

Two clusters that meet the prerequisites still do not know each other. Connecting them takes two steps: enable Cluster Mesh in each cluster, then connect the clusters. Each step creates objects that you can read, and a connection that does not work leaves clear evidence in them. This module follows both steps and shows how to read the result.

The module has four parts. The first explains what `cilium clustermesh enable` creates and how the control plane of a cluster is exposed. The second explains what `cilium clustermesh connect` writes in each cluster and how to verify the data path. The third lists the Helm values and the certificates of a mesh. The fourth explains the connection modes and the secret that holds the connection details. A graded lab asks you to connect the two clusters of the playground.

## Learning objectives

After this module you can:

- Enable Cluster Mesh with the Cilium command-line tool and with Helm values.
- Choose the Service type of the `clustermesh-apiserver` for the environment.
- Connect two clusters and explain what the command stores in each cluster.
- Read `cilium clustermesh status` and name the component that each line describes.
- Prove the data path with a request from a pod in one cluster to a pod in the other.
- Name the Helm values and certificates that a mesh needs.
- Read the secret `cilium-clustermesh` and say what each key holds.

## Before you start

You need the prerequisites of a mesh: a unique name and ID for each cluster, pod ranges that do not overlap and a shared certificate authority. You also need `kubectl` with several contexts.

The playground has two kind clusters, `west` and `east`, running Cilium. Cluster Mesh is not enabled. The Starfleet example workloads run in both clusters. kind has no load balancer, so the playground uses node ports.

Launch the playground now:

<!-- astrona:playground -->
