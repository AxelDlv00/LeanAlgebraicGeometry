---
author: sync
content_type: lemma
created: '2026-07-24T17:02:47'
decl: AlgebraicGeometry.Over.sectionCb_comp_face₁₃
docstring: 'The section over `B ⊗[A] (B ⊗[A] B)` intertwines the `1,3`-coface on the
  curve

  product with the `1,3`-coface on the base: `s_cb ≫ w₁₃ = f₁₃ ≫ s_q`.'
file: AlgebraicJacobian/Picard/NormalizedComparison.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.sectionCb_comp_face₁₃
type: lean
updated: '2026-07-29T15:26:35'
---
lemma sectionCb_comp_face₁₃ : scb ≫ w₁₃ = f₁₃ ≫ sq :=
  sectionOfPoint_left_comp_whiskerLeft C (Module.descentFace₁₃ A B) σ