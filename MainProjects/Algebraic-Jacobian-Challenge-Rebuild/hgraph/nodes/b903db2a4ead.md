---
author: sync
content_type: definition
created: '2026-07-28T15:35:17'
decl: AlgebraicGeometry.Scheme.mixedValue
docstring: '**Transport of an overlap unit along the chart indices, by `subst` rather
  than by `▸`.**

  With `s`, `t` abstract and constrained propositionally, `subst` retypes the unit
  with no

  transport term; rewriting the type directly would produce the ill-typed motive described
  at

  `twoChartCoboundary_of_pairRelation`.'
file: AlgebraicJacobian/Tangent/TwoChartCechPic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.mixedValue
type: lean
updated: '2026-07-31T20:15:29'
---
noncomputable def mixedValue {s t : Bool} (hs : s = false) (ht : t = true)
    (w : Γ(X, V s ⊓ V t)ˣ) : Γ(X, V false ⊓ V true)ˣ := by
  subst hs
  subst ht
  exact w

@[simp]