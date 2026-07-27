---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.h1dim_eq_of_linearEquivalence
docstring: '**`h¹` is a linear-equivalence invariant.**'
file: AlgebraicJacobian/RiemannRoch/Adelic/ClassInvariance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.h1dim_eq_of_linearEquivalence
type: lean
updated: '2026-07-27T15:50:35'
---
theorem h1dim_eq_of_linearEquivalence {D D' : X.WeilDivisor}
    (h : Scheme.WeilDivisor.LinearEquivalence D D') :
    h1dim k U₀ U₁ D = h1dim k U₀ U₁ D' := by
  obtain ⟨g, hg, hDD'⟩ := h
  have hD' : D' = D - Scheme.WeilDivisor.principal g hg := by
    rw [← hDD']; abel
  rw [hD', h1dim_eq_of_principal_shift k U₀ U₁ D hg]

/-! ### The effective-witness dictionary

A nonzero global section `f ∈ L(D)` exhibits an **effective** divisor
`D + div f ≥ 0` in the linear-equivalence class of `D`.  Conversely an effective
divisor has `ℓ ≥ 1` (the constant `1` is a section).  This pair is the
"`ℓ(D) ≥ 1 ⟺ D ~ E ≥ 0`" dictionary that the peel-an-effective-divisor form of
uniform `H¹` vanishing consumes: the sibling project's
`exists_effective_of_picClass` is the same statement over there, phrased on
`CechPic` classes rather than on the linear-equivalence relation. -/