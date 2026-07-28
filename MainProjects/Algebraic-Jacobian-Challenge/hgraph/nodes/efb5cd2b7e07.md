---
author: sync
content_type: theorem
created: '2026-07-28T15:48:28'
decl: AlgebraicGeometry.Adelic.chartAlg_eq_top_of_isField
docstring: '**If `Γ(U, 𝒪(0))` is a field, it is the whole function field.**  On a
  nonempty affine

  chart, `K(X) = Frac Γ(X, U)` (`chartRing_isFractionRing`), so every `f : K(X)` is
  `a/b` with

  `a, b ∈ Γ(X, U) ⊆ chartAlg`.  Inside a field, `b⁻¹` is available, so `f = a·b⁻¹`
  lies in

  `chartAlg` too.'
file: AlgebraicJacobian/RiemannRoch/Adelic/ChartFinitenessRefuted.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.chartAlg_eq_top_of_isField
type: lean
updated: '2026-07-28T15:48:28'
---
theorem chartAlg_eq_top_of_isField {U : X.Opens} (hU : IsAffineOpen U) [Nonempty U]
    (hfield : IsField (chartAlg k U)) : chartAlg k U = ⊤ := by
  haveI hfr : IsFractionRing Γ(X, U) X.functionField := chartRing_isFractionRing hU
  refine Algebra.eq_top_iff.mpr fun f => ?_
  obtain ⟨a, b, hb, hab⟩ := IsFractionRing.div_surjective (A := Γ(X, U)) f
  have ha' : algebraMap Γ(X, U) X.functionField a ∈ chartAlg k U :=
    algebraMap_chart_mem_sectionSub_zero k a
  have hb' : algebraMap Γ(X, U) X.functionField b ∈ chartAlg k U :=
    algebraMap_chart_mem_sectionSub_zero k b
  have hbne : algebraMap Γ(X, U) X.functionField b ≠ 0 := fun h =>
    (nonZeroDivisors.coe_ne_zero ⟨b, hb⟩) (IsFractionRing.to_map_eq_zero_iff.mp h)
  obtain ⟨c, hc⟩ := hfield.mul_inv_cancel (a := (⟨_, hb'⟩ : chartAlg k U))
    (by simpa [Subtype.ext_iff] using hbne)
  have hbinv : (algebraMap Γ(X, U) X.functionField b)⁻¹ ∈ chartAlg k U := by
    have hval : algebraMap Γ(X, U) X.functionField b * (c : X.functionField) = 1 := by
      have := congrArg (fun z : chartAlg k U => (z : X.functionField)) hc
      simpa using this
    rw [← eq_inv_of_mul_eq_one_right hval]; exact c.2
  rw [← hab, div_eq_mul_inv]
  exact Subalgebra.mul_mem _ ha' hbinv