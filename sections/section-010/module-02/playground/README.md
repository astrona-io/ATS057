# Enable And Connect Cluster Mesh - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-057-playground-010-02
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** UNTESTED. Written from the documentation; static checks only.

Two kind clusters side by side: `west` and `east`, both running Cilium v1.20.4. Cluster Mesh is not enabled yet: the two clusters do not know each other. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona shell ats-057-playground-010-02
astrona destroy ats-057-playground-010-02
```
