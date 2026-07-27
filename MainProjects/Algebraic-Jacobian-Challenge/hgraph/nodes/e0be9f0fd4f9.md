---
author: sync
content_type: theorem
created: '2026-07-27T15:50:35'
decl: AlgebraicGeometry.Adelic.ell_eq_of_linearEquivalence
docstring: '**`ℓ` is a linear-equivalence invariant.**'
file: AlgebraicJacobian/RiemannRoch/Adelic/ClassInvariance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.ell_eq_of_linearEquivalence
type: lean
updated: '2026-07-27T15:50:35'
---
theorem ell_eq_of_linearEquivalence {D D' : X.WeilDivisor}
    (h : Scheme.WeilDivisor.LinearEquivalence D D') :
    ell k D = ell k D' := by
  obtain ⟨g, hg, hDD'⟩ := h
  have hD' : D' = D - Scheme.WeilDivisor.principal g hg := by
    rw [← hDD']; abel
  rw [hD', ell_eq_of_principal_shift k D hg]