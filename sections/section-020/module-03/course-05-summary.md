---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Summary

The Multi-Cluster Services API describes cross-cluster services with Kubernetes resources instead of vendor annotations. Cilium supports it when the Helm value `clustermesh.mcsapi.enabled` is true. The value `clustermesh.mcsapi.corednsAutoConfigure.enabled` lets Cilium edit CoreDNS for the `clusterset.local` domain. CoreDNS 1.12.2 or later is required.

A `ServiceExport` with the same name and namespace as a Service exports that Service from its cluster. Cilium then creates a `ServiceImport` in every cluster and a derived Service named `derived-` plus a hash. Clients request the service by the name `<service>.<namespace>.svc.clusterset.local`. The name returns the backends of every cluster that exported the Service.

When two clusters export the same name with different definitions, Cilium resolves the conflict in favor of the oldest export. The labels and annotations that appear on the imported Service come from the `exportedLabels` and `exportedAnnotations` fields.

For clients that read EndpointSlices directly, the annotation `service.cilium.io/global-sync-endpoint-slices` synchronizes the EndpointSlices of a global service into the other clusters. It is a beta feature and is on by default for headless Services.

- Enable the MCS-API in every cluster.
- Export from every cluster that has backends.
- Request the clusterset name, not the cluster-local name.

<!-- astrona:playground:destroy -->
