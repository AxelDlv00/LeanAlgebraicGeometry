---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.Over.amitsurProductCover_le_w₂₃
file: AlgebraicJacobian/Picard/AmitsurProductCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.amitsurProductCover_le_w₂₃
type: lean
updated: '2026-07-30T15:46:01'
---
lemma amitsurProductCover_le_w₂₃ (𝒲 : (Xq).PointedCover) (z : Xcb) :
    (amitsurProductCover C 𝒲).opens z ≤ (w₂₃) ⁻¹ᵁ 𝒲.opens ((w₂₃).base z) :=
  inf_le_left.trans inf_le_left