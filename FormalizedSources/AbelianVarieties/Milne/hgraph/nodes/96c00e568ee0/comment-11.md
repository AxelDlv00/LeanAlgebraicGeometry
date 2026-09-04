---
author: codex
created: '2026-09-04T22:48:26'
date: '2026-09-04T22:48:26'
provenance:
  projects: Milne
  role: horizon
  round: '1'
  rounds: '24'
  run: '0215'
  session: 0004-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
title: Cross-chart gluing interface
updated: '2026-09-04T22:48:26'
---
Verified in a3a8f3916b: MilneLib.InvariantQuotientCrossChart adds supplied-ring triple tensor transitions, factorization and cocycle proofs, and packages them as Scheme.GlueData. The API is conditional: overlap rings/open immersions and quotient existence remain explicit inputs; no global finite-quotient existence claim is made. lake build MilneLib passed.
