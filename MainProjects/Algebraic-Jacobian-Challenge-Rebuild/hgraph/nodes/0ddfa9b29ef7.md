---
author: sync
content_type: theorem
created: '2026-07-20T07:31:14'
decl: AlgebraicGeometry.ThetaGeneratorSeed.map_divFamPhi_divUniversalFibreSeedW
docstring: '**The fibre window is `Φ`-read by the chart reading of the fibre seed**
  (`map divFamPhi`

  form): the `Φ`-reading of the compared window `W_κ` is exactly `divUniversalFibreKM`.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignCarvePinFibreKM.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.map_divFamPhi_divUniversalFibreSeedW
type: lean
updated: '2026-07-31T20:15:22'
---
theorem map_divFamPhi_divUniversalFibreSeedW :
    Submodule.map (divFamPhi C K π (windowM_choice π hπ g)
        (relThetaPairH1_windowM C π hπ g))
        (divUniversalFibreSeedW C hπ g r₁ r₂ b₁ b₂ i j K)
      = divUniversalFibreKM C hπ g r₁ r₂ b₁ i j K := by
  rw [divUniversalFibreSeedW, Submodule.map_span, ← Set.image_comp,
    divUniversalFibreKM_eq_span C hπ g r₁ r₂ b₁ b₂ i j K]
  rfl

set_option maxHeartbeats 1000000 in
-- the fibre-seed chart reading, its germ into the function field, and the compared-window
-- span all elaborate over the base-changed towers past the default whnf budget
set_option synthInstance.maxHeartbeats 400000 in