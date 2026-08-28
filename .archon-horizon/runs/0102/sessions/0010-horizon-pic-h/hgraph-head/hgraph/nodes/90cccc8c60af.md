---
author: sync
content_type: theorem
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.Grassmannian.carvePairArrow_eq_zero_iff
docstring: The carve-pair arrow vanishes iff the multiplier maps `Km` into `K'`.
file: AlgebraicJacobian/Picard/DivCarveKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.carvePairArrow_eq_zero_iff
type: lean
updated: '2026-08-01T09:44:11'
---
theorem carvePairArrow_eq_zero_iff (μ : H₁ →ₗ[k] H₂) (Km : Submodule R (TensorProduct k R H₁))
    (K' : Submodule R (TensorProduct k R H₂)) :
    carvePairArrow μ Km K' = 0 ↔ ∀ x ∈ Km, LinearMap.baseChange R μ x ∈ K' := by
  constructor
  · intro h x hx
    have h1 := LinearMap.congr_fun h ⟨x, hx⟩
    rwa [carvePairArrow, LinearMap.comp_apply, LinearMap.comp_apply, Submodule.subtype_apply,
      LinearMap.zero_apply, Submodule.mkQ_apply, Submodule.Quotient.mk_eq_zero] at h1
  · intro h
    refine LinearMap.ext fun x => ?_
    rw [carvePairArrow, LinearMap.comp_apply, LinearMap.comp_apply, Submodule.subtype_apply,
      LinearMap.zero_apply, Submodule.mkQ_apply, Submodule.Quotient.mk_eq_zero]
    exact h x.1 x.2

variable (S : Type u) [CommRing S] [Algebra k S] [Algebra R S] [IsScalarTower k R S]