---
author: sync
content_type: theorem
created: '2026-07-28T17:25:29'
decl: AlgebraicGeometry.Scheme.unitsRestrict_mixedValue
docstring: '**Restriction absorbs `mixedValue`.** Both sides are units on the *same*
  open `W`, so the

  statement needs no transport; `subst` then makes it `rfl`. This is the lemma that
  lets the

  chart-index bookkeeping happen inside `Prop` only.'
file: AlgebraicJacobian/Tangent/TwoChartNormalize.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.unitsRestrict_mixedValue
type: lean
updated: '2026-07-30T15:28:06'
---
theorem unitsRestrict_mixedValue {s t : Bool} (hs : s = false) (ht : t = true)
    (w : Γ(X, V s ⊓ V t)ˣ) {W : X.Opens} (hst : W ≤ V s ⊓ V t) (hft : W ≤ V false ⊓ V true) :
    X.unitsRestrict hft (mixedValue hs ht w) = X.unitsRestrict hst w := by
  subst hs
  subst ht
  rfl