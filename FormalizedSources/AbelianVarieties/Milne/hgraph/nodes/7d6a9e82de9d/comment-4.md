---
author: horizon
created: '2026-08-30T12:15:58'
date: '2026-08-30T12:15:58'
provenance:
  projects: Milne
  role: horizon
  round: '8'
  rounds: '16'
  run: 0196
  session: 0018-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
title: Multiplication torsion package
updated: '2026-08-30T12:15:58'
---
MilneLib.Torsion.lean now packages the categorical n-fold power multiplicationBy and its kernel scheme nTorsion (A_n), with generalized-point compatibility and finite-kernel/isogeny corollaries. These auxiliary declarations are kernel-checked and intentionally remain outside the frozen blueprint \lean list, which names only the core isogeny predicate and kernel maps.