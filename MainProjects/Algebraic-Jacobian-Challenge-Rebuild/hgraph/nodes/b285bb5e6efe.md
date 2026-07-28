---
author: sync
content_type: theorem
created: '2026-07-28T15:00:45'
decl: AlgebraicGeometry.Scheme.twoChartCob_spec
docstring: '**The coboundary relation for `twoChartCob`**: if `u = ρ₀(v₁) · ρ₁(v₂)`
  then the

  `0`-cochain `twoChartCob v₁ v₂` conjugates the pair values of `u` to `1`. All four
  `Bool`

  cases; the two off-diagonal ones are where the hypothesis is spent.'
file: AlgebraicJacobian/Tangent/TwoChartCechPic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.twoChartCob_spec
type: lean
updated: '2026-07-28T15:00:45'
---
theorem twoChartCob_spec (v₁ : Γ(X, V false)ˣ) (v₂ : Γ(X, V true)ˣ)
    (u : Γ(X, V false ⊓ V true)ˣ)
    (hv : Units.map (X.resHom (inf_le_left : V false ⊓ V true ≤ V false)).toMonoidHom v₁
        * Units.map (X.resHom (inf_le_right : V false ⊓ V true ≤ V true)).toMonoidHom v₂ = u)
    (s t : Bool) (T : X.Opens) (h₀ : T ≤ V s ⊓ V t) (ha : T ≤ V s) (hb : T ≤ V t) :
    X.unitsRestrict ha (twoChartCob v₁ v₂ s) * X.unitsRestrict h₀ (twoChartPairUnit u s t)
      = X.unitsRestrict hb (twoChartCob v₁ v₂ t) := by
  subst hv
  cases s <;> cases t <;>
    (simp only [twoChartCob, twoChartPairUnit, map_one, mul_one, map_mul, map_inv,
       unitsMap_resHom, unitsRestrict_unitsRestrict]
     try first | rfl | (rw [inv_mul_cancel_left]) | group)