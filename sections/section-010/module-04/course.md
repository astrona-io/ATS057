---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Operate And Troubleshoot Cluster Mesh

Building a mesh is a single event. Running it is a daily task. Certificates expire, clusters are rebuilt, firewalls change and a remote apiserver restarts. This module teaches how to read the state of a running mesh, what the components inside it do, how to find the cause of a broken connection and how to remove a connection cleanly.

The module has four parts. The first reads the status at three levels. The second explains the containers of the `clustermesh-apiserver` Pod and KVStoreMesh. The third gives an ordered method to troubleshoot a broken connection. The fourth explains the difference between disconnecting and disabling a mesh. A graded lab asks you to disconnect one cluster from the mesh.

## Learning objectives

After this module you can:

- Read `cilium clustermesh status` and `cilium-dbg status --verbose` and say what each line proves.
- Name the containers of the `clustermesh-apiserver` Pod and say what each one does.
- Explain how KVStoreMesh reduces the number of connections to a remote apiserver.
- Troubleshoot a broken connection in a fixed order, with `cilium-dbg troubleshoot clustermesh` and the agent log.
- Disconnect a cluster and disable the mesh in the right order, and predict what the workloads see.

## Before you start

You need to know what Cluster Mesh is and what the `clustermesh-apiserver` and the secret `cilium-clustermesh` are. You also need basic `kubectl` commands for logs, `exec` and `scale`.

The playground has two kind clusters, `west` and `east`, already connected with Cluster Mesh. The namespace `starfleet` runs `probe` and a `shuttle` client pod in both clusters.

Launch the playground now:

<!-- astrona:playground -->
