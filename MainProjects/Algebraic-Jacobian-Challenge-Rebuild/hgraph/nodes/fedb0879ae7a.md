---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.pieceAmitsurOpen_le_w
file: AlgebraicJacobian/Picard/EffectivityPieceClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.pieceAmitsurOpen_le_w
type: lean
updated: '2026-07-24T03:32:06'
---
lemma pieceAmitsurOpen_le_w₁₃_piece (𝒲 : (Xq).PointedCover) (V : (XA).Opens)
    (z : Xcb) :
    pieceAmitsurOpen C 𝒲 V z ≤ (w₁₃) ⁻¹ᵁ ((cgq) ⁻¹ᵁ V) :=
  (pieceAmitsurOpen_le_piece C 𝒲 V z).trans
    (coverPreimage_le_whiskerLeft C (Module.descentFace₁₃ A B) V)