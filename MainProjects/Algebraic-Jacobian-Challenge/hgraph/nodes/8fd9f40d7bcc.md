---
author: sync
content_type: theorem
created: '2026-08-03T09:45:39'
decl: AlgebraicGeometry.Scheme.Modules.annihilator_pullback_support_eq_preimage
docstring: 'Set-theoretic form of `annihilator_pullback_support_eq_comap`: the

  schematic-support carrier of a pullback is the inverse image of the original

  schematic-support carrier.'
file: AlgebraicJacobian/Picard/SupportBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.annihilator_pullback_support_eq_preimage
type: lean
updated: '2026-08-03T09:45:39'
---
theorem annihilator_pullback_support_eq_preimage
    {X Y : Scheme.{u}} (g : Y ⟶ X) (F : X.Modules) [F.IsFinitePresentation] :
    (annihilator ((Scheme.Modules.pullback g).obj F)).support =
      (annihilator F).support.preimage g.continuous := by
  rw [annihilator_pullback_support_eq_comap, IdealSheafData.support_comap]