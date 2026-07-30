---
author: sync
content_type: lemma
created: '2026-07-29T06:43:23'
decl: AlgebraicGeometry.mem_boundedSections_unit_iff
docstring: 'Membership of a *nonzero* rational function `s` in a bounded lattice,
  read through its

  principal divisor: `s ∈ 𝒪(A)(U)` iff `-div(s) ≤ A` at every point of `U`.'
file: AlgebraicJacobian/RiemannRoch/Ledger/FiberLattice.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.mem_boundedSections_unit_iff
type: lean
updated: '2026-07-30T16:52:58'
---
private lemma mem_boundedSections_unit_iff (s : Y.functionFieldˣ) (A : Y.CurveDivisor)
    (U : Y.Opens) :
    (s : Y.functionField) ∈ Scheme.boundedSections K A U ↔
      ∀ (x : Y) (hx : x ≠ genericPoint Y), x ∈ U →
        - coeffAt hx (Scheme.divOf (Y ↘ Spec (CommRingCat.of K)) s) ≤ coeffAt hx A := by
  rw [Scheme.mem_boundedSections]
  refine forall_congr' (fun x => forall_congr' (fun hx => imp_congr_right (fun _ => ?_)))
  rw [Scheme.ord_val_eq K s hx, divisorBound_le_iff hx, CurveDivisor.coeffAt_neg]