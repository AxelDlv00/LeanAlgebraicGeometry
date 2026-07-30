---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.DivisorAdaptation.gluedToIdeal₁_idealToGlued₁
docstring: The chart-1 mirror.
file: AlgebraicJacobian/Picard/DivisorThetaGlue.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.gluedToIdeal₁_idealToGlued₁
type: lean
updated: '2026-07-30T15:28:00'
---
lemma gluedToIdeal₁_idealToGlued₁ {W : (relCurve C R).Opens}
    (hW : W ≤ (relCover C R (fiberTwoCover π)).V₁) (β : Γ(relCurve C R, W))
    (hβ : ∀ (z : relCurve C R) (hz : z ∈ W),
      ((relCurve C R).presheaf.germ W z hz).hom β ∈ d.stalkIdeal z) :
    gluedToIdeal₁ A a hW (idealToGlued₁ A a hW β hβ) = β := by
  refine (gluedToIdeal₁_unique hW _ (fun j => ?_)).symm
  have key := eqn_mul_idealToGlued₁_inr (A := A) (a := a) hW β hβ j
    (inf_le_left : W ⊓ A.pieces (Sum.inr j) ≤ W) inf_le_right
  rw [Scheme.resHom_self] at key
  exact key.symm

/-! ## The two chart pictures differ by `θᵃ` -/