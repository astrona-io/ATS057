# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-04/labs/lab-01
astrona shell ats-057-lab-010-04
```

The environment has two clusters. `astrona shell ats-057-lab-010-04` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Read the state before the change

```sh
cilium clustermesh status --context "$WEST"
kubectl --context "$WEST" -n kube-system get secret cilium-clustermesh -o json | jq -r '.data | keys[]'
```

The status lists `east` as a connected cluster, and the secret has an entry named `east`.

## Step 2: Disconnect the clusters

`cilium clustermesh disconnect` removes the connection details from the secret of both clusters. It does not remove the `clustermesh-apiserver`:

```sh
cilium clustermesh disconnect --context "$WEST" --destination-context "$EAST"
```

## Step 3: Check the secrets

```sh
kubectl --context "$WEST" -n kube-system get secret cilium-clustermesh -o json | jq -r '.data // {} | keys[]'
kubectl --context "$EAST" -n kube-system get secret cilium-clustermesh -o json | jq -r '.data // {} | keys[]'
```

No entry for the other cluster remains. If the agents still hold the old remote endpoints, wait about twenty seconds.

## Step 4: Check the data path

Read the IP address of a `probe` pod in `east` and request it from the `shuttle` in `west`:

```sh
EAST_PROBE_IP="$(kubectl --context "$EAST" -n starfleet get pod -l app=probe -o jsonpath='{.items[0].status.podIP}')"
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
```

The request prints nothing and ends after five seconds.

## Step 5: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-010-04
```
