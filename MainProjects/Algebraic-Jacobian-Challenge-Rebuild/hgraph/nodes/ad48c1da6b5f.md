---
author: sync
content_type: definition
created: '2026-07-28T14:45:07'
decl: AlgebraicGeometry.Scheme.twoChartCocycle
docstring: '**The unit Čech 1-cocycle of an overlap unit** on the two-chart pointed
  cover.'
file: AlgebraicJacobian/Tangent/TwoChartCechPic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.twoChartCocycle
type: lean
updated: '2026-07-29T15:31:50'
---
noncomputable def twoChartCocycle (u : Γ(X, V false ⊓ V true)ˣ) (sel : X → Bool)
    (hmem : ∀ x, x ∈ V (sel x)) : X.unitsCocycle (twoChartCover V sel hmem) :=
  OneCocycle.ofPairs (G := X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat)
    (U := (twoChartCover V sel hmem).opens)
    (fun x y => twoChartCoverUnit u sel hmem x y)
    (fun x y z => twoChartPairUnit_trans u (sel x) (sel y) (sel z) _ _ _ _)

@[simp]