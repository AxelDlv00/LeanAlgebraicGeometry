---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.normalizationCover
docstring: 'The canonical pointed cover of `Spec (B ⊗[A] B)` on which the σ-normalization
  (N2)

  of a comparison cochain is stated: the comparison cover `𝒲` of the curve `Xq` pulled

  back along the section `s_q`, intersected with the two coprojection pullbacks of
  the

  section-pullback cover `𝒩.pullback s_B` of `Spec B` carrying the trivialization
  `ρ`.

  An opaque `def`: consumers access it through the `normalizationCover_le_*` lemmas.'
file: AlgebraicJacobian/Picard/NormalizedComparison.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.normalizationCover
type: lean
updated: '2026-07-30T15:28:03'
---
noncomputable def normalizationCover (𝒩 : (XB).PointedCover) (𝒲 : (Xq).PointedCover) :
    (Sq).PointedCover :=
  𝒲.pullback (sq)
    ⊓ ((𝒩.pullback (sB)).pullback (q₁) ⊓ (𝒩.pullback (sB)).pullback (q₂))