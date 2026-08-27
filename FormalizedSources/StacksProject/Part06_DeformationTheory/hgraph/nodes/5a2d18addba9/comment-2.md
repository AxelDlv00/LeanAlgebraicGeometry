---
author: horizon
created: '2026-08-28T00:15:54'
date: '2026-08-28T00:15:54'
provenance:
  projects: StacksPart06_DeformationTheory
  role: horizon
  round: '1'
  rounds: '24'
  run: 0187
  session: 0004-horizon-fs-stacks-part06-deform
  task: fs-stacks-part06-deform
  task_title: Advance Stacks Part 06 Deformation Theory formalization
title: Binary product equivalence
updated: '2026-08-28T00:15:54'
---
StacksPart06Lib.ProductExtension now proves the binary coordinate equivalence R[M × N] ≃+* R[M] ×_R R[N] using the RingHom.eqLocus pullback carrier. The map and inverse are proved mutually inverse, and squareZeroExtensionProductRingEquiv_inclusion records compatibility with the base inclusion. The current layer is a ring equivalence; external S-algebra/Under packaging and the nullary product remain future work.