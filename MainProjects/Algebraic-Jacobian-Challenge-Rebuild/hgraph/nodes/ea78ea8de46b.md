---
author: sync
content_type: theorem
created: '2026-07-21T19:02:02'
decl: AlgebraicGeometry.PointwiseAchiever.divUniversalFibreKM_le_pointwiseFibrePoleDivisor
docstring: The universal fibre window lies under the pointwise achiever's pole divisor.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwiseFibreData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.divUniversalFibreKM_le_pointwiseFibrePoleDivisor
type: lean
updated: '2026-07-30T15:46:03'
---
theorem divUniversalFibreKM_le_pointwiseFibrePoleDivisor
    (z : relCurve C RZ) :
    divUniversalFibreKM C hπ g r₁ r₂ b₁ i j
        (relCurveBasePoint C RZ z).asIdeal.ResidueField ≤
      Scheme.divisorSections (relCurveBasePoint C RZ z).asIdeal.ResidueField
        (pointwiseFibrePoleDivisor C hπ g r₁ r₂ b₁ b₂ i j hO hχ z) ⊤ :=
  le_of_eq (divUniversalSeedFibreDivisor_spec
    C hπ g r₁ r₂ b₁ b₂ i j hO hχ (relCurveBasePoint C RZ z)).2.2.1

set_option maxHeartbeats 4800000 in
-- Transporting the chosen achiever payload to the pointwise vector is dependent on `z`.
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in