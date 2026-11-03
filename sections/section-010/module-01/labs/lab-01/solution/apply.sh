#!/usr/bin/env bash
# Reference solution for ats-057-lab-010-01, applied by `astrona test` only.
# UNTESTED: written from the documentation, not yet run.
set -euo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

cilium upgrade --context "$EAST_CONTEXT" --version v1.20.4 --reuse-values \
  --set cluster.name=east --set cluster.id=2 --wait
kubectl --context "$EAST_CONTEXT" -n kube-system rollout restart daemonset/cilium deployment/cilium-operator
kubectl --context "$EAST_CONTEXT" -n kube-system rollout status daemonset/cilium --timeout=300s
kubectl --context "$EAST_CONTEXT" -n kube-system rollout status deployment/cilium-operator --timeout=300s
