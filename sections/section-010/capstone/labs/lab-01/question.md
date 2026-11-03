# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-capstone-010` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

The two clusters run Cilium but are not connected. The platform team needs the `shuttle` of `west` to reach the `probe` pods of `east` by pod IP, and nothing else in either cluster may reach them.

1. Enable Cluster Mesh in both clusters (kind has no load balancer, so use a node port) and connect them. Wait until the status is healthy in both.
2. Write a `CiliumNetworkPolicy` in `east` so that only the `shuttle` pod of `west` can reach the `probe` pods of `east` on port 5678.
3. The `drifter` in `outpost` of `west` and the `shuttle` of `east` (same labels as the allowed pod, wrong cluster) must be denied.

Do not change the cluster names or IDs and do not change the pods.
