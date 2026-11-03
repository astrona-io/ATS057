# Global Services And Cross-Cluster Discovery - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-057-playground-020-01
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Written from the documentation; static checks only.

Two kind clusters side by side: `west` and `east`, both running Cilium v1.20.4. Cluster Mesh is enabled and the two clusters are connected. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona shell ats-057-playground-020-01
astrona destroy ats-057-playground-020-01
```
