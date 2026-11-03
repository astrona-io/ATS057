---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh

A connected mesh lets pods reach each other. This section adds names: one Service name that has backends in several clusters. It covers global services with annotations, service affinity, the behavior of a mesh when a cluster is unreachable, and the standard Multi-Cluster Services API. Every step runs on two connected kind clusters, `west` and `east`.

The section has three modules. The first declares global services and controls which clusters share their backends. The second sets affinity and explains failure handling. The third exports services with `ServiceExport` and synchronizes EndpointSlices. Each module has a playground and a graded lab. A capstone lab repairs and tunes three Services, and a quiz closes the section.

## Learning Outcomes

- Declare a global service and predict which backends each cluster uses.
- Set service affinity to prefer local or remote backends.
- Explain what an agent does with the data of an unreachable cluster.
- Export a Service with the MCS-API and request its `clusterset.local` name.
