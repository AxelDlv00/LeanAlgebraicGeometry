---
author: sync
content_type: theorem
created: '2026-07-31T15:12:35'
decl: AlgebraicGeometry.isNilpotent_of_map_nilradical_eq_zero
docstring: 'The kernel of `A[X] → (A ⧸ nilradical A)[X]` consists of **nilpotent**
  polynomials: a

  polynomial killed downstairs has every coefficient in the nilradical, and

  `Polynomial.isNilpotent_iff` is exactly the coefficientwise criterion.'
file: AlgebraicJacobian/Algebra/LaurentReducedReduction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isNilpotent_of_map_nilradical_eq_zero
type: lean
updated: '2026-08-01T09:44:09'
---
theorem isNilpotent_of_map_nilradical_eq_zero {A : Type u} [CommRing A] {p : Polynomial A}
    (h : Polynomial.mapRingHom (Ideal.Quotient.mk (nilradical A)) p = 0) :
    IsNilpotent p := by
  rw [Polynomial.isNilpotent_iff]
  intro i
  have hi : (Ideal.Quotient.mk (nilradical A)) (p.coeff i) = 0 := by
    have := congrArg (fun z => Polynomial.coeff z i) h
    simpa using this
  exact (Ideal.Quotient.eq_zero_iff_mem).mp hi

/-! ## The base-change map on Laurent rings, and that it commutes with both ℙ¹ charts -/

section BaseChange

variable {A B : Type u} [CommRing A] [CommRing B]