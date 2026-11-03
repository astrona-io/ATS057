---
estimated_duration: 30m
---

# Lab: Prefer Local Or Remote Backends With Service Affinity

- **Slug:** ats-057-lab-020-02
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-057-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-probe-affinity-local.sh` | The shuttle in west is answered only by probe pods of west |
| `validate-scout-affinity-remote.sh` | The shuttle in west is answered only by scout pods of east |
| `validate-east-unchanged.sh` | The shuttle in east is still answered by both clusters for probe and scout |
| `validate-services-still-global.sh` | The Services are still global in both clusters |
