---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Grassmannian.valuativeUniqueness_toSpecZ
docstring: 'The **uniqueness part** of the valuative criterion for `toSpecZ` is free
  from separatedness:

  `IsSeparated.valuativeCriterion` says every separated morphism satisfies the uniqueness
  part

  (two `Spec R`-lifts agreeing on the generic point `Spec K` coincide). Project-local:
  the

  `Uniqueness` half of `ValuativeCriterion (toSpecZ d r)`.'
file: AlgebraicJacobian/Picard/GrassmannianCells.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.valuativeUniqueness_toSpecZ
type: lean
updated: '2026-07-16T21:14:27'
---
theorem valuativeUniqueness_toSpecZ (d r : ℕ) :
    ValuativeCriterion.Uniqueness (toSpecZ d r) := by
  haveI : IsSeparated (toSpecZ d r) := isSeparatedToSpecZ d r
  exact IsSeparated.valuativeCriterion (toSpecZ d r)