#!/usr/bin/env bash
# Check: Each cluster holds the connection details of the other
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

fail=0
check_remote() {
  local context="$1" remote="$2"
  if ! kubectl --context "$context" -n kube-system get secret cilium-clustermesh -o json 2>/dev/null | jq -e --arg remote "$remote" '.data | has($remote)' >/dev/null; then
    echo "FAIL: the secret cilium-clustermesh in $context has no entry for the cluster '$remote'"
    fail=1
  fi
}
check_remote "$WEST_CONTEXT" east
check_remote "$EAST_CONTEXT" west
[ "$fail" -eq 0 ] && echo "PASS: each cluster holds the connection details of the other"
exit "$fail"
