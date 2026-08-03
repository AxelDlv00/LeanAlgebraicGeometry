---
author: sync
content_type: theorem
created: '2026-08-03T08:02:47'
decl: AlgebraicGeometry.PointwiseAchiever.pointwiseSectionVector_fibreCoefficient_eq_zero_at
docstring: 'The decoupled pointwise achiever has zero residual coefficient at the
  canonical

  residue-fibre point.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseFibreData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.pointwiseSectionVector_fibreCoefficient_eq_zero_at
type: lean
updated: '2026-08-03T08:02:47'
---
theorem pointwiseSectionVector_fibreCoefficient_eq_zero_at {gamma : ℕ}
    (hgamma : gamma ≤ g)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ))
    (z : relCurve C RZ)
    (hzg : relCurveResiduePoint C RZ z ≠
      genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField)) :
    let K := (relCurveBasePoint C RZ z).asIdeal.ResidueField
    let A := pointwiseFibrePoleDivisor_at
      C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ z
    ∃ hr : divFamPhi C K π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g)
        (windowCompare RZ K
          (pointwiseSectionVector_at C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ z)) ≠ 0,
      coeffAt hzg
          (A + Scheme.divOf (relCurve C K ↘ Spec (CommRingCat.of K))
            (Units.mk0 (divFamPhi C K π (windowM_choice π hπ g)
              (relThetaPairH1_windowM C π hπ g)
              (windowCompare RZ K
                (pointwiseSectionVector_at
                  C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ z))) hr)) = 0 := by
  dsimp only
  obtain ⟨hr, hcoeff⟩ := pointwiseSectionVector_fibreAchieverData_at
    C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ z hzg
  refine ⟨hr, hcoeff.trans ?_⟩
  simpa only [pointwiseFibrePoleDivisor_at] using
    divUniversalSeedFibreDivisor_residual_baseDivisorAt_eq_zero_at
      C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ (relCurveBasePoint C RZ z) hzg