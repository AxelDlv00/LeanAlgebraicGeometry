---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.DivFamZarAff.picClass_mk
file: AlgebraicJacobian/Picard/DivisorFamilyAffZar.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivFamZarAff.picClass_mk
type: lean
updated: '2026-07-30T15:28:05'
---
lemma picClass_mk (d : (relCurve C R).LocalEquations)
    (hd : IsLocallyCertifiedAff n d) : picClass (mk d hd) = d.picClass :=
  rfl

end DivFamZarAff

/-! ## The pointwise gate over the widened predicate -/

variable {C R n}