# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-010-01` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

The `drifter` team plans to connect `west` and `east` with Cluster Mesh. A review of the two Cilium installations found a problem that blocks the connection. Both clusters report the same Cilium cluster name and the same cluster ID. Cluster Mesh needs a unique name and a unique numeric ID for every cluster.

Fix the cluster `east` only:

1. Change the Cilium cluster name of `east` to `east` and its cluster ID to `2`. Keep every other Cilium setting of `east`.
2. Make the Cilium agents and the Cilium operator in `east` run with the new values, and wait until they are ready again.

The cluster `west` must keep the name `west` and the ID `1`. Do not enable Cluster Mesh in this lab. The Cilium command-line tool (`cilium`) and `kubectl` can both reach either cluster with `--context`.
