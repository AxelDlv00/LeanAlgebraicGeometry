---
author: sync
content_type: lemma
created: '2026-07-20T11:31:57'
decl: exists_comp_eq_id_of_lTensor_residueField_injective
docstring: '**Split injection into a free module from the residue-fibre injectivity**
  (free codomain,

  any rank).  Over a local ring, a map `ψ : M → N` with `M` finite, `N` free and `κ
  ⊗ ψ`

  injective is a split injection.  Route: `range ψ` is finitely generated, hence contained
  in a

  finite free direct summand `F` (`exists_finite_free_summand_of_fg`); `ψ` factors
  through `F`;

  the mathlib finite split criterion applies to `M → F`; compose the retractions.'
file: AlgebraicJacobian/Picard/DivSchemeRedesignFreeFlat.lean
generated: lean
lean_status: lean_ok
private: true
title: exists_comp_eq_id_of_lTensor_residueField_injective
type: lean
updated: '2026-07-28T17:25:24'
---
private lemma exists_comp_eq_id_of_lTensor_residueField_injective
    [Module.Finite R M] [Module.Free R N] (ψ : M →ₗ[R] N)
    (hf : Function.Injective (ψ.lTensor (IsLocalRing.ResidueField R))) :
    ∃ r : N →ₗ[R] M, r ∘ₗ ψ = LinearMap.id := by
  have hfg : (LinearMap.range ψ).FG := by
    rw [LinearMap.range_eq_map]; exact Module.Finite.fg_top.map ψ
  obtain ⟨F, pr, hFfin, hFfree, hle, hpr⟩ := exists_finite_free_summand_of_fg hfg
  -- `ψ` corestricts to `F`
  have hmem : ∀ m, ψ m ∈ F := fun m => hle (LinearMap.mem_range_self ψ m)
  set ψ₀ : M →ₗ[R] F := LinearMap.codRestrict F ψ hmem with hψ₀def
  have hfac : F.subtype ∘ₗ ψ₀ = ψ := by
    ext m
    simp only [hψ₀def, LinearMap.comp_apply, Submodule.subtype_apply,
      LinearMap.codRestrict_apply]
  -- `κ ⊗ ψ₀` is injective (the split `F.subtype` is universally injective after `⊗ κ`)
  have hf₀ : Function.Injective (ψ₀.lTensor (IsLocalRing.ResidueField R)) := by
    have hcomp : (F.subtype.lTensor (IsLocalRing.ResidueField R)) ∘ₗ
        (ψ₀.lTensor (IsLocalRing.ResidueField R))
          = ψ.lTensor (IsLocalRing.ResidueField R) := by
      rw [← LinearMap.lTensor_comp, hfac]
    have h2 := hf
    rw [← hcomp, LinearMap.coe_comp] at h2
    exact h2.of_comp
  -- the mathlib finite split criterion on `M → F`
  obtain ⟨r₀, hr₀⟩ :=
    (IsLocalRing.split_injective_iff_lTensor_residueField_injective ψ₀).mpr hf₀
  refine ⟨r₀ ∘ₗ pr, ?_⟩
  ext m
  have e1 : pr (F.subtype (ψ₀ m)) = ψ₀ m := by
    have := LinearMap.congr_fun hpr (ψ₀ m); simpa using this
  have e2 : F.subtype (ψ₀ m) = ψ m := by
    have := LinearMap.congr_fun hfac m; simpa using this
  have e3 : r₀ (ψ₀ m) = m := by
    have := LinearMap.congr_fun hr₀ m; simpa using this
  simp only [LinearMap.comp_apply, LinearMap.id_apply]
  rw [← e2, e1]; exact e3