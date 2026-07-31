---
author: sync
content_type: theorem
created: '2026-07-28T22:23:06'
decl: Submodule.exists_sub_smul_mem_of_quotient_cyclic
docstring: '**The generator of a cyclic quotient can be lifted** — so the "fixed `m`
  with

  `∀ x, ∃ r, x - r • m ∈ N`" binder of `DualNumber.free_of_cyclic_mod_eps` follows
  from `M ⧸ N`

  being cyclic, with no further input.


  The proof is `Submodule.Quotient.mk_surjective` on the generator followed by

  `Submodule.Quotient.mk_eq_zero`: pick any preimage `m` of the generator `y`, and
  for `x : M` take

  the `r` with `⟦x⟧ = r • y`; then `⟦x - r • m⟧ = ⟦x⟧ - r • ⟦m⟧ = r • y - r • y =
  0`, which is

  membership in `N`.'
file: AlgebraicJacobian/Tangent/CyclicQuotientGenerator.lean
generated: lean
lean_status: lean_ok
title: Submodule.exists_sub_smul_mem_of_quotient_cyclic
type: lean
updated: '2026-07-31T20:15:29'
---
theorem exists_sub_smul_mem_of_quotient_cyclic (N : Submodule R M)
    (h : ∃ y : M ⧸ N, ∀ z : M ⧸ N, ∃ r : R, z = r • y) :
    ∃ m : M, ∀ x : M, ∃ r : R, x - r • m ∈ N := by
  obtain ⟨y, hy⟩ := h
  obtain ⟨m, hm⟩ := Submodule.Quotient.mk_surjective N y
  refine ⟨m, fun x => ?_⟩
  obtain ⟨r, hr⟩ := hy (Submodule.Quotient.mk x)
  refine ⟨r, ?_⟩
  have hq : (Submodule.Quotient.mk (x - r • m) : M ⧸ N) = 0 := by
    rw [Submodule.Quotient.mk_sub, Submodule.Quotient.mk_smul, hm, hr, sub_self]
  exact (Submodule.Quotient.mk_eq_zero N).mp hq