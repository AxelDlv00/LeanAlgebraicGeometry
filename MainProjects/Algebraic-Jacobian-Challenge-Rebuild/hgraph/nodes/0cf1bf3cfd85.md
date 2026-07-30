---
author: sync
content_type: definition
created: '2026-07-28T22:23:02'
decl: AlgebraicGeometry.divFamZarAff.eval
docstring: Evaluation of a section of `divFamZarAff` at an affine open.
file: AlgebraicJacobian/Picard/DivisorFamilyAffVehicle.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divFamZarAff.eval
type: lean
updated: '2026-07-30T15:27:57'
---
def eval (U : T.left.affineOpens) : divFamZarAff C n T → DivFamZarAff C Γ(T.left, U.1) n :=
  fun s => s.1 U

/-- Evaluation is projection to the component at the affine open. -/
@[simp]