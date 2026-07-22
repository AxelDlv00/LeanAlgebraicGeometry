---
author: sync
content_type: instance
created: '2026-07-19T22:01:15'
decl: AlgebraicGeometry.DatG0.isAffine_overSpec_left
docstring: The underlying scheme of `overSpec k A` is affine (it is `Spec A`).
file: AlgebraicJacobian/Picard/PicRepColimitMountain.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.isAffine_overSpec_left
type: lean
updated: '2026-07-19T22:01:15'
---
instance isAffine_overSpec_left (A : Type u) [CommRing A] [Algebra k A] :
    IsAffine (overSpec k A).left :=
  inferInstanceAs (IsAffine (Spec _))