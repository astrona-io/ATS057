#!/usr/bin/env bash
# Reference solution for ats-057-lab-020-01, applied by `astrona test` only.
# UNTESTED: written from the documentation, not yet run.
set -euo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

for context in "$WEST_CONTEXT" "$EAST_CONTEXT"; do
  kubectl --context "$context" -n starfleet annotate service probe service.cilium.io/global=true --overwrite
  kubectl --context "$context" -n starfleet annotate service bridge service.cilium.io/global=true --overwrite
done
kubectl --context "$WEST_CONTEXT" -n starfleet annotate service bridge service.cilium.io/shared=false --overwrite
sleep 15
