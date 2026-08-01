---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.cgqPreimage_le_inr
docstring: The double piece is bounded by the second-coprojection preimage of the
  piece.
file: AlgebraicJacobian/Picard/EffectivityComparisonUnit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.cgqPreimage_le_inr
type: lean
updated: '2026-08-01T09:44:15'
---
lemma cgqPreimage_le_inr (V : (XA).Opens) :
    (cgq) ⁻¹ᵁ V ≤ (u₂) ⁻¹ᵁ ((cg) ⁻¹ᵁ V) :=
  le_of_eq (by rw [← Scheme.Hom.comp_preimage, whiskerLeft_inr_comp_cover])

/-! ## Piece trivializations -/