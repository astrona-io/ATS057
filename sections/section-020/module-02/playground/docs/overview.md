# Overview: Service Affinity And Failure Handling (Playground)

This is a **playground**, not a lab. It starts two clusters and then waits. There is no task, no `astrona submit` and no pass or fail. Change things, break them, run `astrona destroy ats-057-playground-020-02`, and start again.

## What is in the box

- Two single-node `kind` clusters running Kubernetes 1.35: `west` (the environment's own cluster) and `east` (a linked cluster).
- Cilium v1.20.4 in both clusters. Cluster Mesh is enabled and the two clusters are connected.
- Both clusters run the same example workloads in the namespace `starfleet`: the Deployments `probe`, `bridge` and `scout` (two replicas each, one Service each, port 80) and a client pod `shuttle`. Every replica answers a request with one line of text that names its workload and its cluster, for example `probe from east`. The cluster `west` also has a client pod `drifter` in the namespace `outpost`.

## Open a shell

Run `astrona shell ats-057-playground-020-02`. In that shell `kubectl` points at `west`. The context of `east` is in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables and use them in every command:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

The Services `probe` and `scout` already carry `service.cilium.io/global: "true"` in both clusters.


## Practice tasks

- Set the affinity of `probe` to `local`, then `remote`, then `none`, and watch the replies.
- With affinity `local`, scale the `probe` Deployment of `west` to zero and request the Service again. Scale it back.
- Read the preferred backends with `kubectl -n kube-system exec ds/cilium -- cilium-dbg service list --clustermesh-affinity`.
- Stop the connection by scaling `clustermesh-apiserver` in `east` to zero and observe what `west` still does.
