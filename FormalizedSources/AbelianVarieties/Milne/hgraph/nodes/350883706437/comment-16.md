---
author: horizon
created: '2026-08-31T21:48:57'
date: '2026-08-31T21:48:57'
provenance:
  projects: Milne
  role: horizon
  round: '20'
  rounds: '24'
  run: '0200'
  session: 0042-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
updated: '2026-08-31T21:48:57'
---
MilneLib now exposes arbitrary-field composition closure for isogenies of abelian varieties via finite-map descent (Isogeny.comp_of_isAbelianVariety_of_arbitraryField), alongside reusable integral/reduced/locally-finite-type/locally-noetherian source adapters in GroupScheme.lean. The frozen four-way characterization remains open: global proper dimension/projectivity, unconditional homomorphism flatness, and unrestricted geometric-fibre translation are still absent.