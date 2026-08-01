---
author: sync
content_type: theorem
created: '2026-07-21T16:02:06'
decl: AlgebraicGeometry.PointwiseAchiever.pointwiseSeedRDN_of_forall_germ_mem_span
docstring: Pointwise RD-N follows from germ-level local generation by the pointwise
  section.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwise.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.pointwiseSeedRDN_of_forall_germ_mem_span
type: lean
updated: '2026-08-01T09:44:12'
---
theorem pointwiseSeedRDN_of_forall_germ_mem_span
    (hgerm : ∀ (z : relCurve C RZ)
      ⦃ψ : relThetaSections C RZ π (windowM_choice π hπ g)⦄,
      ψ ∈ divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j →
        ((relCurve C RZ).presheaf.germ
            (relPinnedChart C RZ π (pointwiseSide C hπ g r₁ r₂ b₁ b₂ i j z)) z
            (pointwiseSide_mem C hπ g r₁ r₂ b₁ b₂ i j z)).hom
          (relThetaResSide (windowM_choice π hπ g)
            (pointwiseSide C hπ g r₁ r₂ b₁ b₂ i j z) le_rfl ψ)
        ∈ Ideal.span {((relCurve C RZ).presheaf.germ
            (relPinnedChart C RZ π (pointwiseSide C hπ g r₁ r₂ b₁ b₂ i j z)) z
            (pointwiseSide_mem C hπ g r₁ r₂ b₁ b₂ i j z)).hom
          (relThetaResSide (windowM_choice π hπ g)
            (pointwiseSide C hπ g r₁ r₂ b₁ b₂ i j z) le_rfl
            (pointwiseSection C hπ g r₁ r₂ b₁ b₂ i j hO hχ z))}) :
    PointwiseSeedRDN C hπ g r₁ r₂ b₁ b₂ i j hO hχ := by
  intro z
  haveI := finite_divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j
  exact notMem_support_chartColengthModule_of_forall_germ_mem_span
    (divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j)
    (pointwiseSide C hπ g r₁ r₂ b₁ b₂ i j z)
    (pointwiseSection C hπ g r₁ r₂ b₁ b₂ i j hO hχ z)
    (pointwiseSide_mem C hπ g r₁ r₂ b₁ b₂ i j z) (hgerm z)

/-! ## The fibre-generic branch -/

set_option maxHeartbeats 2400000 in
-- The fibre-generic germ theorem reconstructs the residue-field tower at the total point.
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in