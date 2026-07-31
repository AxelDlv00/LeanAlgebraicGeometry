---
author: sync
content_type: theorem
created: '2026-07-25T21:02:32'
decl: AlgebraicGeometry.DivisorAdaptation.not_exists_unique_support_piece
docstring: '**"At most one piece meets the support" is impossible once the support
  meets both

  pinned charts.** This refutes, at the level of the pieces, the shape the `tube-fibre`
  leaf

  of the certificate lane was aiming at.


  A support point `z` of `V₀ ⊓ V₁` lies in a chart-0 piece and a chart-1 piece, and
  those are

  distinct — so two distinct pieces meet the support, no matter how the cover is refined.'
file: AlgebraicJacobian/Picard/DivSchemeCertZarSep.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivisorAdaptation.not_exists_unique_support_piece
type: lean
updated: '2026-07-31T20:15:21'
---
theorem not_exists_unique_support_piece
    {z : relCurve C R} (hz : z ∈ d.supportLocus)
    (hz₀ : z ∈ (relCover C R (fiberTwoCover pi)).V₀)
    (hz₁ : z ∈ (relCover C R (fiberTwoCover pi)).V₁)
    (j₀ : A.index)
    (hother : ∀ j : A.index, j ≠ j₀ →
      ∀ y : relCurve C R, y ∈ A.pieces j → y ∉ d.supportLocus) : False :=
  A.supportLocus_disjoint_chart_inter_of_separated
    (A.forall_subsingleton_ovlColength_of_unique_support_piece j₀ hother) hz hz₀ hz₁

/-! ## The certificate -/