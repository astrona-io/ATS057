---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Global Services And Cross-Cluster Discovery

A Kubernetes Service selects pods in its own cluster only. In a mesh, one Service name can have backends in several clusters. Cilium calls such a Service a global service. This module explains how a global service is declared, how Cilium merges the backends of the clusters, and how one cluster can use remote backends without offering its own.

The module has two parts. The first explains the annotations and the merge mechanism. The second runs the annotations on two clusters and compares what each cluster sees. A graded lab asks you to make two Services global with different sharing rules.

## Learning objectives

After this module you can:

- Declare a global service with the annotation `service.cilium.io/global`.
- State the conditions for a global service: the same name and namespace in every cluster.
- Use `service.cilium.io/shared: "false"` to use remote backends without sharing local ones.
- Predict which clusters the clients of each cluster reach for a given set of annotations.
- Read the backends that an agent holds for a global service.

## Before you start

You need Kubernetes Services, selectors and `kubectl` with two contexts. You also need to know that a connected mesh exchanges pods and Services between clusters.

The playground has two connected kind clusters, `west` and `east`. The Services `probe`, `bridge` and `scout` exist in the namespace `starfleet` of both clusters, with two pods each. Every pod answers with its workload name and its cluster, for example `probe from east`.

Launch the playground now:

<!-- astrona:playground -->
