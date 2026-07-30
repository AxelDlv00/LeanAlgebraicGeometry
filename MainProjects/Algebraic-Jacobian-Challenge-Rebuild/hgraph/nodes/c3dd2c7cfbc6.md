---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.stepGCover_le_w₁₃
file: AlgebraicJacobian/Picard/CoherentWitnessExists.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.stepGCover_le_w₁₃
type: lean
updated: '2026-07-30T15:46:01'
---
private lemma stepGCover_le_w₁₃ (𝒲 : (Sq).PointedCover) (𝒜 : (XB).PointedCover)
    (x : Xcb) :
    (stepGCover C 𝒲 𝒜).opens x
      ≤ (w₁₃) ⁻¹ᵁ (Over.comparisonCover C 𝒲 𝒜).opens ((w₁₃).base x) :=
  inf_le_right.trans inf_le_right