# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-capstone-020` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

Cluster Mesh is enabled and the clusters are connected. The Services `bridge` and `scout` are global in both clusters. The Service `probe` is annotated as global in `west`, but clients still reach only the local `probe` pods. Fix and tune the three Services:

1. `probe`: the `shuttle` of each cluster must be answered by `probe` pods of both clusters. Find out why `east` does not offer its pods and fix it.
2. `bridge`: the `shuttle` of `west` must be answered only by `bridge` pods of `west` while they are healthy. The `shuttle` of `east` must keep using both clusters.
3. `scout`: the `scout` pods of `west` must not be offered to `east`, so the `shuttle` of `east` is answered only by `scout` pods of `east`. The `shuttle` of `west` must still use `scout` pods of both clusters.

Use Services and annotations only. Do not change the Deployments, and do not disable Cluster Mesh.
