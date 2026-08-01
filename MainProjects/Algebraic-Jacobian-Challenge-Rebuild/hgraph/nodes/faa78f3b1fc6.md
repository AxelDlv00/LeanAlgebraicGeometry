---
author: sync
content_type: lemma
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.FinCoverData.thetaOvlUnit_inr_inl
file: AlgebraicJacobian/Picard/DivisorFamilyTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.FinCoverData.thetaOvlUnit_inr_inl
type: lean
updated: '2026-08-01T09:44:14'
---
lemma thetaOvlUnit_inr_inl (a : ℕ) (j₁ : Fin D.m₁) (j₀ : Fin D.m₀) :
    D.thetaOvlUnit a (Sum.inr j₁) (Sum.inl j₀)
      = ((relCurve C R).unitsRestrict
          (le_inf (inf_le_right.trans (D.pieces_inl_le j₀))
            (inf_le_left.trans (D.pieces_inr_le j₁))) (relThetaCocycle C R π a))⁻¹ := rfl

end FinCoverData

/-! ## The Θ-twisted glued colength module `W(d)^{Θᵃ}` -/

namespace DivisorAdaptation

variable {d : (relCurve C R).LocalEquations} (A : DivisorAdaptation C R π d) (a : ℕ)