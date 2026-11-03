# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-02/labs/lab-01
astrona shell ats-057-lab-010-02
```

The environment has two clusters. `astrona shell ats-057-lab-010-02` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Enable Cluster Mesh in both clusters

`cilium clustermesh enable` deploys the `clustermesh-apiserver` and creates its certificates. Use a node port because kind has no load balancer:

```sh
cilium clustermesh enable --context "$WEST" --service-type NodePort
cilium clustermesh enable --context "$EAST" --service-type NodePort
```

## Step 2: Wait for the control plane of each cluster

```sh
cilium clustermesh status --context "$WEST" --wait
cilium clustermesh status --context "$EAST" --wait
```

## Step 3: Connect the clusters

One command connects both directions:

```sh
cilium clustermesh connect --context "$WEST" --destination-context "$EAST"
```

## Step 4: Check the connection

```sh
cilium clustermesh status --context "$WEST" --wait
cilium clustermesh status --context "$EAST" --wait
```

Then test the data path by hand. Read the IP address of a `probe` pod in `east` and request it from the `shuttle` in `west`:

```sh
EAST_PROBE_IP="$(kubectl --context "$EAST" -n starfleet get pod -l app=probe -o jsonpath='{.items[0].status.podIP}')"
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
```

The reply is `probe from east`.

## Step 5: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-010-02
```
