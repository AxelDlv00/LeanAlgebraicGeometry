---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.Over.amitsurPairOpen_le_face₁₂
file: AlgebraicJacobian/Picard/AmitsurProductCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.amitsurPairOpen_le_face₁₂
type: lean
updated: '2026-07-24T17:02:46'
---
lemma amitsurPairOpen_le_face₁₂ (𝒲 : (Xq).PointedCover) (z z' : Xcb) :
    amitsurPairOpen C 𝒲 z z'
      ≤ (w₁₂) ⁻¹ᵁ (𝒲.opens ((w₁₂).base z) ⊓ 𝒲.opens ((w₁₂).base z')) :=
  (w₁₂).le_preimage_inf
    (inf_le_left.trans (amitsurProductCover_le_w₁₂ C 𝒲 z))
    (inf_le_right.trans (amitsurProductCover_le_w₁₂ C 𝒲 z'))