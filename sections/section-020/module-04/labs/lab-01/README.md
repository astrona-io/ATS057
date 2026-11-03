---
estimated_duration: 30m
---

# Lab: Fix Timeouts For A Global Service

- **Slug:** ats-057-lab-020-04
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority, and Cluster Mesh is enabled and connected. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-04/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-04/labs/lab-01
astrona destroy ats-057-lab-020-04
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-west-no-timeouts.sh` | Requests from the shuttle in west to probe do not time out |
| `validate-west-reaches-both-clusters.sh` | The shuttle in west is answered by probe pods of both clusters |
| `validate-drifter-still-denied.sh` | The drifter in outpost still cannot reach the probe pods of east |
| `validate-policy-and-global-kept.sh` | The policy in east exists and probe is still global |
