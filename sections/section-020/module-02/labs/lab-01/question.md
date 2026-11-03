# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-020-02` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

Cluster Mesh is enabled and the Services `probe` and `scout` are already global in both clusters. Today a request from the `shuttle` of either cluster is balanced across the pods of both clusters.

1. The clients in `west` must use the `probe` pods of `west` as long as those pods are healthy. Fall back to `east` only if all local pods fail.
2. The clients in `west` must use the `scout` pods of `east` as long as those pods are healthy.
3. The clients in `east` must keep balancing `probe` and `scout` across both clusters.

Use Service annotations in `west` only. Keep both Services global. Do not change the pods.
