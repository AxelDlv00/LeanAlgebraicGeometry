---
author: sync
content_type: theorem
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Adelic.mul_mem_span_range_pow
docstring: 'The `k`-span of the powers of a single element `x` is closed under

  multiplication (`xᵃ · xᵇ = xᵃ⁺ᵇ` is again a power), hence a subring — the fact

  that makes it the target of a `Subring.closure` induction.'
file: AlgebraicJacobian/RiemannRoch/Adelic/P1ChartData.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.mul_mem_span_range_pow
type: lean
updated: '2026-07-16T21:14:28'
---
theorem mul_mem_span_range_pow {k A : Type*} [CommRing k] [CommRing A] [Algebra k A]
    (x : A) {a b : A}
    (ha : a ∈ Submodule.span k (Set.range fun n : ℕ => x ^ n))
    (hb : b ∈ Submodule.span k (Set.range fun n : ℕ => x ^ n)) :
    a * b ∈ Submodule.span k (Set.range fun n : ℕ => x ^ n) := by
  have hSS : (Set.range fun n : ℕ => x ^ n) * (Set.range fun n : ℕ => x ^ n)
      ⊆ Set.range fun n : ℕ => x ^ n := by
    rw [Set.mul_subset_iff]
    rintro _ ⟨p, rfl⟩ _ ⟨q, rfl⟩
    exact ⟨p + q, by simp only [pow_add]⟩
  have hmul := Submodule.mul_mem_mul ha hb
  rw [Submodule.span_mul_span] at hmul
  exact Submodule.span_mono hSS hmul

end BaseChangeSpan

section BaseChange

variable (k : Type u) [Field k]

open ProjectiveSpace HomogeneousLocalization

/-- The `algebraSection` `k`-module structure on `Γ(V₀)` (registered locally so
the span statement uses the same module structure as `LaurentChartData.span_pow_x`
will at the assembly site). -/
noncomputable local instance instAlgebraΓV0 :
    Algebra k Γ(ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)), p1Chart k ⟨0⟩) :=
  Scheme.toModuleKSheaf.algebraSection
    (Over.mk (ℙ(ULift.{u} (Fin 2); Spec (CommRingCat.of k)) ↘ Spec (CommRingCat.of k)))
    (op (p1Chart k ⟨0⟩))

set_option maxHeartbeats 3200000 in
-- `maxHeartbeats`: constructing the affine-chart iso `basicOpenIsoAway` (its `IsIso`
-- witness threads the whole `Proj` structure-sheaf machinery) is heavy (fleet recipe).