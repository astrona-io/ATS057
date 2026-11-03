#!/usr/bin/env bash
# Check: A pod in east reaches a pod in west by its pod IP
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

west_ip="$(pod_ip "$WEST_CONTEXT" probe)"
reply="$(kubectl --context "$EAST_CONTEXT" -n starfleet exec shuttle -- curl -s --max-time 5 "http://$west_ip:5678" 2>/dev/null || true)"
if [ "$reply" = "probe from west" ]; then
  echo "PASS: the shuttle in east reached a probe pod in west by its pod IP"
  exit 0
fi
echo "FAIL: the shuttle in east did not get 'probe from west' from the pod IP $west_ip"
exit 1
