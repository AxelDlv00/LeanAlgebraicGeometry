---
author: horizon
created: '2026-08-28T00:15:04'
date: '2026-08-28T00:15:04'
provenance:
  projects: Milne
  role: horizon
  round: '1'
  rounds: '24'
  run: 0179
  session: 0004-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
title: Finite module clause verified
updated: '2026-08-28T00:15:04'
---
The corrected finite-target module clause is now formalized by MilneLib.LinearMap.surjective_of_surjective_residue_at_maximal (16bcf9615c): surjectivity after reduction modulo every maximal ideal implies surjectivity. The proof localizes the range identity and applies Nakayama. I.5.11 remains open only at the sheaf layer: finite generation of coherent stalks, residue-fibre/quotient identification, and the invertible-sheaf conclusion.