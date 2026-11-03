---
draft: true
exam_objectives:
- Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity
---
# Connection Modes And The Connection Secret

Connecting two clusters is simple. Connecting many clusters raises questions: which clusters must know each other, and what does each one store? The answers depend on the connection mode and on the format of the secret that holds the connection details. This part explains the modes, the content of the secret and what an agent does when it reads it.

## Connection modes

The option `--connection-mode` of `cilium clustermesh connect` selects who learns about whom:

- `bidirectional`, the default, writes the connection details of the destination into the source cluster and the other way round. The clusters then read each other.
- `unicast` writes the details of the destination into the source cluster only. The source cluster reads the destination, and the destination does not read the source. Use it when the destination must not hold credentials for the source, or when only the source can reach the destination over the network.
- `mesh` connects a set of clusters to each other. It needs the command to know more than two clusters, with several destination contexts.

A unicast connection gives one-way knowledge. Pods of the source can reach pods of the destination, but the destination agents do not learn the source endpoints, so replies and policy on the destination side behave differently. Choose it only when you understand that asymmetry.

## What the secret contains

The agents read the secret `cilium-clustermesh` in `kube-system`. For each remote cluster it holds one key named after the cluster, which contains a small configuration file with the address of the remote apiserver and the paths of three files. The three files are stored as further keys of the same secret: the certificate authority that signed the remote server certificate, the client certificate and the client key.

The agent mounts the secret as a directory. When the content changes, the agent notices the new files and opens or closes connections without a restart. The same secret therefore works as the list of remote clusters: add a key and the agent connects, remove a key and the agent disconnects.

## Static configuration

Some environments cannot run the connect command, for example when a GitOps tool owns every object. The Helm value `clustermesh.config.enabled` with a list under `clustermesh.config.clusters` writes the remote clusters into the release instead. Each entry has the cluster name, the address, the port and the certificates. The effect is the same as the connect command: the agents see the same secret and connect.

## Why one authority matters

The remote apiserver accepts a client certificate only if its own trust store contains the authority that signed it. With one shared authority in both clusters, this holds without extra work. With different authorities, the option `--allow-mismatching-ca` skips the check in the tool, and you must add the authority of the other cluster to the trust of each apiserver yourself.

<!-- astrona:playground:renew -->

## Read the secret in the playground

Open a shell in the playground and save the context names:

```sh
export WEST="$(kubectl config current-context)"
export EAST="$ASTRONA_CLUSTER_EAST_CONTEXT"
```

Enable and connect the clusters:

```sh
cilium clustermesh enable --context "$WEST" --service-type NodePort
cilium clustermesh enable --context "$EAST" --service-type NodePort
cilium clustermesh status --context "$WEST" --wait
cilium clustermesh status --context "$EAST" --wait
cilium clustermesh connect --context "$WEST" --destination-context "$EAST"
```

List all keys of the secret in `west`:

```sh
kubectl --context "$WEST" -n kube-system get secret cilium-clustermesh -o json | jq -r '.data | keys[]'
```

The list has the key `east` and the keys for its certificate authority, certificate and key. Decode the configuration file of the remote cluster:

```sh
kubectl --context "$WEST" -n kube-system get secret cilium-clustermesh -o jsonpath='{.data.east}' | base64 -d
```

The file shows the address that the agents of `west` use to reach `east`. In the playground that address is the node IP address of `east` with its node port. Compare it with the node port that the Service of `east` reports to see that they match.

## What you now know

The connection mode decides whether one cluster or both learn the connection details. The secret `cilium-clustermesh` is the list of remote clusters, and agents follow its content without a restart. Helm values can write the same list when a tool owns the cluster. What is still open is how to remove a connection and how to keep a mesh healthy over time.

## Common pitfalls

- Choosing `unicast` to save a command and then expecting two-way reachability.
- Copying the secret between clusters by hand and breaking the certificate pairing.
- Editing the secret in one cluster after a GitOps tool owns it, so the tool reverts the change.
- Assuming that the agent must restart to learn a new remote cluster.

> [!WARNING]
> The secret holds a client private key for the remote cluster. Do not print the keys, and do not commit the secret to a repository.
