#!/usr/bin/env bash
# Reference solution for ats-057-capstone-020, applied by `astrona test` only.
# UNTESTED: written from the documentation, not yet run.
set -euo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

cat <<'EOF' | kubectl --context "$EAST_CONTEXT" apply -f -
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
EOF
kubectl --context "$WEST_CONTEXT" -n starfleet annotate service bridge service.cilium.io/affinity=local --overwrite
kubectl --context "$WEST_CONTEXT" -n starfleet annotate service scout service.cilium.io/shared=false --overwrite
sleep 15
