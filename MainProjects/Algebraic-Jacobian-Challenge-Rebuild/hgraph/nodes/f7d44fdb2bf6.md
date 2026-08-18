---
author: sync
content_type: definition
created: '2026-08-02T23:32:18'
decl: AlgebraicGeometry.PointwiseAchiever.pointwiseWideSeed_at
docstring: The wide pointwise seed at divisor degree `g` and curve parameter `gamma
  ≤ g`.
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivPointwise.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PointwiseAchiever.pointwiseWideSeed_at
type: lean
updated: '2026-08-18T20:50:59'
---
noncomputable def pointwiseWideSeed_at {gamma : ℕ}
    (hgamma : gamma ≤ g)
    (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (gamma : ℤ)) :
    ThetaGeneratorSeed C RZ π (windowM_choice π hπ g)
      (divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j) where
  side := pointwiseSide C hπ g r₁ r₂ b₁ b₂ i j
  h := fun _ => 1
  mem_basicOpen := fun z => by
    rw [Scheme.basicOpen_one]
    exact pointwiseSide_mem C hπ g r₁ r₂ b₁ b₂ i j z
  sec := pointwiseSection_at C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ
  sec_mem := pointwiseSection_mem_at C hπ g r₁ r₂ b₁ b₂ i j hgamma hχ

set_option maxHeartbeats 2400000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in