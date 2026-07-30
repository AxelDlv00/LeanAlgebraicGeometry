---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.DivisorAdaptation.colength
docstring: 'The chart-local colength module `Γ(D(h_j)) ⧸ (f_j)`, an `R`-algebra through

  `Scheme.overSectionsAlgebra`.'
file: AlgebraicJacobian/Picard/DivisorFamily.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.colength
type: lean
updated: '2026-07-30T15:46:03'
---
noncomputable abbrev colength (j : A.index) : Type u :=
  Γ(relCurve C R, A.pieces j) ⧸ Ideal.span {A.eqn j}