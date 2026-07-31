---
author: sync
content_type: theorem
created: '2026-07-31T16:03:12'
decl: AlgebraicGeometry.polyUnit_eq_C_of_reduced
docstring: '**A unit of `A[X]` over a reduced ring is a constant unit.**


  `Polynomial.isUnit_iff_coeff_isUnit_isNilpotent` gives a unit constant term and
  nilpotent higher

  coefficients; over a reduced ring the latter are `0`, so `P = C (P.coeff 0)`.  This
  is the reduced

  replacement for `Polynomial.isUnit_iff` (which needs `IsDomain`).'
file: AlgebraicJacobian/Algebra/LaurentCoboundaryReduced.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.polyUnit_eq_C_of_reduced
type: lean
updated: '2026-07-31T20:15:16'
---
theorem polyUnit_eq_C_of_reduced [_root_.IsReduced A] {P : Polynomial A} (hP : IsUnit P) :
    ∃ c : A, IsUnit c ∧ P = Polynomial.C c := by
  rw [Polynomial.isUnit_iff_coeff_isUnit_isNilpotent] at hP
  obtain ⟨h0, hn⟩ := hP
  refine ⟨P.coeff 0, h0, ?_⟩
  ext i
  rcases eq_or_ne i 0 with rfl | hi
  · simp
  · simp only [Polynomial.coeff_C, if_neg hi]
    exact (hn i hi).eq_zero