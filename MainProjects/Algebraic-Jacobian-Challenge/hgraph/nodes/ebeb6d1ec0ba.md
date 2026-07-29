---
author: sync
content_type: theorem
created: '2026-07-30T00:50:57'
decl: AlgebraicGeometry.Scheme.Pic0Et.quasiSeparated
docstring: '**Quasi-separatedness is free too**, from separatedness. The third side
  condition of

  mathlib''s `IsProper.of_valuativeCriterion`.'
file: AlgebraicJacobian/Picard/Pic0EtStructure.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.quasiSeparated
type: lean
updated: '2026-07-30T00:50:57'
---
theorem quasiSeparated : QuasiSeparated (Pic0SchemeEt C).hom := by
  haveI : IsSeparated (Pic0SchemeEt C).hom := isSeparated C
  infer_instance