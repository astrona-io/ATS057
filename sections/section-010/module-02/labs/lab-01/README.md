---
estimated_duration: 30m
---

# Lab: Enable And Connect Cluster Mesh

- **Slug:** ats-057-lab-010-02
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-057-lab-010-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-mesh-apiserver-ready.sh` | clustermesh-apiserver is ready in both clusters |
| `validate-mesh-apiserver-nodeport.sh` | The clustermesh-apiserver Service is a NodePort in both clusters |
| `validate-remote-cluster-config.sh` | Each cluster holds the connection details of the other |
| `validate-west-reaches-east-pod.sh` | A pod in west reaches a pod in east by its pod IP |
| `validate-east-reaches-west-pod.sh` | A pod in east reaches a pod in west by its pod IP |
