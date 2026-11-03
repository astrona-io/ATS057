#!/usr/bin/env bash
# Check: The drifter in west cannot reach the probe pod in east
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

east_ip="$(pod_ip "$EAST_CONTEXT" probe)"
if kubectl --context "$WEST_CONTEXT" -n outpost exec drifter -- curl -s --max-time 5 "http://$east_ip:5678" >/dev/null 2>&1; then
  echo "FAIL: the drifter in west can still reach the probe pod in east"
  exit 1
fi
echo "PASS: the drifter in west cannot reach the probe pod in east"
