---
author: sync
content_type: theorem
created: '2026-08-02T23:32:18'
decl: AlgebraicGeometry.PointwiseAchiever.germ_relThetaResSide_mem_span_pointwiseSection_of_residuePoint_generic_at
docstring: 'Fibre-generic germ generation for the pointwise section at curve parameter

  `gamma ≤ g`.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignPointwiseGeneric.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.germ_relThetaResSide_mem_span_pointwiseSection_of_residuePoint_generic_at
type: lean
updated: '2026-08-18T20:50:59'
---
theorem germ_relThetaResSide_mem_span_pointwiseSection_of_residuePoint_generic_at
    {gamma : ℕ} (hgamma : gamma ≤ g)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (z : relCurve C RZ) (b : Bool)
    (hz : z ∈ relPinnedChart C RZ π b)
    (hzg : relCurveResiduePoint C RZ z =
      genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField))
    ⦃ψ : relThetaSections C RZ π (windowM_choice π hπ g)⦄
    (_hψ : ψ ∈ divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j) :
    ((relCurve C RZ).presheaf.germ (relPinnedChart C RZ π b) z hz).hom
        (relThetaResSide (windowM_choice π hπ g) b le_rfl ψ)
      ∈ Ideal.span {
        ((relCurve C RZ).presheaf.germ (relPinnedChart C RZ π b) z hz).hom
          (relThetaResSide (windowM_choice π hπ g) b le_rfl
            (pointwiseSection_at C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ z))} := by
  have hu : IsUnit
      (((relCurve C RZ).presheaf.germ (relPinnedChart C RZ π b) z hz).hom
        (relThetaResSide (windowM_choice π hπ g) b le_rfl
          (pointwiseSection_at C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ z))) := by
    exact isUnit_total_germ_of_residuePoint_generic C RZ π
      (windowM_choice π hπ g) (relThetaPairH1_windowM C π hπ g) z b hz
      (windowCompare_pointwiseSectionVector_ne_zero_at
        C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ z) hzg
  rw [Ideal.span_singleton_eq_top.mpr hu]
  exact Submodule.mem_top