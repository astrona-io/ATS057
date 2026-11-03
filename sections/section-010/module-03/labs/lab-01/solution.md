# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-03/labs/lab-01
astrona shell ats-057-lab-010-03
```

The environment has two clusters. `astrona shell ats-057-lab-010-03` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Prove the starting state

Read the IP address of a `probe` pod in `east` and request it from both clients in `west`:

```sh
EAST_PROBE_IP="$(kubectl --context "$EAST" -n starfleet get pod -l app=probe -o jsonpath='{.items[0].status.podIP}')"
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
kubectl --context "$WEST" -n outpost exec drifter -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
```

Both requests succeed because no policy selects the `probe` pods yet.

## Step 2: Write the policy

The destination cluster enforces an ingress rule, so the policy goes to `east`. The key `io.cilium.k8s.policy.cluster` is the label that carries the cluster name of an endpoint. Save this as `cnp-probe-from-west-shuttle.yaml`:

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

## Step 3: Test the three cases

Wait a few seconds for the agents to load the policy, then request the `probe` pod from the three clients:

```sh
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
kubectl --context "$WEST" -n outpost exec drifter -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
kubectl --context "$EAST" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$EAST_PROBE_IP:5678"
```

The first request returns `probe from east`. The other two time out and `curl` exits with an error.

## Step 4: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-010-03
```
