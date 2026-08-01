---
author: sync
content_type: theorem
created: '2026-07-21T19:02:02'
decl: AlgebraicGeometry.PointwiseAchiever.pointwiseSectionVector_fibreAchieverData
docstring: 'The compared pointwise vector is the fibre achiever, including its nonvanishing
  and

  coefficient equality at the canonical residue point.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseFibreData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.pointwiseSectionVector_fibreAchieverData
type: lean
updated: '2026-08-01T09:44:12'
---
theorem pointwiseSectionVector_fibreAchieverData
    (z : relCurve C RZ)
    (hzg : relCurveResiduePoint C RZ z ≠
      genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField)) :
    let K := (relCurveBasePoint C RZ z).asIdeal.ResidueField
    let A := pointwiseFibrePoleDivisor C hπ g r₁ r₂ b₁ b₂ i j hO hχ z
    ∃ hr : divFamPhi C K π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g)
        (windowCompare RZ K
          (pointwiseSectionVector C hπ g r₁ r₂ b₁ b₂ i j hO hχ z)) ≠ 0,
      coeffAt hzg
          (A + Scheme.divOf (relCurve C K ↘ Spec (CommRingCat.of K))
            (Units.mk0 (divFamPhi C K π (windowM_choice π hπ g)
              (relThetaPairH1_windowM C π hπ g)
              (windowCompare RZ K
                (pointwiseSectionVector C hπ g r₁ r₂ b₁ b₂ i j hO hχ z))) hr))
        = (Scheme.baseDivisorAt K (divUniversalFibreKM C hπ g r₁ r₂ b₁ i j K) A
          ⟨relCurveResiduePoint C RZ z, hzg⟩ : ℤ) := by
  dsimp only
  obtain ⟨hsec_ne, hach⟩ :=
    (pointwiseAchiever C hπ g r₁ r₂ b₁ b₂ i j hO hχ z hzg).choose_spec.2.2.2
  have hsec_eq := pointwiseSectionVector_achieves
    C hπ g r₁ r₂ b₁ b₂ i j hO hχ z hzg
  rw [hsec_eq]
  exact ⟨hsec_ne, hach⟩

set_option maxHeartbeats 4800000 in
-- The pointwise residue-field tower is reconstructed in both input theorems.
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in