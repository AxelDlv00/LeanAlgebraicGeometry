---
author: sync
content_type: theorem
created: '2026-07-17T21:17:13'
decl: Module.Flat.of_surjective_exact_of_forall_mem_smul_top
docstring: '**Flatness of a cokernel from the ideal-division property** (no Noetherian

  hypothesis): if `M` is flat, `π : M → Q` is a surjection with `ker π = range φ`
  for an

  endomorphism `φ` of `M`, and `φ` divides membership in `I·M` for every finitely

  generated ideal `I` (`φ x ∈ I·M ⟹ x ∈ I·M`), then `Q` is flat.


  The ideal criterion (`iff_lift_lsmul_comp_subtype_injective`) reduces flatness of
  `Q`

  to injectivity of `I ⊗ Q → Q`; a kernel element lifts along the right-exact

  `I ⊗ M → I ⊗ Q`, its image in `M` lands in `I·M ∩ ker π = φ(I·M)` by ideal division,

  and injectivity of `I ⊗ M → M` (flatness of `M`) pushes the factorization back up
  to

  `I ⊗ M`, where `π ∘ φ = 0` kills it. This is the connecting-map chase of Kleiman''s

  `Tor₁` argument, done by hand.'
file: AlgebraicJacobian/Picard/SlicingFlat.lean
generated: lean
lean_status: lean_ok
stale: true
title: Module.Flat.of_surjective_exact_of_forall_mem_smul_top
type: lean
updated: '2026-07-31T20:14:40'
---
theorem Module.Flat.of_surjective_exact_of_forall_mem_smul_top [Module.Flat R M]
    (φ : M →ₗ[R] M) (π : M →ₗ[R] Q) (hsurj : Function.Surjective π)
    (hexact : Function.Exact φ π)
    (hdvd : ∀ (I : Ideal R), I.FG → ∀ x : M,
      φ x ∈ I • (⊤ : Submodule R M) → x ∈ I • (⊤ : Submodule R M)) :
    Module.Flat R Q := by
  rw [Module.Flat.iff_lift_lsmul_comp_subtype_injective]
  intro I hI
  rw [injective_iff_map_eq_zero]
  intro ξ hξ
  -- lift `ξ` along the surjection `I ⊗ M → I ⊗ Q`
  obtain ⟨η, rfl⟩ := LinearMap.lTensor_surjective I hsurj ξ
  -- its image `m := μ η ∈ M` dies in `Q`, so `m = φ z`
  have hπ : π (TensorProduct.lift ((LinearMap.lsmul R M).comp I.subtype) η) = 0 := by
    rw [← lift_lsmul_lTensor_apply π η]
    exact hξ
  obtain ⟨z, hz⟩ := (hexact _).mp hπ
  -- `φ z = m ∈ I·M`, so `z ∈ I·M` by ideal division; lift `z` back to `I ⊗ M`
  have hzmem : z ∈ I • (⊤ : Submodule R M) :=
    hdvd I hI z (by rw [hz]; exact lift_lsmul_mem_smul_top η)
  obtain ⟨η', hη'⟩ := exists_lift_lsmul_of_mem_smul_top hzmem
  -- flatness of `M`: `I ⊗ M → M` is injective, so `η = φ_I η'`
  have hinj : Function.Injective
      (TensorProduct.lift ((LinearMap.lsmul R M).comp I.subtype)) :=
    Module.Flat.iff_lift_lsmul_comp_subtype_injective.mp inferInstance hI
  have hη : φ.lTensor I η' = η := by
    refine hinj ?_
    rw [lift_lsmul_lTensor_apply φ η', hη', hz]
  -- `π_I ∘ φ_I = (π ∘ φ)_I = 0`
  have hcomp : π.comp φ = 0 := LinearMap.ext fun m => (hexact (φ m)).mpr ⟨m, rfl⟩
  calc π.lTensor I η = π.lTensor I (φ.lTensor I η') := by rw [hη]
    _ = (π.comp φ).lTensor I η' := by rw [LinearMap.lTensor_comp, LinearMap.comp_apply]
    _ = 0 := by rw [hcomp, LinearMap.lTensor_zero, LinearMap.zero_apply]