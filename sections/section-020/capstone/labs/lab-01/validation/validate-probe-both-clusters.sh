#!/usr/bin/env bash
# Check: probe is answered by both clusters for the shuttles of west and of east
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
expected="$(printf '%s\n' 'probe from east' 'probe from west' | sort -u)"
for context in "$WEST_CONTEXT" "$EAST_CONTEXT"; do
  actual="$(distinct_replies "$context" "http://probe")"
  if [ "$actual" != "$expected" ]; then
    echo "FAIL: the shuttle in $context does not get replies from both clusters for probe"
    echo "Got:"; echo "$actual"
    fail=1
  fi
done
[ "$fail" -eq 0 ] && echo "PASS: probe is answered by both clusters from both sides"
exit "$fail"
