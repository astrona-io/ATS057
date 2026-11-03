#!/usr/bin/env bash
# Check: The bridge backends of west are not shared with east
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

value="$(kubectl --context "$WEST_CONTEXT" -n starfleet get service bridge -o jsonpath='{.metadata.annotations.service\.cilium\.io/global}' 2>/dev/null || true)"
if [ "$value" != "true" ]; then
  echo "FAIL: service bridge in $WEST_CONTEXT has service.cilium.io/global='$value', expected 'true'"
  fail=1
fi

value="$(kubectl --context "$WEST_CONTEXT" -n starfleet get service bridge -o jsonpath='{.metadata.annotations.service\.cilium\.io/shared}' 2>/dev/null || true)"
if [ "$value" != "false" ]; then
  echo "FAIL: service bridge in $WEST_CONTEXT has service.cilium.io/shared='$value', expected 'false'"
  fail=1
fi

value="$(kubectl --context "$EAST_CONTEXT" -n starfleet get service bridge -o jsonpath='{.metadata.annotations.service\.cilium\.io/global}' 2>/dev/null || true)"
if [ "$value" != "true" ]; then
  echo "FAIL: service bridge in $EAST_CONTEXT has service.cilium.io/global='$value', expected 'true'"
  fail=1
fi

[ "$fail" -eq 0 ] && echo "PASS: bridge is global in both clusters and not shared by west"
exit "$fail"
