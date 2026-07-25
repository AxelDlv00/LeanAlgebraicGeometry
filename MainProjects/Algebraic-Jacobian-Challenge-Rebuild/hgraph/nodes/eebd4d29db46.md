---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.mem_boundedSections_unit_iff
docstring: 'Membership of a *nonzero* rational function in a bounded lattice, read
  through its

  principal divisor: `s ∈ 𝒪(A)(U)` iff `-div(s) ≤ A` at every closed point of `U`.'
file: AlgebraicJacobian/RiemannRoch/FLVQcoh.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_boundedSections_unit_iff
type: lean
updated: '2026-07-25T19:02:25'
---
private lemma mem_boundedSections_unit_iff (s : X.functionFieldˣ) (A : X.CurveDivisor)
    (U : X.Opens) :
    (s : X.functionField) ∈ Scheme.boundedSections K A U ↔
      ∀ (x : X) (hx : x ≠ genericPoint X), x ∈ U →
        - coeffAt hx (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) s) ≤ coeffAt hx A := by
  rw [Scheme.mem_boundedSections]
  refine forall_congr' (fun x => forall_congr' (fun hx => imp_congr_right (fun _ => ?_)))
  rw [Scheme.ord_val_eq K s hx, divisorBound_le_iff hx, CurveDivisor.coeffAt_neg]