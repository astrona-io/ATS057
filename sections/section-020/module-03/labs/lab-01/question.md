# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-020-03` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

Cluster Mesh is enabled and the clusters are connected. The team wants to discover `bridge` across clusters with the standard Multi-Cluster Services API (MCS-API) instead of the Cilium annotations. The clients must request `bridge.starfleet.svc.clusterset.local` and be answered by the `bridge` pods of both clusters.

1. Enable MCS-API support in the Cilium installation of both clusters. Let Cilium configure CoreDNS for the `clusterset.local` domain.
2. Export the Service `bridge` from both clusters with a `ServiceExport` in the namespace `starfleet`.
3. From the `shuttle` of each cluster, `http://bridge.starfleet.svc.clusterset.local` must be answered by `bridge` pods of both clusters.

Do not add `service.cilium.io` annotations to any Service, and do not change the pods.
