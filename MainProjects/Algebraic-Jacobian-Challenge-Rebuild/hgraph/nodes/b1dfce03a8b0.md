---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: Module.Invertible.bijective_toSpanSingleton_of_span_eq_top
docstring: 'A cyclic invertible module is free on its generator: the section `r ↦
  r • m₀` is

  bijective.  Injectivity: if `r • m₀ = 0` then `r` kills all of `N = R ∙ m₀`, so
  `r`

  kills every element of `Dual N ⊗ N`, whose contraction hits `1`.'
file: AlgebraicJacobian/Picard/EffectivityInvertibleAvoid.lean
generated: lean
lean_status: lean_ok
title: Module.Invertible.bijective_toSpanSingleton_of_span_eq_top
type: lean
updated: '2026-07-29T15:31:46'
---
theorem bijective_toSpanSingleton_of_span_eq_top (N : Type u) [AddCommGroup N]
    [Module R N] [Module.Invertible R N] (m₀ : N)
    (hspan : Submodule.span R {m₀} = ⊤) :
    Function.Bijective (LinearMap.toSpanSingleton R N m₀) := by
  constructor
  · -- injectivity
    rw [injective_iff_map_eq_zero]
    intro r hr
    rw [LinearMap.toSpanSingleton_apply] at hr
    -- `r` kills every element of `N`
    have hker : ∀ n : N, r • n = 0 := by
      intro n
      obtain ⟨c, rfl⟩ := Submodule.mem_span_singleton.mp
        (hspan ▸ Submodule.mem_top : n ∈ Submodule.span R {m₀})
      rw [smul_comm, hr, smul_zero]
    -- hence `r • idₙ = 0`, so `r` kills `Dual N ⊗ N`
    have hzero : (r • LinearMap.id : N →ₗ[R] N) = 0 :=
      LinearMap.ext fun n => hker n
    have hAll : ∀ w : Module.Dual R N ⊗[R] N,
        r • w = LinearMap.lTensor (Module.Dual R N)
          (r • LinearMap.id : N →ₗ[R] N) w := by
      intro w
      induction w with
      | zero => simp
      | tmul f n => simp
      | add x y hx hy => simp only [smul_add, map_add, hx, hy]
    obtain ⟨w, hw⟩ := (Module.Invertible.bijective (R := R) (M := N)).surjective 1
    have hsmul : r • w = 0 := by
      rw [hAll w, hzero, LinearMap.lTensor_zero, LinearMap.zero_apply]
    calc r = r * contractLeft R N w := by rw [hw, mul_one]
      _ = contractLeft R N (r • w) := by rw [map_smul, smul_eq_mul]
      _ = 0 := by rw [hsmul, map_zero]
  · -- surjectivity
    rw [← LinearMap.range_eq_top, LinearMap.range_toSpanSingleton, hspan]