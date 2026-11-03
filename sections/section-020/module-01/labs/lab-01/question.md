# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-020-01` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

Cluster Mesh is already enabled and the clusters are connected. The Services `probe` and `bridge` exist in both clusters, but each Service only uses the pods of its own cluster.

1. Make the Service `probe` a global service in both clusters. A request to `probe` from the `shuttle` of either cluster must then be answered by pods of both clusters.
2. Make the Service `bridge` global in both clusters, but do not offer the `bridge` pods of `west` to `east`. The `shuttle` of `east` must be answered only by `bridge` pods of `east`. The `shuttle` of `west` must still be answered by `bridge` pods of both clusters.

Use Service annotations only. Do not delete or recreate the Services, and do not change the pods.
