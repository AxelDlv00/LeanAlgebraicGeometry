---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.comparisonCover
docstring: 'The canonical common refinement of the pulled-back covers carrying the
  comparison

  cochain on the curve product `X_{B ⊗ B}`: the witness cover `𝒲` pulled back along
  the

  projection `p₂`, intersected with the upstairs cover `𝒜` pulled back along the two

  whiskered coprojections `u₁, u₂`.'
file: AlgebraicJacobian/Picard/CoherentWitnessCochains.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.comparisonCover
type: lean
updated: '2026-07-30T15:28:06'
---
noncomputable def comparisonCover (𝒲 : (Sq).PointedCover)
    (𝒜 : (XB).PointedCover) : (Xq).PointedCover :=
  (𝒲.pullback (p₂)) ⊓ (𝒜.pullback (u₁) ⊓ 𝒜.pullback (u₂))