---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.coeffAt_add_divOf_nonneg
docstring: 'Under `T ⊆ H⁰(𝒪(A))`, the shifted divisor `A + div f` of a nonzero `f
  ∈ T` is

  effective at every closed point.'
file: AlgebraicJacobian/RiemannRoch/BaseDivisor.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.coeffAt_add_divOf_nonneg
type: lean
updated: '2026-07-30T15:27:58'
---
lemma Scheme.coeffAt_add_divOf_nonneg {T : Submodule K X.functionField}
    {A : X.CurveDivisor} (hTA : T ≤ divisorSections K A ⊤) {f : X.functionField}
    (hfT : f ∈ T) (hf : f ≠ 0) {x : X} (hx : x ≠ genericPoint X) :
    0 ≤ coeffAt hx
      (A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) (Units.mk0 f hf)) := by
  have hmem := hTA hfT
  rw [mem_divisorSections_top_iff K hf] at hmem
  have h := CurveDivisor.le_iff_coeffAt.mp hmem x hx
  rwa [CurveDivisor.coeffAt_zero] at h