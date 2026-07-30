---
author: sync
content_type: theorem
created: '2026-07-31T02:29:40'
decl: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayToPoly_mk
docstring: Evaluation of dehomogenization on a homogeneous fraction.
file: AlgebraicJacobian/Picard/ProjectiveSpaceAffineChartAt.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.AffineChartAtRing.awayToPoly_mk
type: lean
updated: '2026-07-31T02:29:40'
---
theorem awayToPoly_mk (i : J) (a : ℕ) (p : MvPolynomial J R)
    (hp : p ∈ homogeneousSubmodule J R (a • 1)) :
    awayToPoly R J i
        (Away.mk (homogeneousSubmodule J R) (X_mem_deg_one R J i) a p hp) =
      dehomogenize R J i p := by
  have h1 : (dehomogenize R J i).toRingHom (X i) * 1 = 1 := by
    rw [mul_one]
    exact dehomogenize_X_self R J i
  have h := Localization.awayLift_mk
    (A := MvPolynomial {j : J // j ≠ i} R)
    (dehomogenize R J i).toRingHom (X i) p 1 h1 a
  exact h.trans (by rw [one_pow, mul_one]; rfl)

@[simp]