# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-02/labs/lab-01
astrona shell ats-057-lab-020-02
```

The environment has two clusters. `astrona shell ats-057-lab-020-02` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Look at the starting state

The `shuttle` in `west` receives replies from both clusters for both Services:

```sh
for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://probe; done
for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://scout; done
```

## Step 2: Set the affinity in west

The annotation `service.cilium.io/affinity` accepts `none` (the default), `local` and `remote`. It only changes the choice of the cluster that carries the annotation:

```sh
kubectl --context "$WEST" -n starfleet annotate service probe service.cilium.io/affinity=local --overwrite
kubectl --context "$WEST" -n starfleet annotate service scout service.cilium.io/affinity=remote --overwrite
```

## Step 3: Test both clients

Wait a few seconds, then request both Services again from the `shuttle` of `west` and of `east`:

```sh
for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://probe; done
for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://scout; done
for attempt in 1 2 3 4 5 6; do kubectl --context "$EAST" -n starfleet exec shuttle -- curl -s --max-time 3 http://probe; done
```

`west` now gets `probe` replies from `west` only and `scout` replies from `east` only. `east` still gets replies from both clusters.

## Step 4 (optional): Prove the fallback

Scale the `probe` Deployment in `west` to zero, request `probe` from the `shuttle` of `west`, and scale it back to two:

```sh
kubectl --context "$WEST" -n starfleet scale deployment probe --replicas=0
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://probe
kubectl --context "$WEST" -n starfleet scale deployment probe --replicas=2
kubectl --context "$WEST" -n starfleet rollout status deployment/probe
```

With no healthy local pod, the reply comes from `east`. Scale the Deployment back before you submit.

## Step 5: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-020-02
```
