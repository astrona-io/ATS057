#!/usr/bin/env bash
# Check: The shuttle in west is answered by probe pods of both clusters
# UNTESTED: written from the documentation, not yet run.
set -uo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

# Prints the IP address of the first pod that has the label app=<name>.
pod_ip() {
  kubectl --context "$1" -n starfleet get pod -l "app=$2" -o jsonpath='{.items[0].status.podIP}'
}

# Sends 30 requests from the shuttle pod of one cluster to a URL and prints
# one line per request: the reply, or the word FAILED.
sample_replies() {
  local context="$1" url="$2" attempt reply
  for attempt in $(seq 1 30); do
    reply="$(kubectl --context "$context" -n starfleet exec shuttle -- curl -s --max-time 3 "$url" 2>/dev/null)" || reply=""
    echo "${reply:-FAILED}"
  done
}

replies="$(sample_replies "$WEST_CONTEXT" http://probe | sort -u)"
fail=0
echo "$replies" | grep -qx 'probe from west' || { echo "FAIL: no reply from probe in west"; fail=1; }
echo "$replies" | grep -qx 'probe from east' || { echo "FAIL: no reply from probe in east"; fail=1; }
[ "$fail" -eq 0 ] && echo "PASS: probe answers from both clusters"
exit "$fail"
