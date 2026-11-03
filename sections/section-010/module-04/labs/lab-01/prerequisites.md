# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 6 GiB of free memory. The environment starts two clusters and runs Cilium in each.
- `kubectl`, `jq` and the Cilium command-line tool (`cilium`, version 0.20 or newer).

The environment starts two single-node kind clusters (Kubernetes 1.35) named `west` and `east`, installs Cilium v1.20.4 in both, and deploys the example workloads. Starting takes several minutes.
