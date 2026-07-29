---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.DivFamZarAff.picClass_mk
file: AlgebraicJacobian/Picard/DivisorFamilyAffZar.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivFamZarAff.picClass_mk
type: lean
updated: '2026-07-29T15:31:44'
---
lemma picClass_mk (d : (relCurve C R).LocalEquations)
    (hd : IsLocallyCertifiedAff n d) : picClass (mk d hd) = d.picClass :=
  rfl

end DivFamZarAff

/-! ## The pointwise gate over the widened predicate -/

variable {C R n}