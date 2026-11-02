---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Summary

Cross-cluster service discovery makes selected remote backends available under a supported service-sharing model. Cilium global Services and supported multi-cluster API resources provide different configuration contracts.

Identity, readiness and sharing or affinity choices determine the available population. A discovered remote backend still needs reachable routes, permitted traffic and suitable application behavior; service connectivity does not provide database consistency or automatic business failover.

<!-- astrona:playground:destroy -->
