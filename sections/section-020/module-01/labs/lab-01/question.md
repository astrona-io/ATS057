---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Inspect A Service Before Global Discovery

Record the local baseline that a mesh configuration would depend on.

## Starting state

Cilium manages the private two-node cluster. Hubble Relay and the BGP control plane are enabled. The probe and two clients are healthy; no learner policy or evidence report exists. This baseline uses kube-proxy and tunnelling.

Use a host shell with the private kubeconfig for this independent kind environment. A kubeconfig identifies the cluster and credentials used by kubectl, the Kubernetes command-line tool.

```sh
export KUBECONFIG="$(astrona kubeconfig ats-057-lab-020-01-01)"
test "$(kubectl config current-context)" = "kind-astro-ats-057-lab-020-01-01" || exit 1
node_name="astro-ats-057-lab-020-01-01-control-plane"
worker_name="astro-ats-057-lab-020-01-01-worker"
```

Keep this connection selected. Host-level commands name only this environment's node containers. They do not operate on the host operating system.

## Required result

Record the local Service name, namespace and endpoints. A global annotation alone does not create remote endpoints. This baseline has no mesh peer; the graded evidence is explicitly local.

Record observations in `starfleet/evidence`, whose `report.json` contains the stated report. The verifier reads the live API again; invented values do not pass.

The report object uses these fields: `cluster_name`, `cluster_id`, `service_namespace`, `service_name`, `pod_ip`. Keep numeric values numeric and preserve arrays and nested objects returned by the API.

## Verify The Result

The grader checks the required object fields and actual observations. Wait for controller convergence before submitting. Preserve the task's namespace, workload names and unrelated components.
