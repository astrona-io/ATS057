# Question

Solve this question on: `terminal`

The environment has two clusters. `astrona shell ats-057-lab-020-04` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

Cluster Mesh is enabled and the Services `probe` and `scout` are global in both clusters. Since a policy change in `east`, about half of the requests from the `shuttle` of `west` to the Service `probe` time out. Requests from the `shuttle` of `east` work.

1. Find the cause and change it so that all requests from `west` to `probe` get a reply, from `probe` pods of both clusters.
2. The `drifter` in `outpost` must stay unable to reach the `probe` pods of `east`.

Change the policy in `east` only. Keep the policy, and keep both Services global. Do not change the pods.
