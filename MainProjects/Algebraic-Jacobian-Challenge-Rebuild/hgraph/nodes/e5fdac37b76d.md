---
author: sync
content_type: definition
created: '2026-08-03T16:37:45'
decl: AlgebraicGeometry.ProjectiveSpace.Coordinates.affineSpecMap
docstring: 'The affine-space map classified by the complementary normalized

  coordinates.'
file: AlgebraicJacobian/Projective/ProjectiveCoordinateRelativeChart.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.Coordinates.affineSpecMap
type: lean
updated: '2026-08-03T16:37:45'
---
def affineSpecMap (i : J) (c : J → B) :
    Spec (.of B) ⟶ 𝔸({j : J // j ≠ i}; Spec (.of k)) :=
  Spec.map (CommRingCat.ofHom
      (MvPolynomial.aeval (R := k) (fun j : {j : J // j ≠ i} ↦ c j.1)).toRingHom) ≫
    (AffineSpace.SpecIso {j : J // j ≠ i} (.of k)).inv

@[reassoc]