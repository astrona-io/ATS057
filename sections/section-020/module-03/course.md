---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Multi-Cluster Services API And EndpointSlice Synchronization

Global services use Cilium annotations. The Kubernetes community defines a standard for the same need, the Multi-Cluster Services API (MCS-API). It uses the resources `ServiceExport` and `ServiceImport` and a DNS domain named `clusterset.local`. Cilium implements it on top of Cluster Mesh. This module explains how the API works in Cilium and how Cilium can synchronize EndpointSlices for clients that read them directly.

The module has two parts. The first explains the resources, the DNS names and the settings that turn the feature on. The second covers the conflict rules and the EndpointSlice synchronization. A graded lab asks you to export a Service from both clusters and request it by its `clusterset.local` name.

## Learning objectives

After this module you can:

- Enable the Cilium MCS-API support with `clustermesh.mcsapi.enabled` and let Cilium configure CoreDNS.
- Export a Service with a `ServiceExport` and describe the `ServiceImport` and the derived Service that follow.
- Request a service by the name `<service>.<namespace>.svc.clusterset.local`.
- Explain how Cilium resolves conflicts between exports of the same name.
- Explain the purpose of the annotation `service.cilium.io/global-sync-endpoint-slices`.

## Before you start

You need global services and the idea of a Service in one cluster with backends in several. You also need to know what CoreDNS does in a Kubernetes cluster.

The playground has two connected kind clusters, `west` and `east`, with the Service `bridge` in the namespace `starfleet` of both. The MCS-API is not enabled.

Launch the playground now:

<!-- astrona:playground -->
