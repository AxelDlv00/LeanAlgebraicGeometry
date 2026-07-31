---
author: sync
content_type: lemma
created: '2026-07-28T14:44:52'
decl: AlgebraicGeometry.DivFamZarAff.picClass_toAff
file: AlgebraicJacobian/Picard/DivisorFamilyAffCompare.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivFamZarAff.picClass_toAff
type: lean
updated: '2026-07-31T20:14:48'
---
lemma DivFamZarAff.picClass_toAff {n : ℕ} (F : DivFamZar C R π n) :
    F.toAff.picClass = F.picClass := by
  induction F using Quotient.inductionOn with
  | h dp => rfl