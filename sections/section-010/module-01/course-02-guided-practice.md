---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Inspect Cluster Identity, Address Ranges And Trust

A mesh that fails to connect almost always fails because of one of the prerequisites: a repeated name or ID, overlapping address ranges, a missing route between nodes, or two different certificate authorities. Each of these can be read from the clusters before any connection is attempted. This part turns the prerequisites into checks that you run against two clusters, and it shows what a fault in each one looks like.

## Where the identity is stored

Cilium reads its cluster name and cluster ID from the ConfigMap `cilium-config` in the `kube-system` namespace. The Helm values `cluster.name` and `cluster.id` write those two keys. The `cilium` agents read them at start, so a change takes effect only after the agents restart.

The identity has a second use. Every pod gets a security identity, which is a number derived from its labels. In a mesh the cluster name is part of the labels that Cilium adds to each endpoint, under the key `io.cilium.k8s.policy.cluster`. This is why two clusters with the same name cannot be told apart by policy.

Cilium also reads the ID when it creates the identity numbers. Two clusters with the same ID could produce the same identity number for different pods. For that reason every cluster in a mesh needs its own name and its own ID.

<!-- astrona:playground:renew -->

## Check the identity of both clusters

Open a shell in the playground and save the two context names:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Read the name and the ID from each cluster:

```sh
for context in "$WEST" "$EAST"; do
  kubectl --context "$context" -n kube-system get configmap cilium-config \
    -o jsonpath='{.data.cluster-name}{" "}{.data.cluster-id}{"\n"}'
done
```

The first line is `west 1` and the second is `east 2`. Because the values differ, the first prerequisite holds.

## Check the pod address ranges

Each node receives a pod range from the cluster's pod network. Two clusters whose ranges overlap would give the same IP address to pods in both, and a mesh cannot route to an address that exists twice.

```sh
for context in "$WEST" "$EAST"; do
  kubectl --context "$context" get nodes -o jsonpath='{.items[*].spec.podCIDR}{"\n"}'
done
```

The pod range of `west` starts with `10.241.` and the pod range of `east` starts with `10.242.`. They are different ranges, so they do not overlap.

## Check node reachability

The nodes of both clusters are kind containers on one container network. A pod in one cluster must be able to reach the node IP address of the other cluster, because the mesh data path runs between nodes. Read the node address of `east`:

```sh
EAST_NODE_IP="$(kubectl --context "$EAST" get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')"
echo "$EAST_NODE_IP"
```

Then request that address from the `shuttle` pod of `west` on the port of the Kubernetes API server of `east`:

```sh
kubectl --context "$WEST" -n starfleet exec shuttle -- curl -sk -o /dev/null -w "%{http_code}\n" --max-time 5 "https://$EAST_NODE_IP:6443"
```

Any HTTP status code shows that the packet reached the node of `east` and came back. No output and a timeout show that the path is blocked.

## Compare the certificate authority

Cluster Mesh uses mutual TLS between the clusters. Each side checks that the certificate of the other side was signed by a certificate authority that it trusts. Cilium stores its authority in the secret `cilium-ca` in `kube-system`. Print a fingerprint of the authority certificate of each cluster:

```sh
for context in "$WEST" "$EAST"; do
  kubectl --context "$context" -n kube-system get secret cilium-ca -o jsonpath='{.data.ca\.crt}' | base64 -d | openssl x509 -noout -fingerprint -sha256
done
```

In this playground both lines are identical, because the setup installed both clusters with the same authority. If the fingerprints differ, the clusters have different authorities. Cilium then needs an explicit trust bundle, or the clusters must be reinstalled with a common authority.

## Read the datapath mode

The datapath mode is stored in the same ConfigMap. Both clusters must use the same one:

```sh
for context in "$WEST" "$EAST"; do
  kubectl --context "$context" -n kube-system get configmap cilium-config -o jsonpath='{.data.routing-mode}{" "}{.data.tunnel-protocol}{"\n"}'
done
```

The two lines must match. A cluster in tunnel mode and a cluster in native routing mode cannot form a mesh.

## What you now know

You can read the five prerequisites from live clusters: the name and ID, the pod ranges, the node reachability, the certificate authority and the datapath mode. The checks are cheap and they run before any change, so they are the first step when a mesh does not form. What is still open is how to connect two clusters that pass all five checks.

## Common pitfalls

- Reading the name from the Helm release instead of from the ConfigMap that the agents actually use. The ConfigMap is what the running agents read.
- Assuming that a different cluster name is enough. The numeric ID must differ too.
- Comparing node ranges by eye. Compare the full ranges, because a short prefix can hide an overlap.
- Checking the certificate authority only after the connection fails with a TLS error.

> [!WARNING]
> Do not change the cluster name or ID of a cluster that already runs workloads without restarting those workloads. Their security identities were created with the old values.
