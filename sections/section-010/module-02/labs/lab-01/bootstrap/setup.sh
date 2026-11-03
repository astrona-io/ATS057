#!/usr/bin/env bash
# Starting state: Enable And Connect Cluster Mesh.
# Two kind clusters: "west" (this environment's own cluster) and "east" (the
# linked cluster). Both run Cilium with one shared certificate authority.
# UNTESTED: written from the documentation, not yet run.
set -euo pipefail

EAST_CONTEXT="${ASTRONA_CLUSTER_EAST_CONTEXT:?ASTRONA_CLUSTER_EAST_CONTEXT is not set}"
if ! kubectl config get-contexts -o name | grep -qx "$EAST_CONTEXT"; then
  export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}:${ASTRONA_CLUSTER_EAST_KUBECONFIG:?ASTRONA_CLUSTER_EAST_KUBECONFIG is not set}"
fi
WEST_CONTEXT="$(kubectl config current-context)"

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CILIUM_VERSION="v1.20.4"

work_dir="$(mktemp -d)"
trap 'rm -rf "$work_dir"' EXIT

# One certificate authority for both clusters. Cluster Mesh needs every
# cluster to trust the certificates of the others.
openssl req -x509 -newkey rsa:2048 -nodes -days 365 -subj "/CN=Cilium CA" \
  -keyout "$work_dir/ca.key" -out "$work_dir/ca.crt" >/dev/null 2>&1
CA_CERT="$(base64 < "$work_dir/ca.crt" | tr -d '\n')"
CA_KEY="$(base64 < "$work_dir/ca.key" | tr -d '\n')"

install_cilium() {
  local context="$1" cluster_name="$2" cluster_id="$3"
  cilium install --context "$context" --version "$CILIUM_VERSION" \
    --set cluster.name="$cluster_name" --set cluster.id="$cluster_id" \
    --set ipam.mode=kubernetes --set operator.replicas=1 \
    --set tls.ca.cert="$CA_CERT" --set tls.ca.key="$CA_KEY" \
    --wait --wait-duration 8m
}

install_cilium "$WEST_CONTEXT" west 1
install_cilium "$EAST_CONTEXT" east 2

kubectl --context "$WEST_CONTEXT" apply -f "$DIR/bootstrap/manifests/west.yaml"
kubectl --context "$EAST_CONTEXT" apply -f "$DIR/bootstrap/manifests/east.yaml"

for context in "$WEST_CONTEXT" "$EAST_CONTEXT"; do
  for name in probe bridge scout; do
    kubectl --context "$context" -n starfleet rollout status "deployment/$name" --timeout=240s
  done
  kubectl --context "$context" -n starfleet wait --for=condition=Ready pod/shuttle --timeout=240s
done
kubectl --context "$WEST_CONTEXT" -n outpost wait --for=condition=Ready pod/drifter --timeout=240s
echo "[env] Ready."
