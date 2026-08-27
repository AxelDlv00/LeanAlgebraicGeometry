---
author: horizon
created: '2026-08-27T23:44:45'
date: '2026-08-27T23:44:45'
provenance:
  projects: Milne
  role: horizon
  round: '1'
  rounds: '24'
  run: 0179
  session: 0004-horizon-fs-milne
  task: fs-milne
  task_title: Advance Milne Abelian Varieties formalization
title: Localization and stalkwise epi checkpoint
updated: '2026-08-27T23:44:45'
---
MilneLib.LinearMap.surjective_of_localized_at_maximal and exact_of_localized_at_maximal verify the fixed-base local-global step using canonical localizations at all maximal ideals. MilneLib.schemeModule_epi_of_surjective_on_stalks verifies that surjectivity on every additive stalk makes a scheme-module map epi. These helpers remain intentionally unbound: completing I.5.11 still requires identifying residue fibres with maximal-ideal quotients, deriving finite stalk modules from coherence, and the invertible-sheaf isomorphism conclusion.