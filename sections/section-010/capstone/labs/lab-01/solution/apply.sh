#!/usr/bin/env bash
# Reference solution for ats-057-capstone-010, applied by `astrona test` only.
# UNTESTED: written from the documentation, not yet run.
set -euo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

cilium clustermesh enable --context "$WEST_CONTEXT" --service-type NodePort
cilium clustermesh enable --context "$EAST_CONTEXT" --service-type NodePort
cilium clustermesh status --context "$WEST_CONTEXT" --wait
cilium clustermesh status --context "$EAST_CONTEXT" --wait
cilium clustermesh connect --context "$WEST_CONTEXT" --destination-context "$EAST_CONTEXT"
cilium clustermesh status --context "$WEST_CONTEXT" --wait
cilium clustermesh status --context "$EAST_CONTEXT" --wait

cat <<'EOF' | kubectl --context "$EAST_CONTEXT" apply -f -
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
EOF
sleep 10
