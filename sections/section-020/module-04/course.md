---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Troubleshoot Global Services

A global service that works on the first day can fail later in quiet ways. All requests go to one cluster, some requests time out, or the surviving cluster is overloaded after a failure. This module teaches a fixed method to find the cause, how to read the real service state of an agent, how to test the balance with evidence and how to plan capacity for the loss of a cluster.

The module has four parts. The first is a checklist for a service that does not balance. The second reads the service table of an agent. The third tests load balancing with predictions and counts. The fourth covers capacity and failure domains. A graded lab asks you to fix timeouts caused by a network policy.

## Learning objectives

After this module you can:

- Check a global service in a fixed order, from the mesh status to the network policy.
- Read `cilium-dbg service list`, `--clustermesh-affinity` and `cilium-dbg bpf lb list` and say what each shows.
- Test load balancing with a prediction, enough requests and a count by cluster.
- Explain why a client with a persistent connection hides the split.
- Size two clusters so that one can carry the load of both, and name failures a global service does not cover.

## Before you start

You need global services: the same Service name and namespace in each cluster, with the annotation `service.cilium.io/global: "true"`. You also need the `affinity` annotation and `kubectl exec`.

The playground has two connected kind clusters, `west` and `east`. The Services `probe` and `scout` are already global in both clusters, with two pods in each cluster. Every pod answers with its workload and cluster name.

Launch the playground now:

<!-- astrona:playground -->
