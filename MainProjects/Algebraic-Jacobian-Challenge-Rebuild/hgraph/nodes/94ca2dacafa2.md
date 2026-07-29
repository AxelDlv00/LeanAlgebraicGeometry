---
author: sync
content_type: theorem
created: '2026-07-28T23:10:53'
decl: DualNumber.free_of_free_baseChange_eps
docstring: '**Chart triviality from freeness of the reduction** — the form clause
  (iii-c2-aff) hands over.


  An invertible `A[ε]`-module whose base change along `ε ↦ 0` is free is itself free.
  "Free after

  restriction" is exactly "the restricted class is trivial in the Picard group"

  (`CommRing.Pic.mk_eq_one_iff_free`), so this is the module-level statement of *"an
  `ε`-kernel class

  is trivial on the chart"*.


  Composite of `Module.Invertible.quotient_smul_cyclic_of_free_baseChange` (freeness
  of the base

  change ⟹ cyclic reduction) with `free_of_quotient_eps_cyclic` (cyclic reduction
  ⟹ free), the

  latter itself the sibling-ported generator step. Note the base change is taken along

  `A[ε] ⧸ (ε)`, not along `A` — the two are isomorphic but the statement is phrased
  on the quotient

  so that no ring identification is needed here.'
file: AlgebraicJacobian/Tangent/ReductionTrivialCyclic.lean
generated: lean
lean_status: lean_ok
title: DualNumber.free_of_free_baseChange_eps
type: lean
updated: '2026-07-29T15:31:50'
---
theorem free_of_free_baseChange_eps
    (M : Type u) [AddCommGroup M] [Module (DualNumber A) M]
    [Module.Invertible (DualNumber A) M]
    (hfree : Module.Free (DualNumber A ⧸ Ideal.span {(ε : DualNumber A)})
      ((DualNumber A ⧸ Ideal.span {(ε : DualNumber A)}) ⊗[DualNumber A] M)) :
    Module.Free (DualNumber A) M :=
  free_of_quotient_eps_cyclic A M
    (Module.Invertible.quotient_smul_cyclic_of_free_baseChange
      (Ideal.span {(ε : DualNumber A)}) hfree)