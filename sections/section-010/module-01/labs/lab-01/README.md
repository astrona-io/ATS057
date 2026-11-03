---
estimated_duration: 30m
---

# Lab: Fix A Cluster Identity Conflict

- **Slug:** ats-057-lab-010-01
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-057-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-east-cluster-name.sh` | The cluster east has the Cilium cluster name east |
| `validate-east-cluster-id.sh` | The cluster east has the Cilium cluster ID 2 |
| `validate-west-identity-unchanged.sh` | The cluster west keeps the name west and the ID 1 |
| `validate-east-cilium-ready.sh` | The Cilium agents and the operator in east are ready after the change |
