---
estimated_duration: 30m
---

# Lab: Restrict Cross-Cluster Traffic With A Cilium Network Policy

- **Slug:** ats-057-lab-010-03
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-010/module-03/labs/lab-01
astrona destroy ats-057-lab-010-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-policy-in-east.sh` | A CiliumNetworkPolicy exists in starfleet of east |
| `validate-west-shuttle-allowed.sh` | The shuttle in west can reach the probe pod in east |
| `validate-west-drifter-denied.sh` | The drifter in outpost of west cannot reach the probe pod in east |
| `validate-east-lookalike-denied.sh` | The shuttle in east (same labels as the shuttle in west) cannot reach the probe pod |
