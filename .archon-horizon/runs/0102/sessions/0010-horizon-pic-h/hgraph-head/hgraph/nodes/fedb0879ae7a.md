---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.pieceAmitsurOpen_le_w
file: AlgebraicJacobian/Picard/EffectivityPieceClass.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.pieceAmitsurOpen_le_w
type: lean
updated: '2026-07-24T17:02:51'
---
lemma pieceAmitsurOpen_le_w₁₃_piece (𝒲 : (Xq).PointedCover) (V : (XA).Opens)
    (z : Xcb) :
    pieceAmitsurOpen C 𝒲 V z ≤ (w₁₃) ⁻¹ᵁ ((cgq) ⁻¹ᵁ V) :=
  (pieceAmitsurOpen_le_piece C 𝒲 V z).trans
    (coverPreimage_le_whiskerLeft C (Module.descentFace₁₃ A B) V)