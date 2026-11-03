---
estimated_duration: 30m
---

# Lab: Create A Global Service Across Two Clusters

- **Slug:** ats-057-lab-020-01
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-057-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-probe-global-both.sh` | The Service probe is annotated as global in both clusters |
| `validate-probe-answers-from-both.sh` | A request to the probe Service from the shuttle in west is answered by both clusters |
| `validate-bridge-west-not-shared.sh` | The bridge backends of west are not shared with east |
| `validate-bridge-east-sees-only-east.sh` | The shuttle in east is answered only by bridge in east |
| `validate-bridge-west-sees-both.sh` | The shuttle in west is still answered by bridge in west and in east |
