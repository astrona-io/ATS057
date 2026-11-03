# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-010-02` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

The `shuttle` in `starfleet` must be able to reach a `probe` pod that runs in the other cluster by the IP address of that pod, from either cluster. Today it cannot: the two clusters run Cilium, but they do not know each other.

Connect the clusters with Cluster Mesh:

1. Enable Cluster Mesh in `west` and in `east`. The clusters run in kind, which has no load balancer, so the control plane of Cluster Mesh must be reachable on a node port.
2. Connect the two clusters.
3. Wait until the status of Cluster Mesh is healthy in both clusters.

Do not change the cluster names or IDs, and do not change the workloads.
