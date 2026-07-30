---
author: sync
content_type: definition
created: '2026-07-30T13:03:22'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartRing.awayAlgEquiv
docstring: 'The standard projective chart ring is the polynomial ring on the remaining

  homogeneous coordinates.'
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartRing.awayAlgEquiv
type: lean
updated: '2026-07-30T13:03:22'
---
def awayAlgEquiv :
    Away (homogeneousSubmodule (Option n) R) (X none) ≃ₐ[R] MvPolynomial n R :=
  AlgEquiv.ofAlgHom (awayToPoly R n) (polyToAway R n)
    (awayToPoly_comp_polyToAway R n) (polyToAway_comp_awayToPoly R n)

@[simp]