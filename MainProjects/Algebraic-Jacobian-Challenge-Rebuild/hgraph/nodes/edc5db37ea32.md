---
author: sync
content_type: lemma
created: '2026-07-18T20:01:11'
decl: AlgebraicGeometry.thetaFieldPointedCover_opens
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDictionaryCore.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaFieldPointedCover_opens
type: lean
updated: '2026-07-18T20:01:11'
---
lemma thetaFieldPointedCover_opens (x : relCurve C K) :
    (thetaFieldPointedCover C K π).opens x
      = (thetaChartCover C K π).pieces (thetaFieldChartIndex C K π x) :=
  rfl

end Cover

/-! ## The theta presentation at the field test and its divisor -/

section Presentation

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (K : Type u) [Field K] [Algebra k K]
variable (π : C.left ⟶ P1 k) [IsFinite π]
variable (a : ℕ)