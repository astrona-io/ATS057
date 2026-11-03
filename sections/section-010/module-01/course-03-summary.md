---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Summary

Cluster Mesh joins the pod networks of several Kubernetes clusters. Each cluster keeps its own API server and scheduler. The mesh exchanges networking state only: endpoints, security identities and Service backends. It does not copy Deployments, Secrets or application data.

Each cluster in a mesh runs a `clustermesh-apiserver` that holds the state that other clusters may read. Clusters connect to each other's `clustermesh-apiserver` over mutual TLS. Pod traffic does not pass through it. Pod traffic goes directly between nodes, so a stopped `clustermesh-apiserver` does not stop traffic that already flows.

All connected clusters form one trust domain. Security identities are shared, so a policy can match pods of a remote cluster by their labels. A compromised cluster in the mesh can send traffic to the others, and only network policy limits what it can reach.

A cluster can join a mesh only when it has a unique name and a unique numeric ID, a pod address range that overlaps no other cluster, a route between nodes, the same datapath mode as the others and a certificate authority that the others trust. The name and ID are stored in the `cilium-config` ConfigMap and are read when the agents start. Changing them later changes the security identities of the pods, so workloads must be restarted.

- Cluster name: at most 32 characters, unique.
- Cluster ID: 1 to 255 by default, unique.
- Pod ranges: no overlap.
- Datapath mode: the same in every cluster.

<!-- astrona:playground:destroy -->
