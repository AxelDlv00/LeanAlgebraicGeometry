---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.mem_pieceAmitsurOpen
file: AlgebraicJacobian/Picard/EffectivityPieceClass.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.mem_pieceAmitsurOpen
type: lean
updated: '2026-07-30T15:28:06'
---
lemma mem_pieceAmitsurOpen (𝒲 : (Xq).PointedCover) (V : (XA).Opens) {z : Xcb}
    (hz : z ∈ (cgcb) ⁻¹ᵁ V) : z ∈ pieceAmitsurOpen C 𝒲 V z :=
  ⟨(amitsurProductCover C 𝒲).mem_opens z, hz⟩