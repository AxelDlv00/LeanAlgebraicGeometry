---
author: sync
content_type: lemma
created: '2026-07-28T22:23:02'
decl: AlgebraicGeometry.divFamZarAff.eval_apply
file: AlgebraicJacobian/Picard/DivisorFamilyAffVehicle.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divFamZarAff.eval_apply
type: lean
updated: '2026-08-01T09:44:13'
---
lemma eval_apply (U : T.left.affineOpens) (s : divFamZarAff C n T) :
    eval C n T U s = s.1 U :=
  rfl

end divFamZarAff

/-! ## The affine comparison -/

section Affine

variable (R : Type u) [CommRing R] [Algebra k R]