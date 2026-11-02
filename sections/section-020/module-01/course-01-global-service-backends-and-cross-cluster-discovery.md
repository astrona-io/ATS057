---
draft: true
exam_objectives:
- Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh
---
# Global Service Backends And Cross-Cluster Discovery

Multi-cluster connectivity becomes useful when applications can discover and select appropriate remote service backends. Cilium supports service-sharing mechanisms such as global Services, and current implementations can also support a multi-cluster services API under documented configuration. These mechanisms describe backend relationships rather than automatic application replication.

## Local Services Remain Owned Locally

A normal Kubernetes Service selects backends within its local resource context. A Cilium global Service can use supported annotations and mesh state to extend backend selection across matching service relationships in connected clusters. Namespace and name conventions matter because they help define which services are intended to share a population.

A service with the same name in another cluster may serve a different tenant or environment. Review the actual sharing contract instead of assume equal spelling means equal trust. Each cluster still owns its local workloads, Service configuration and readiness observations.

## Sharing And Affinity Affect The Population

Supported configuration can determine whether local backends are shared and whether local or remote choices are preferred. Service affinity can express locality preferences under the implementation's model. Preference should not be confused with a universal strict guarantee that no remote backend will ever be selected.

The available population depends on discovered state and endpoint readiness. A remote workload that exists but is not a usable endpoint should not be assumed to serve traffic. Stale state or an unavailable mesh peer can affect the observed backend list independently of local Service correctness.

## Multi-Cluster API Has Another Contract

The Kubernetes SIG Multicluster model uses resources such as ServiceExport and ServiceImport to express service sharing. Supported Cilium integration can add discovery under that model, including its DNS conventions and prerequisites. It differs from directly marking a Cilium global Service through annotations.

Choose the supported mechanism that fits the deployment and verify its version-specific requirements. A resource stored without the necessary controller or DNS integration cannot supply its intended behavior. Do not combine two sharing models casually without understanding whether they select or expose the same backends twice.

## Discovery Does Not Forward Packets

A client can discover a remote backend but still fail because workload routes, infrastructure filtering or policy deny the connection. The return path must also work. Cross-cluster identity and namespace context can affect policy selection, while source translation or proxies can alter the visible peer relationship.

Trace discovery, backend population, routing, permission and application response separately. A local connection succeeding narrows the problem but does not establish that the remote path is valid. A mesh status reporting connected likewise describes its own control relationship.

## Application Failover Needs More Than Networking

A service moving requests between clusters can encounter different latency, cached state or database consistency. Network load balancing does not replicate the application's data or guarantee that a remote region can safely accept writes. The application needs a deliberate behavior for partial failures, retries and regional dependencies.

Observe the selected backend population and actual outcomes before claiming improved availability. Local preference can reduce some cross-cluster dependencies, but an outage can still propagate through shared external systems. Document the service-sharing intent, ownership and residual application requirements so connectivity and resilience claims remain precise.

## Common pitfalls

> [!WARNING]
> Global discovery is not application replication. Shared names, readiness, affinity and supported API integration must agree, while routes, policy and data consistency remain separate requirements.
