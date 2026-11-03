---
estimated_duration: 30m
---

# Lab: Repair And Tune Cross-Cluster Service Discovery

- **Slug:** ats-057-capstone-020
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-057-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-probe-both-clusters.sh` | probe is answered by both clusters for the shuttles of west and of east |
| `validate-bridge-west-prefers-local.sh` | The shuttle in west is answered only by bridge pods of west |
| `validate-bridge-east-unchanged.sh` | The shuttle in east is still answered by bridge in both clusters |
| `validate-scout-west-private.sh` | The scout pods of west are not offered to east |
| `validate-scout-west-uses-both.sh` | The shuttle in west is still answered by scout in both clusters |
