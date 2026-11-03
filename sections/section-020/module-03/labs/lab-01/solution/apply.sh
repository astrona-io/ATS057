#!/usr/bin/env bash
# Reference solution for ats-057-lab-020-03, applied by `astrona test` only.
# UNTESTED: written from the documentation, not yet run.
set -euo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

for context in "$WEST_CONTEXT" "$EAST_CONTEXT"; do
  cilium upgrade --context "$context" --version v1.20.4 --reuse-values \
    --set clustermesh.mcsapi.enabled=true \
    --set clustermesh.mcsapi.corednsAutoConfigure.enabled=true --wait
  kubectl --context "$context" -n kube-system rollout restart deployment/cilium-operator
  kubectl --context "$context" -n kube-system rollout status deployment/cilium-operator --timeout=300s
done
for context in "$WEST_CONTEXT" "$EAST_CONTEXT"; do
  kubectl --context "$context" wait --for condition=established crd/serviceexports.multicluster.x-k8s.io --timeout=120s
  cat <<'EOF' | kubectl --context "$context" apply -f -
apiVersion: multicluster.x-k8s.io/v1beta1
kind: ServiceExport
metadata:
  name: bridge
  namespace: starfleet
EOF
  kubectl --context "$context" -n kube-system rollout status deployment/coredns --timeout=300s
done
sleep 20
