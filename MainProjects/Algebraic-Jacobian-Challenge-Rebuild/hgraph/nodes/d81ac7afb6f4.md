---
author: sync
content_type: theorem
created: '2026-07-24T03:02:02'
decl: AlgebraicGeometry.PointwiseAchiever.exists_pointwiseBaseCutter
docstring: 'A base coordinate of the pointwise vector cuts a basic open containing
  `z` and keeps

  the vector nonzero at every residue prime of that base open.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseGenerator.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.exists_pointwiseBaseCutter
type: lean
updated: '2026-08-01T09:44:12'
---
theorem exists_pointwiseBaseCutter (z : relCurve C RZ) :
    ∃ f : RZ,
      z ∈ (relCurve C RZ).basicOpen
        (algebraMap RZ
          Γ(relCurve C RZ,
            relPinnedChart C RZ pi (pointwiseSide C hpi g r1 r2 b1 b2 i j z)) f) ∧
      ∀ q : PrimeSpectrum RZ, f ∉ q.asIdeal →
        windowCompare RZ q.asIdeal.ResidueField
          (pointwiseSectionVector C hpi g r1 r2 b1 b2 i j hO hchi z) ≠ 0 := by
  obtain ⟨f, hfp, hsurv⟩ := exists_forall_windowCompare_ne_zero
    C hpi g r1 r2 b1 b2 i j
    (pointwiseSectionVector C hpi g r1 r2 b1 b2 i j hO hchi z)
    (relCurveBasePoint C RZ z)
    (windowCompare_pointwiseSectionVector_ne_zero
      C hpi g r1 r2 b1 b2 i j hO hchi z)
  refine ⟨f, ?_, hsurv⟩
  apply mem_basicOpen_algebraMap_of_notMem_basePrime
    (pointwiseSide_mem C hpi g r1 r2 b1 b2 i j z) f
  rwa [basePrime_germ_relPinnedChart_eq_relCurveBasePoint C
    (pointwiseSide C hpi g r1 r2 b1 b2 i j z) z
    (pointwiseSide_mem C hpi g r1 r2 b1 b2 i j z)]

set_option maxHeartbeats 2400000 in
-- The dependent seed fields retain the full chart ring and selected pointwise section.
set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in