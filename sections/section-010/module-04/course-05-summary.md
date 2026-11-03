---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Summary

The state of a mesh is visible at the Kubernetes level, at the level of the Cilium command-line tool and at the level of one agent. The command `cilium clustermesh status` reports the apiserver and the number of nodes, endpoints, identities and services read from each remote cluster. A healthy status proves the control path only. A request between pods proves the data path.

The `clustermesh-apiserver` Pod writes the state of the local cluster into a local etcd database. KVStoreMesh copies the state of each remote cluster into that database, and the agents read the copy. This makes the number of connections to a remote apiserver depend on the number of clusters and not on the number of nodes. Each container has its own log, and the fault decides which log to read.

A broken connection is found by checking in a fixed order: the remote apiserver, its address, the secret, the certificates, the cluster identity, the synchronized state and the data path. The command `cilium-dbg troubleshoot clustermesh` and the agent log name the failing step. A short outage of a remote apiserver does not remove known endpoints from the agents.

Disconnecting removes the entry of each cluster from the secret of the other and leaves the apiserver and certificates in place. Disabling removes the apiserver and must come after all disconnects. After a disconnect, global services lose their remote backends and policy rules for the other cluster stop matching.

- Read both sides of the mesh.
- Check in order and stop at the first failure.
- Disconnect before you disable.

<!-- astrona:playground:destroy -->
