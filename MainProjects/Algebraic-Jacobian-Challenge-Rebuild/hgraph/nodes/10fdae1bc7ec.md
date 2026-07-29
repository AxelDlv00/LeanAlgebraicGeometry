---
author: sync
content_type: lemma
created: '2026-07-28T22:23:02'
decl: AlgebraicGeometry.divFamZarAff.compat
docstring: The compatibility of a section of `divFamZarAff` along an inclusion of
  affine opens.
file: AlgebraicJacobian/Picard/DivisorFamilyAffVehicle.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.divFamZarAff.compat
type: lean
updated: '2026-07-29T15:26:09'
---
lemma compat (s : divFamZarAff C n T) (U V : T.left.affineOpens) (h : U.1 ≤ V.1) :
    DivFamZarAff.mapAlgHom (Over.resAlgHom T h) (s.1 V) = s.1 U :=
  s.2 U V h

/-- Two sections of `divFamZarAff` agreeing at every affine open are equal. -/
@[ext]