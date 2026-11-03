# Overview: Enable And Connect Cluster Mesh (Playground)

This is a **playground**, not a lab. It starts two clusters and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, run `astrona destroy ats-057-playground-010-02`, and start again.

## What is in the box

- Two single-node `kind` clusters running Kubernetes 1.35: `west` (the environment's own cluster) and `east` (a linked cluster).
- Cilium v1.20.4 in both clusters. Cluster Mesh is not enabled yet: the two clusters do not know each other.
- Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

## Open a shell

Run `astrona shell ats-057-playground-010-02`. In that shell `kubectl` points at `west`. The context of `east` is in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables and use them in every command:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```


## Practice tasks

- Enable Cluster Mesh in both clusters with a node port, read the Pods that appear in `kube-system`, then connect the clusters.
- Read `cilium clustermesh status` in both clusters.
- Request a `probe` pod of the other cluster by its pod IP from the `shuttle`.
- Delete the connection secret and observe the status, then connect again.
