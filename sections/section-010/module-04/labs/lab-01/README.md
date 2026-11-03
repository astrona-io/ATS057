---
estimated_duration: 30m
---

# Lab: Disconnect A Cluster From The Mesh

- **Slug:** ats-057-lab-010-04
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority, and Cluster Mesh is enabled and connected. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-04/labs/lab-01
astrona destroy ats-057-lab-010-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-west-has-no-east-entry.sh` | The secret of west has no entry for east |
| `validate-east-has-no-west-entry.sh` | The secret of east has no entry for west |
| `validate-west-cannot-reach-east-pod.sh` | A pod in west no longer reaches a pod in east by its pod IP |
| `validate-mesh-apiserver-still-ready.sh` | The clustermesh-apiserver still runs in both clusters |
