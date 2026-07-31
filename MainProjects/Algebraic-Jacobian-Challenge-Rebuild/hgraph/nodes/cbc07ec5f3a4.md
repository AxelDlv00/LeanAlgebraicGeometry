---
author: sync
content_type: theorem
created: '2026-07-31T03:02:18'
decl: AlgebraicGeometry.LaurentChartPair.exists_res_add_res_inf
docstring: '**The Laurent span at the `⊓` spelling.**


  `exists_res_add_res` is stated at the pair''s own `U₀₁` field; the Mayer–Vietoris
  difference map is

  stated at `U₀ ⊓ U₁`.  The two are equal by the pair''s `inf_eq`, but not syntactically,
  and the

  sections types depend on the open — so the transport is by destructuring the pair
  and `subst`ing

  the field equation, which makes the two spellings literally the same open.'
file: AlgebraicJacobian/Curve/P1H1Vanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.LaurentChartPair.exists_res_add_res_inf
type: lean
updated: '2026-07-31T20:15:19'
---
theorem exists_res_add_res_inf (D : LaurentChartPair k) (z : Γ(P1 k, D.U₀ ⊓ D.U₁)) :
    ∃ (a : Γ(P1 k, D.U₀)) (b : Γ(P1 k, D.U₁)),
      z = (P1 k).resHom inf_le_left a + (P1 k).resHom inf_le_right b := by
  obtain ⟨U₀, U₁, U₀₁, hle₀, hle₁, hinf, ha₀, ha₁, ha₀₁, hsup, G₀, G₁, G₀₁, hr₀, hr₁⟩ := D
  subst hinf
  exact LaurentChartPair.exists_res_add_res
    ⟨U₀, U₁, U₀ ⊓ U₁, hle₀, hle₁, rfl, ha₀, ha₁, ha₀₁, hsup, G₀, G₁, G₀₁, hr₀, hr₁⟩ z