# Cluster Mesh (ATS057)

Cilium Certified Associate (CCA): Cluster Mesh, worth 10% of the official curriculum. This course belongs to ATP011.

Developed reading explains mechanisms, responsible components, examples and limits. Every section has an introduction and every module closes with a summary. Reusable YAML checks contain 5–15 questions per bank. Technical content remains draft. Two-cluster playgrounds, graded labs, capstones and quizzes are included.

## Course Outline

| Section / module | Module | Teaching files |
| --- | --- | --- |
| 010 / 01 | Cluster Mesh Architecture And Prerequisites | 4 parts and a summary |
| 010 / 02 | Enable And Connect Cluster Mesh | 4 parts and a summary |
| 010 / 03 | Cross-Cluster Connectivity And Network Policy | 4 parts and a summary |
| 010 / 04 | Operate And Troubleshoot Cluster Mesh | 4 parts and a summary |
| 020 / 01 | Global Services And Cross-Cluster Discovery | 4 parts and a summary |
| 020 / 02 | Service Affinity And Failure Handling | 4 parts and a summary |
| 020 / 03 | Multi-Cluster Services API And EndpointSlice Synchronization | 4 parts and a summary |
| 020 / 04 | Troubleshoot Global Services | 4 parts and a summary |

## Author Review

See [curriculum coverage](CURRICULUM.md), [primary sources](SOURCES.md), [question-bank documentation](ASSESSMENTS.md) and [contribution instructions](CONTRIBUTING.md). No runtime execution is claimed.

## Hands-On Coverage

This course has 8 ungraded playgrounds, 8 module labs and 2 capstone labs. Every environment is two kind clusters, `west` (the environment's own cluster) and `east` (a linked cluster), both running Cilium. Tasks, launch entries and solutions follow their teaching reading. All environments are UNTESTED: they were checked statically (`astrona validate`, `bash -n`, YAML parsing) and not started.

| Module | Lab in reading order |
| --- | --- |
| 010/01 | Fix A Cluster Identity Conflict |
| 010/02 | Enable And Connect Cluster Mesh |
| 010/03 | Restrict Cross-Cluster Traffic With A Cilium Network Policy |
| 010/04 | Disconnect A Cluster From The Mesh |
| 010/capstone | Connect Two Clusters And Restrict Cross-Cluster Traffic |
| 020/01 | Create A Global Service Across Two Clusters |
| 020/02 | Prefer Local Or Remote Backends With Service Affinity |
| 020/03 | Export A Service With The Multi-Cluster Services API |
| 020/04 | Fix Timeouts For A Global Service |
| 020/capstone | Repair And Tune Cross-Cluster Service Discovery |
