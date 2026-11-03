# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-01/labs/lab-01
astrona shell ats-057-lab-010-01
```

The environment has two clusters. `astrona shell ats-057-lab-010-01` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Read the identity of both clusters

The Cilium configuration holds the cluster name and the cluster ID in the ConfigMap `cilium-config` in `kube-system`. Read both values in both clusters:

```sh
for context in "$WEST" "$EAST"; do
  kubectl --context "$context" -n kube-system get configmap cilium-config -o jsonpath='{.data.cluster-name}{" "}{.data.cluster-id}{"\n"}'
done
```

Both lines show the same name and the same ID. That is the fault.

## Step 2: Change the identity of east

`cilium upgrade` changes the Helm values of the Cilium installation. `--reuse-values` keeps every value you do not change:

```sh
cilium upgrade --context "$EAST" --version v1.20.4 --reuse-values \
  --set cluster.name=east --set cluster.id=2 --wait
```

## Step 3: Restart the Cilium components in east

The agents read the cluster name and ID when they start. Restart them and the operator, then wait for the rollout:

```sh
kubectl --context "$EAST" -n kube-system rollout restart daemonset/cilium deployment/cilium-operator
kubectl --context "$EAST" -n kube-system rollout status daemonset/cilium --timeout=300s
kubectl --context "$EAST" -n kube-system rollout status deployment/cilium-operator --timeout=300s
```

Cilium also asks you to restart workloads after a change of cluster name or ID, because their identities carry the cluster name. In this lab the workloads have no cross-cluster traffic yet, so the checks do not need it.

## Step 4: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-010-01
```
