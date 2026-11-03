# Overview: Global Services And Cross-Cluster Discovery (Playground)

This is a **playground**, not a lab. It starts two clusters and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, run `astrona destroy ats-057-playground-020-01`, and start again.

## What is in the box

- Two single-node `kind` clusters running Kubernetes 1.35: `west` (the environment's own cluster) and `east` (a linked cluster).
- Cilium v1.20.4 in both clusters. Cluster Mesh is enabled and the two clusters are connected.
- Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

## Open a shell

Run `astrona shell ats-057-playground-020-01`. In that shell `kubectl` points at `west`. The context of `east` is in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables and use them in every command:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```


## Practice tasks

- Annotate `probe` as global in both clusters and count the distinct replies of 30 requests.
- Set `service.cilium.io/shared` to `false` in one cluster and compare what each cluster sees.
- Annotate a Service in one cluster only and observe the result.
- Remove an annotation again with `kubectl annotate service probe service.cilium.io/global-`.
