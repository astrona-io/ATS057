# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-010-03` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

Cluster Mesh is already enabled and the two clusters are connected, so a pod in one cluster can reach a pod in the other by its pod IP. The security review found that anything in `west` can reach the `probe` pods in `east`. The `east` cluster also has its own `shuttle` pod with the same labels as the `shuttle` in `west`.

Write one policy that allows only the `shuttle` pod of `west` to reach the `probe` pods of `east` (port 5678):

1. The `shuttle` in `starfleet` of `west` can request a `probe` pod in `east` by its pod IP.
2. The `drifter` in `outpost` of `west` cannot reach the `probe` pods in `east`.
3. The `shuttle` in `starfleet` of `east` cannot reach the `probe` pods either. It has the same labels as the allowed pod, but it runs in the wrong cluster.

Use a `CiliumNetworkPolicy`. Do not change the pods, and do not disable Cluster Mesh.
