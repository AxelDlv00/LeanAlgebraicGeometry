---
author: sync
content_type: theorem
created: '2026-07-29T01:14:28'
decl: PiTensorProduct.permAlgHom_comp
docstring: '**The composition law, with its variance.** Reindexing along `e` then
  along `d`

  reindexes along `e * d`… on the *tuples*, which is `d * e` read as permutations
  acting on

  indices. Concretely `permAlgHom d ∘ permAlgHom e = permAlgHom (e * d)`: the assignment
  is an

  *anti*-homomorphism, and that is why `permMulSemiringAction` below inserts an inverse.


  The same bookkeeping appears on the geometric side in `SymPowColimit.permEnd`, for
  the

  mirror-image reason (mathlib''s `End` multiplication is `f * g = g ≫ f`).'
file: AlgebraicJacobian/Albanese/SymPowTensorAction.lean
generated: lean
lean_status: lean_ok
title: PiTensorProduct.permAlgHom_comp
type: lean
updated: '2026-07-29T01:14:28'
---
theorem permAlgHom_comp (d e : Equiv.Perm ι) :
    (permAlgHom R A d).comp (permAlgHom R A e) = permAlgHom R A (e * d) := by
  classical
  ext i a
  simp [Equiv.Perm.mul_apply]

@[simp]