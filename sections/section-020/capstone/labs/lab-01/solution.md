# Solution

Solve this lab on `terminal`. The environment starts two clusters and runs Cilium in each, so `astrona run` takes several minutes. Each step ends with `astrona submit` so that you see which checks pass.

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/capstone/labs/lab-01
astrona shell ats-057-capstone-020
```

The environment has two clusters. `astrona shell ats-057-capstone-020` opens a shell in which `kubectl` points at the cluster `west`. The second cluster, `east`, is reached through the context named in `$ASTRONA_CLUSTER_EAST_CONTEXT`. Set two shell variables once:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

## Step 1: Find the fault in probe

A global service needs a Service with the same name and namespace in every cluster. List the Services in both clusters:

```sh
kubectl --context "$WEST" -n starfleet get service
kubectl --context "$EAST" -n starfleet get service
```

The Service `probe` exists in `west` only. The `probe` pods of `east` run, but no Service exposes them to the mesh.

## Step 2: Create probe in east

Save this as `service-probe-east.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: probe
  namespace: starfleet
  annotations:
    service.cilium.io/global: "true"
spec:
  selector:
    app: probe
  ports:
  - port: 80
    targetPort: 5678
```

Apply it in `east`:

```sh
kubectl --context "$EAST" apply -f service-probe-east.yaml
```

## Step 3: Tune bridge and scout in west

```sh
kubectl --context "$WEST" -n starfleet annotate service bridge service.cilium.io/affinity=local --overwrite
kubectl --context "$WEST" -n starfleet annotate service scout service.cilium.io/shared=false --overwrite
```

## Step 4: Test every client

Wait a few seconds, then request each Service from the `shuttle` of each cluster:

```sh
for svc in probe bridge scout; do
  echo "--- west: $svc"
  for attempt in 1 2 3 4 5 6; do kubectl --context "$WEST" -n starfleet exec shuttle -- curl -s --max-time 3 "http://$svc"; done
  echo "--- east: $svc"
  for attempt in 1 2 3 4 5 6; do kubectl --context "$EAST" -n starfleet exec shuttle -- curl -s --max-time 3 "http://$svc"; done
done
```

## Step 5: Submit

```sh
astrona submit
```

When every step is done, leave the shell and remove the environment:

```sh
exit
astrona destroy ats-057-capstone-020
```
