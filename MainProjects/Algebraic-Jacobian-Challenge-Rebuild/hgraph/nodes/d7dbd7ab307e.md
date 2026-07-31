---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.Over.face₁₃_comp_inr
docstring: 'The composite `w₁₃ ≫ u₂` is the third insertion, by the simplicial coincidence

  `Over.whiskerLeft_face₁₃_inr`.'
file: AlgebraicJacobian/Picard/AmitsurProductCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.face₁₃_comp_inr
type: lean
updated: '2026-07-31T20:15:19'
---
lemma face₁₃_comp_inr : w₁₃ ≫ (u₂) = v₃ :=
  (Over.whiskerLeft_face₁₃_inr (k := k) (A := A) (B := B) C).trans
    (face₂₃_comp_inr C)

/-! ## The insertion bounds on the pairwise overlap

Each is a single application of the abstract `Scheme.Hom.le_preimage_inf_of_comp`: no
composite spelling and no preimage conversion on the concrete towers. -/