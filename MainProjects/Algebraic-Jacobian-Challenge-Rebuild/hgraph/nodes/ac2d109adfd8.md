---
author: sync
content_type: theorem
created: '2026-07-28T14:45:07'
decl: AlgebraicGeometry.Scheme.twoChartCocycle_unitsEvInf
file: AlgebraicJacobian/Tangent/TwoChartCechPic.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.twoChartCocycle_unitsEvInf
type: lean
updated: '2026-07-30T15:28:02'
---
theorem twoChartCocycle_unitsEvInf (u : Γ(X, V false ⊓ V true)ˣ) (sel : X → Bool)
    (hmem : ∀ x, x ∈ V (sel x)) (x y : X) :
    Scheme.unitsEvInf (twoChartCocycle u sel hmem) x y = twoChartPairUnit u (sel x) (sel y) :=
  OneCocycle.ofPairs_evInf (G := X.unitsPresheaf ⋙ forget₂ CommGrpCat GrpCat)
    (U := (twoChartCover V sel hmem).opens) _ _ x y