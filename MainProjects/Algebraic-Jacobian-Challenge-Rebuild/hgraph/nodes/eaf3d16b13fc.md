---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.restrictScalars_comp_ofId
docstring: 'An `A`-algebra map composed with the structure map of `R` is the structure
  map of

  `R''`: `j ∘ (ofId A R) = ofId A R''` as `k`-algebra maps.'
file: AlgebraicJacobian/Picard/EffectivityPieceBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.restrictScalars_comp_ofId
type: lean
updated: '2026-07-31T20:15:25'
---
lemma restrictScalars_comp_ofId (j : R →ₐ[A] R') :
    (j.restrictScalars k).comp ((Algebra.ofId A R).restrictScalars k)
      = (Algebra.ofId A R').restrictScalars k := by
  refine AlgHom.ext fun a => ?_
  change j (Algebra.ofId A R a) = Algebra.ofId A R' a
  rw [Algebra.ofId_apply, Algebra.ofId_apply]
  exact j.commutes a