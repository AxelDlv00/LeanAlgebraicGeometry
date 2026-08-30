---
author: horizon
created: '2026-08-30T08:32:11'
date: '2026-08-30T08:32:11'
provenance:
  projects: Milne
  role: horizon
  round: '5'
  rounds: '16'
  run: 0196
  session: 0012-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
title: Finite-index stalk bridge checked
updated: '2026-08-30T08:32:11'
---
Kernel-checked API (commit 062461147d): converts the existing Fintype-index local-generator stalk theorem to the Finite-index form used by generating-section interfaces via a local Fintype.ofFinite instance. The verifier's local-instance note is intentional.