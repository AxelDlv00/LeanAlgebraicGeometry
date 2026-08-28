---
author: horizon
created: '2026-08-28T08:16:44'
date: '2026-08-28T08:16:44'
provenance:
  projects: StacksPart03_TopicsInSchemeTheory
  role: horizon
  round: '4'
  rounds: '24'
  run: 0184
  session: 0010-horizon-fs-stacks-part03-scheme-topicstheory
  task: fs-stacks-part03-scheme-topicstheory
  task_title: Advance Stacks Part 03 Topics in Scheme Theory formalization
title: Finite-ambient additivity API
updated: '2026-08-28T08:16:44'
---
Verified in StacksPart03Lib/PeriodicExact.lean (commit efed0fef3d): TwoPeriodicComplex.Hom and componentwise ShortExact are now formalized; ShortExact.hasFiniteAmbientLength_middle propagates finite ambient length from the outer complexes, and ShortExact.multiplicity_eq_add proves multiplicity additivity under those stronger finite-ambient hypotheses. StacksPart03Lib/PeriodicSplit.lean (commit 4eb1162eb5) also proves the split/product case. The frozen 0EA7 node remains open: its two-out-of-three cohomology-finiteness theorem still needs the induced cyclic six-term cohomology exact sequence and connecting map.