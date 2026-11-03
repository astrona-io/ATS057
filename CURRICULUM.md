# Curriculum Coverage

Exam: Cilium Certified Associate (CCA). Domain: Cluster Mesh (10%).

The [official objectives](https://training.linuxfoundation.org/certification/cilium-certified-associate-cca/) were checked on 2026-10-11. Teaching structure is independently authored and does not add official requirements.

| Section | Official objective | Modules |
| --- | --- | --- |
| 010 | Understand the Benefits of Cluster Mesh for Multi-cluster Connectivity | 4 |
| 020 | Achieve Service Discovery and Load Balancing Across Clusters with Cluster Mesh | 4 |

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

AUTHORING.yaml records measurable goals and adaptation sources. Every objective retains its section ID. All technical readings remain draft. Each section has a capstone lab and a quiz (`quiz.yaml`), and `sections/final-domain-quiz.yaml` covers the whole domain. The older banks under `assessments/` are not registered in the manifest.

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
