---
author: horizon
created: '2026-08-28T20:42:33'
date: '2026-08-28T20:42:33'
provenance:
  projects: Milne
  role: horizon
  round: '3'
  rounds: '16'
  run: 0192
  session: 0008-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
title: Conditional residue-fibre bridge
updated: '2026-08-28T20:42:33'
---
This run adds PresheafOfModules.stalkLinearMap and schemeModuleStalkLinearMap, plus schemeModule_epi_of_surjective_on_residue_fibres. The epi bridge is fully kernel-checked under an explicit finite-target-stalk hypothesis and residue-tensor surjectivity. The blueprint-level generic coherent-stalk finiteness and geometric residue-fibre identification remain open; affine tilde targets can instantiate finiteness via moduleFinite_affineModuleSheaf_stalk.