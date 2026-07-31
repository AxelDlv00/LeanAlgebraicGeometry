---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Scheme.LocalEquations.pullbackEqn_res
docstring: 'Restriction of a pulled-back equation to a sub-open `W ≤ (E.cover.pullback
  f).opens y`

  is the `f`-pullback of `E.eqn (f.base y)` directly to `W`. This is the ring-level
  naturality

  of `appLE` with restriction (`Scheme.Hom.appLE_map`), packaged for the ratio computation.'
file: AlgebraicJacobian/Picard/LocalEquationsPullback.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.LocalEquations.pullbackEqn_res
type: lean
updated: '2026-07-31T20:14:49'
---
lemma pullbackEqn_res (f : Y ⟶ X) (E : X.LocalEquations) (y : Y) {W : Y.Opens}
    (h : W ≤ (E.cover.pullback f).opens y) :
    (Y.presheaf.map (homOfLE h).op).hom (pullbackEqn f E y)
      = (f.appLE (E.cover.opens (f.base y)) W (h.trans le_rfl)).hom (E.eqn (f.base y)) := by
  rw [pullbackEqn, ← CommRingCat.comp_apply, Scheme.Hom.appLE_map]

/-! ## The ratio equation -/