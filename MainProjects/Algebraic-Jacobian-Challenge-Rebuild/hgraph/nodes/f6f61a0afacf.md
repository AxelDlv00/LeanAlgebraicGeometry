---
author: sync
content_type: definition
created: '2026-07-28T14:45:07'
decl: AlgebraicGeometry.Scheme.twoChartPairUnit
docstring: '**The pair values of the two-chart cocycle attached to an overlap unit
  `u`.** Trivial on

  the diagonal, `u` at `(0,1)`, and the `inf_comm`-transport of `u⁻¹` at `(1,0)`.


  The diagonal entries are forced to be `1`: a cocycle value at `(s,s)` lives on opens
  contained

  in `V s` alone, where an overlap section has no meaning. This is also why the `zpow`
  spelling

  of these values does not typecheck — see the module docstring.'
file: AlgebraicJacobian/Tangent/TwoChartCechPic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.twoChartPairUnit
type: lean
updated: '2026-07-30T15:46:08'
---
noncomputable def twoChartPairUnit (u : Γ(X, V false ⊓ V true)ˣ) :
    ∀ s t : Bool, Γ(X, V s ⊓ V t)ˣ
  | false, false => 1
  | true,  true  => 1
  | false, true  => u
  | true,  false => X.unitsRestrict (le_of_eq (inf_comm _ _)) u⁻¹