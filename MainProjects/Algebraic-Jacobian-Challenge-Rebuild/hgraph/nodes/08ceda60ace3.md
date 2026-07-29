---
author: sync
content_type: instance
created: '2026-07-19T21:31:15'
decl: AlgebraicGeometry.DatG0.deltaSchemeMap_isAffineHom
docstring: 'Every δ transition map is affine (`Spec` of a field hom; both source and
  target are

  affine).'
file: AlgebraicJacobian/Picard/PicRepColimitMountain.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.deltaSchemeMap_isAffineHom
type: lean
updated: '2026-07-29T15:31:48'
---
instance deltaSchemeMap_isAffineHom {L₁ L₂ : FinSubext k K} (h : L₁.1 ≤ L₂.1) :
    IsAffineHom (deltaSchemeMap h).left :=
  isAffineHom_of_isAffine _