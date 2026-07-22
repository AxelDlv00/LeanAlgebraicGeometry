---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.exists_isUnit_of_span_singleton_eq
docstring: '**The regular-generators mini-lemma** (worksheet D3): if `span {a} = span
  {b}` and `a` is a

  nonzerodivisor, then `a` and `b` differ by a unit, `a = u * b`.  From `a ∈ span
  {b}` and

  `b ∈ span {a}` we get `a = c * b`, `b = d * a`, hence `(1 - c * d) * a = 0`; regularity
  of `a`

  forces `c * d = 1`, so `c` is a unit.'
file: AlgebraicJacobian/Curve/DiagonalEquations.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.exists_isUnit_of_span_singleton_eq
type: lean
updated: '2026-07-16T21:33:27'
---
theorem exists_isUnit_of_span_singleton_eq {R : Type*} [CommRing R] {a b : R}
    (hab : Ideal.span {a} = Ideal.span {b}) (ha : a ∈ R⁰) :
    ∃ u : Rˣ, a = (u : R) * b := by
  have haS : a ∈ Ideal.span {b} := hab ▸ Ideal.subset_span rfl
  have hbS : b ∈ Ideal.span {a} := hab ▸ Ideal.subset_span rfl
  obtain ⟨c, hc⟩ := Ideal.mem_span_singleton'.mp haS
  obtain ⟨d, hd⟩ := Ideal.mem_span_singleton'.mp hbS
  -- `(1 - c * d) * a = 0`, so `c * d = 1` by regularity of `a`
  have h0 : (1 - c * d) * a = 0 := by rw [sub_mul, one_mul, mul_assoc, hd, hc, sub_self]
  have h1 : 1 - c * d = 0 :=
    (mul_left_mem_nonZeroDivisors_eq_zero_iff ha).mp (by rw [mul_comm]; exact h0)
  have hcd : c * d = 1 := (sub_eq_zero.mp h1).symm
  exact ⟨⟨c, d, hcd, by rw [mul_comm]; exact hcd⟩, by rw [← hc]⟩

variable {k : Type u} [Field k]