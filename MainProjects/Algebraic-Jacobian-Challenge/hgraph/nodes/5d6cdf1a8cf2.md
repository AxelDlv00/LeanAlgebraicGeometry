---
author: sync
content_type: definition
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayToPoly
docstring: Dehomogenization descends to the degree-zero homogeneous localization.
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayToPoly
type: lean
updated: '2026-07-31T02:29:40'
---
def awayToPoly (i : J) : Away (homogeneousSubmodule J R) (X i) →ₐ[R]
    MvPolynomial {j : J // j ≠ i} R where
  toRingHom :=
    (Localization.awayLift (dehomogenize R J i).toRingHom (X i)
      (isUnit_dehomogenize_X_self R J i)).comp
      (algebraMap (Away (homogeneousSubmodule J R) (X i))
        (Localization.Away (X i : MvPolynomial J R)))
  commutes' r := by
    change (Localization.awayLift (dehomogenize R J i).toRingHom (X i)
        (isUnit_dehomogenize_X_self R J i))
        ((algebraMap R (Away (homogeneousSubmodule J R) (X i)) r).val) =
      algebraMap R (MvPolynomial {j : J // j ≠ i} R) r
    rw [HomogeneousLocalization.algebraMap_val, IsLocalization.Away.lift_eq]
    exact (dehomogenize R J i).commutes r