---
author: sync
content_type: theorem
created: '2026-07-27T01:33:03'
decl: MvPolynomial.substAlgHom_of_mem_zero
docstring: 'A linear substitution is the identity in degree zero: it is an `R`-algebra
  map, and the

  degree-zero part of `R[Xᵢ]` consists of the constants.'
file: AlgebraicJacobian/Curve/P1Aut.lean
generated: lean
lean_status: lean_ok
title: MvPolynomial.substAlgHom_of_mem_zero
type: lean
updated: '2026-08-01T09:44:10'
---
theorem substAlgHom_of_mem_zero (M : Matrix σ σ R) {p : MvPolynomial σ R}
    (hp : p ∈ homogeneousSubmodule σ R 0) : substAlgHom M p = p := by
  rw [homogeneousSubmodule_zero] at hp
  obtain ⟨r, rfl⟩ := Submodule.mem_one.mp hp
  exact (substAlgHom M).commutes r