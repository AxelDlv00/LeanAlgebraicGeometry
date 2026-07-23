---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicJacobian.GaloisDescent.preimage_finset_inf
docstring: 'The preimage of a finite infimum of opens under a morphism of schemes
  is the

  finite infimum of the preimages.'
file: AlgebraicJacobian/Picard/StableAffineCover.lean
generated: lean
lean_status: lean_ok
title: AlgebraicJacobian.GaloisDescent.preimage_finset_inf
type: lean
updated: '2026-07-24T03:02:12'
---
lemma preimage_finset_inf {X Y : Scheme.{u}} (h : X ⟶ Y) {ι : Type*} (s : Finset ι)
    (F : ι → Y.Opens) :
    h ⁻¹ᵁ s.inf F = s.inf fun i => h ⁻¹ᵁ F i := by
  classical
  induction s using Finset.cons_induction with
  | empty => simp
  | cons a t ha ih => rw [Finset.inf_cons, Finset.inf_cons, h.preimage_inf, ih]