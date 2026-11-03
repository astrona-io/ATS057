# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-03/labs/lab-01
astrona shell ats-057-lab-020-03
```

The environment has two clusters. `astrona shell ats-057-lab-020-03` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Enable MCS-API support in both clusters

The Cilium Helm value `clustermesh.mcsapi.enabled` turns on the support and installs the `ServiceExport` and `ServiceImport` custom resource definitions. `clustermesh.mcsapi.corednsAutoConfigure.enabled` lets Cilium edit CoreDNS for the `clusterset.local` domain:

```sh
for context in "$WEST" "$EAST"; do
  cilium upgrade --context "$context" --version v1.20.4 --reuse-values \
    --set clustermesh.mcsapi.enabled=true \
    --set clustermesh.mcsapi.corednsAutoConfigure.enabled=true --wait
  kubectl --context "$context" -n kube-system rollout restart deployment/cilium-operator
  kubectl --context "$context" -n kube-system rollout status deployment/cilium-operator --timeout=300s
done
```

## Step 2: Export bridge from both clusters

Save this as `serviceexport-bridge.yaml`:

```yaml
apiVersion: multicluster.x-k8s.io/v1beta1
kind: ServiceExport
metadata:
  name: bridge
  namespace: starfleet
```

Apply it in both clusters:

```sh
kubectl --context "$WEST" apply -f serviceexport-bridge.yaml
kubectl --context "$EAST" apply -f serviceexport-bridge.yaml
```

## Step 3: Wait for CoreDNS and test

```sh
kubectl --context "$WEST" -n kube-system rollout status deployment/coredns --timeout=300s
kubectl --context "$EAST" -n kube-system rollout status deployment/coredns --timeout=300s
for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://bridge.starfleet.svc.clusterset.local; done
```

The replies name both clusters.

## Step 4: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-020-03
```
