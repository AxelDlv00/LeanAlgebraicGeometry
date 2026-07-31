---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.P1.fromSpecChart_base_genericPoint
docstring: 'If the evaluation `k[t] → A`, `t ↦ a` kills no nonzero polynomial, then
  the generic

  point of `Spec A` (for `A` a domain) is sent by `fromSpecChart k ρ 0 a` to the generic
  point

  of `ℙ¹`.'
file: AlgebraicJacobian/Curve/P1Points.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.fromSpecChart_base_genericPoint
type: lean
updated: '2026-07-31T20:15:19'
---
theorem fromSpecChart_base_genericPoint [IsDomain A] (a : A)
    (hinj : ∀ P : Polynomial k, P ≠ 0 → Polynomial.eval₂ ρ.hom a P ≠ 0) :
    (fromSpecChart k ρ 0 a).base (genericPoint (Spec A)) = genericPoint (P1 k) := by
  have hker : Function.Injective (chartEval k ρ 0 a).hom := by
    rw [injective_iff_map_eq_zero]
    intro z hz
    obtain ⟨p, rfl⟩ := polyToAway_surjective k fin_zero_ne_one z
    rw [chartEval_apply, awayToPoly_polyToAway_apply k fin_zero_ne_one] at hz
    by_contra hzne
    exact hinj p (fun h0 => hzne (by rw [h0, map_zero])) hz
  have h1 : (Spec.map (chartEval k ρ 0 a)).base (genericPoint (Spec A)) =
      genericPoint (Spec (CommRingCat.of (Away 𝒜 (X (0 : Fin 2))))) := by
    rw [genericPoint_eq_bot_of_affine, genericPoint_eq_bot_of_affine]
    refine PrimeSpectrum.ext ?_
    exact Ideal.comap_bot_of_injective _ hker
  rw [fromSpecChart, Scheme.Hom.comp_apply, h1, chartι_base_genericPoint]