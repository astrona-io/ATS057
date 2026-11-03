# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-01/labs/lab-01
astrona shell ats-057-lab-020-01
```

The environment has two clusters. `astrona shell ats-057-lab-020-01` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Look at the starting state

Request `probe` from the `shuttle` in `west` a few times. Every reply names `west`, because the Service has only local backends:

```sh
for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://probe; done
```

## Step 2: Make probe global in both clusters

A global service needs the same name and namespace in both clusters, and the annotation `service.cilium.io/global: "true"` on each:

```sh
kubectl --context "$WEST" -n starfleet annotate service probe service.cilium.io/global=true --overwrite
kubectl --context "$EAST" -n starfleet annotate service probe service.cilium.io/global=true --overwrite
```

Wait a few seconds and repeat the requests from step 1. Replies now name both clusters.

## Step 3: Make bridge global and stop west from sharing it

```sh
kubectl --context "$WEST" -n starfleet annotate service bridge service.cilium.io/global=true --overwrite
kubectl --context "$EAST" -n starfleet annotate service bridge service.cilium.io/global=true --overwrite
kubectl --context "$WEST" -n starfleet annotate service bridge service.cilium.io/shared=false --overwrite
```

## Step 4: Compare both clients

```sh
for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://bridge; done
for attempt in 1 2 3 4 5 6; do kubectl --context "$EAST" -n starfleet exec shuttle -- curl -s --max-time 3 http://bridge; done
```

The `shuttle` in `west` receives replies from both clusters. The `shuttle` in `east` receives replies from `east` only.

## Step 5: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-020-01
```
