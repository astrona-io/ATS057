# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-010-04` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

Cluster Mesh is enabled and the two clusters are connected. The team that runs `east` leaves the mesh. Today a `shuttle` pod of `west` can still reach a `probe` pod of `east` by its pod IP address.

1. Remove the connection between `west` and `east` in both directions.
2. Keep the `clustermesh-apiserver` running in both clusters, because the clusters may join again later.
3. Check that a pod of `west` can no longer reach a pod of `east` by its pod IP address.

Do not change the cluster names or IDs, and do not change the workloads.
