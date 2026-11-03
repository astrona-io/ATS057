#!/usr/bin/env bash
# Check: The Cilium agents and the operator in east are ready after the change
# UNTESTED: written from the documentation, not yet run.
set -uo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

# Sends 30 requests from the shuttle pod of one cluster and prints each
# distinct reply once.
distinct_replies() {
  local context="$1" url="$2" attempt
  for attempt in $(seq 1 30); do
    kubectl --context "$context" -n starfleet exec shuttle -- curl -s --max-time 3 "$url" 2>/dev/null || true
  done | sort -u
}

# Prints the IP address of the first pod that has the label app=<name>.
pod_ip() {
  kubectl --context "$1" -n starfleet get pod -l "app=$2" -o jsonpath='{.items[0].status.podIP}'
}

desired="$(kubectl --context "$EAST_CONTEXT" -n kube-system get daemonset cilium -o jsonpath='{.status.desiredNumberScheduled}' 2>/dev/null || echo 0)"
ready="$(kubectl --context "$EAST_CONTEXT" -n kube-system get daemonset cilium -o jsonpath='{.status.numberReady}' 2>/dev/null || echo 0)"
operator="$(kubectl --context "$EAST_CONTEXT" -n kube-system get deployment cilium-operator -o jsonpath='{.status.readyReplicas}' 2>/dev/null || echo 0)"
if [ "$desired" -ge 1 ] && [ "$ready" = "$desired" ] && [ "${operator:-0}" -ge 1 ]; then
  echo "PASS: the Cilium agents and the operator in east are ready"; exit 0
fi
echo "FAIL: agents ready $ready of $desired, operator ready replicas ${operator:-0}"; exit 1
