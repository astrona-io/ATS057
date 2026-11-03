---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Service Affinity And Failure Handling

A global service balances requests across all clusters. That is not always what a team wants. A request that stays in the local cluster is faster and cheaper, and a remote cluster may be the preferred home of a service. Cilium has an affinity setting for this choice. A mesh also has to behave sensibly when a remote cluster stops answering. This module explains both topics.

The module has two parts. The first explains the affinity values, how the local fallback works and which limits apply. The second explains what happens to remote data when a cluster becomes unreachable and how to observe it. A graded lab asks you to set affinity on two Services.

## Learning objectives

After this module you can:

- Set `service.cilium.io/affinity` to `none`, `local` or `remote` and predict the result.
- Explain the fallback: with `local`, remote backends are used only when no local backend is healthy.
- Read which backends are preferred with `cilium-dbg service list --clustermesh-affinity`.
- Describe what an agent does with the data of a remote cluster that stops answering, and the effect of `clustermesh.cacheTTL`.
- State the limit for global NodePort Services and host-network clients.

## Before you start

You need global services: the same Service name and namespace in each cluster with the annotation `service.cilium.io/global: "true"`.

The playground has two connected kind clusters, `west` and `east`. The Services `probe` and `scout` are already global in both clusters. Each has two pods per cluster, and every pod answers with its workload and cluster name.

Launch the playground now:

<!-- astrona:playground -->
