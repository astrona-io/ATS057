# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/capstone/labs/lab-01
astrona shell ats-057-capstone-010
```

The environment has two clusters. `astrona shell ats-057-capstone-010` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Enable and connect Cluster Mesh

```sh
cilium clustermesh enable --context "$WEST" --service-type NodePort
cilium clustermesh enable --context "$EAST" --service-type NodePort
cilium clustermesh status --context "$WEST" --wait
cilium clustermesh status --context "$EAST" --wait
cilium clustermesh connect --context "$WEST" --destination-context "$EAST"
cilium clustermesh status --context "$WEST" --wait
cilium clustermesh status --context "$EAST" --wait
```

## Step 2: Check the data path

```sh
EAST_PROBE_IP="$(kubectl --context "$EAST" -n starfleet get pod -l app=probe -o jsonpath='{.items[0].status.podIP}')"
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
```

The reply is `probe from east`.

## Step 3: Write the policy in east

Save this as `cnp-probe-from-west-shuttle.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: probe-from-west-shuttle
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: shuttle
        io.cilium.k8s.policy.cluster: west
```

Apply it in `east`:

```sh
kubectl --context "$EAST" apply -f cnp-probe-from-west-shuttle.yaml
```

## Step 4: Test the three cases

```sh
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
kubectl --context "$WEST" -n outpost exec drifter -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
kubectl --context "$EAST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
```

Only the first request returns `probe from east`.

## Step 5: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-capstone-010
```
