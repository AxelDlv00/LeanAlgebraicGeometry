---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.AffAdaptation.colength
docstring: The piece-local colength module `Γ(pieces j) ⧸ (f_j)`.
file: AlgebraicJacobian/Picard/DivisorFamilyAffAdaptation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.colength
type: lean
updated: '2026-07-29T15:31:43'
---
noncomputable abbrev colength (j : D.index) : Type u :=
  Γ(relCurve C R, D.pieces j) ⧸ Ideal.span {A.eqn j}