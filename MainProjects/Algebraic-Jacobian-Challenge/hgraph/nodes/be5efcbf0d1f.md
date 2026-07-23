---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.BaseChangeChartTower.brickR''
docstring: 'The affine base-change brick `e_{R''''}` over `Spec R''''` (an isomorphism
  of `Spec R''''`-modules),

  for the composite base map `ψ ≫ j : R → R''''`. Project-local.'
file: AlgebraicJacobian/Cohomology/FlatBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BaseChangeChartTower.brickR''
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def brickR'' (M : ModuleCat.{u} T.A) :
    (Scheme.Modules.pullback (Spec.map (T.ψ ≫ T.j))).obj
        ((Scheme.Modules.pushforward (Spec.map T.φ)).obj (tilde M)) ≅
      (Scheme.Modules.pushforward (Spec.map T.σ'')).obj
        ((Scheme.Modules.pullback (Spec.map T.ρ'')).obj (tilde M)) :=
  affinePushforwardPullbackBaseChange T.φ (T.ψ ≫ T.j) T.ρ'' T.σ'' T.h'' M