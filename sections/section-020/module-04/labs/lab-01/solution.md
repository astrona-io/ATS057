# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-04/labs/lab-01
astrona shell ats-057-lab-020-04
```

The environment has two clusters. `astrona shell ats-057-lab-020-04` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: See the symptom

```sh
for attempt in $(seq 1 20); do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://probe; echo; done | sort | uniq -c
```

Some lines are empty. The agent of `west` picks backends of both clusters, and the requests that go to `east` time out.

## Step 2: Find the cause

The Service is global in both clusters, so the mesh works. Read the policy in `east`:

```sh
kubectl --context "$EAST" -n starfleet get ciliumnetworkpolicies.cilium.io probe-from-shuttles -o yaml
```

The ingress rule allows the `shuttle` of the cluster `east` only. Requests from `west` are dropped by the agent of `east`.

## Step 3: Change the policy

Save this as `cnp-probe-from-shuttles.yaml`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: probe-from-shuttles
  namespace: starfleet
spec:
  endpointSelector:
    matchLabels:
      app: probe
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: shuttle
      matchExpressions:
      - key: io.cilium.k8s.policy.cluster
        operator: In
        values:
        - east
        - west
```

Apply it in `east`:

```sh
kubectl --context "$EAST" apply -f cnp-probe-from-shuttles.yaml
```

## Step 4: Check the result

```sh
for attempt in $(seq 1 20); do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 http://probe; echo; done | sort | uniq -c
```

No empty lines remain, and replies come from both clusters. The `drifter` is not listed in the policy, so it stays denied.

## Step 5: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-lab-020-04
```
