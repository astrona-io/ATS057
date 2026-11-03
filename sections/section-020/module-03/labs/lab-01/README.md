---
estimated_duration: 30m
---

# Lab: Export A Service With The Multi-Cluster Services API

- **Slug:** ats-057-lab-020-03
- **Status:** UNTESTED. The files were written from the documentation and checked statically (`astrona validate`, `bash -n`). The lab has not been started yet.

Graded lab. The environment is two kind clusters side by side: `west` (the lab's own cluster) and `east` (a linked cluster, `runtime.kind.clusters`). Both run Cilium with one shared certificate authority. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-03/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS057.git -c sections/section-020/module-03/labs/lab-01
astrona destroy ats-057-lab-020-03
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-serviceexport-west.sh` | The Service bridge is exported from west with a ServiceExport |
| `validate-serviceexport-east.sh` | The Service bridge is exported from east with a ServiceExport |
| `validate-clusterset-dns-west.sh` | The shuttle in west reaches bridge in both clusters through the clusterset.local name |
| `validate-clusterset-dns-east.sh` | The shuttle in east reaches bridge in both clusters through the clusterset.local name |
