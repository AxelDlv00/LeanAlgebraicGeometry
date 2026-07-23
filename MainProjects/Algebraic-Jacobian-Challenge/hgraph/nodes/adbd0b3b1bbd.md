---
author: sync
content_type: theorem
created: '2026-07-16T21:14:26'
decl: Module.Flat.rTensor_injective_of_exact_aux
docstring: '**The 3×3 chase behind Stacks 00HL**, over an arbitrary presentation

  `K —ι→ F₀ —π→ N → 0` with `F₀` flat: if `f : A → B` is injective, `(f, g)` is

  exact with `g` surjective and `C = coker f` flat, then

  `f ⊗ 𝟙_N : A ⊗ N → B ⊗ N` is injective.


  In the 3×3 diagram with rows `• ⊗ K → • ⊗ F₀ → • ⊗ N → 0` (exact by

  right-exactness of `⊗`) and columns `A ⊗ • → B ⊗ • → C ⊗ •`, an element

  `x ∈ ker (A ⊗ N → B ⊗ N)` lifts to `y ∈ A ⊗ F₀`; its image `y'' ∈ B ⊗ F₀`

  dies in `B ⊗ N`, hence comes from `z ∈ B ⊗ K`; the image of `z` in `C ⊗ K`

  dies in `C ⊗ F₀` (because `g ∘ f = 0`) and `C ⊗ K → C ⊗ F₀` is injective

  (`C` flat, `ι` injective), so `z` comes from `w ∈ A ⊗ K`; correcting `y` by

  `w` gives an element of `ker (A ⊗ F₀ → B ⊗ F₀) = 0` (`F₀` flat), so

  `y = ι w` and `x = π (ι w) = 0`.'
file: AlgebraicJacobian/Picard/FlatKernelBase.lean
generated: lean
lean_status: lean_ok
title: Module.Flat.rTensor_injective_of_exact_aux
type: lean
updated: '2026-07-24T03:02:10'
---
private theorem Module.Flat.rTensor_injective_of_exact_aux
    {R : Type*} [CommRing R] {A B C K F₀ N : Type*}
    [AddCommGroup A] [AddCommGroup B] [AddCommGroup C]
    [AddCommGroup K] [AddCommGroup F₀] [AddCommGroup N]
    [Module R A] [Module R B] [Module R C]
    [Module R K] [Module R F₀] [Module R N]
    {f : A →ₗ[R] B} {g : B →ₗ[R] C} (ι : K →ₗ[R] F₀) (π : F₀ →ₗ[R] N)
    (hf : Function.Injective f) (hfg : Function.Exact f g)
    (hg : Function.Surjective g) (hC : Module.Flat R C)
    (hF₀ : Module.Flat R F₀)
    (hι : Function.Injective ι) (hexact : Function.Exact ι π)
    (hπ : Function.Surjective π) :
    Function.Injective (f.rTensor N) := by
  -- rows: right-exactness of `• ⊗`
  have rowB : Function.Exact (ι.lTensor B) (π.lTensor B) :=
    _root_.lTensor_exact B hexact hπ
  have hπA : Function.Surjective (π.lTensor A) := LinearMap.lTensor_surjective A hπ
  -- columns: right-exactness of `⊗ K`, flat injectivity for `C ⊗ •`, `• ⊗ F₀`
  have colK : Function.Exact (f.rTensor K) (g.rTensor K) :=
    _root_.rTensor_exact K hfg hg
  have hCι : Function.Injective (ι.lTensor C) :=
    haveI := hC
    Module.Flat.lTensor_preserves_injective_linearMap (M := C) ι hι
  have hfF₀ : Function.Injective (f.rTensor F₀) :=
    haveI := hF₀
    Module.Flat.rTensor_preserves_injective_linearMap (M := F₀) f hf
  -- the chase
  rw [injective_iff_map_eq_zero]
  intro x hx
  obtain ⟨y, rfl⟩ := hπA x
  -- the middle image `f ⊗ F₀ (y)` dies in `B ⊗ N`
  have comm1 : (π.lTensor B).comp (f.rTensor F₀) = (f.rTensor N).comp (π.lTensor A) := by
    rw [LinearMap.lTensor_comp_rTensor, LinearMap.rTensor_comp_lTensor]
  have h1 : (π.lTensor B) ((f.rTensor F₀) y) = 0 := by
    have e := LinearMap.congr_fun comm1 y
    rw [LinearMap.comp_apply, LinearMap.comp_apply] at e
    rw [e, hx]
  -- so it comes from `z ∈ B ⊗ K`
  obtain ⟨z, hz⟩ := (rowB _).mp h1
  -- the image of `z` in `C ⊗ K` vanishes (`C` flat kills it in `C ⊗ F₀`)
  have comm2 : (g.rTensor F₀).comp (ι.lTensor B) =
      (ι.lTensor C).comp (g.rTensor K) := by
    rw [LinearMap.rTensor_comp_lTensor, LinearMap.lTensor_comp_rTensor]
  have hgf : (g.rTensor F₀).comp (f.rTensor F₀) = 0 := by
    rw [← LinearMap.rTensor_comp, hfg.linearMap_comp_eq_zero, LinearMap.rTensor_zero]
  have h2 : (ι.lTensor C) ((g.rTensor K) z) = 0 := by
    have e := LinearMap.congr_fun comm2 z
    rw [LinearMap.comp_apply, LinearMap.comp_apply] at e
    rw [← e, hz]
    have e' := LinearMap.congr_fun hgf y
    rwa [LinearMap.comp_apply, LinearMap.zero_apply] at e'
  have h3 : (g.rTensor K) z = 0 :=
    (injective_iff_map_eq_zero _).mp hCι _ h2
  -- exactness of the `⊗ K` column: `z` comes from `w ∈ A ⊗ K`
  obtain ⟨w, hw⟩ := (colK z).mp h3
  -- correct `y` by `w`: the difference dies in `B ⊗ F₀`, hence vanishes
  have comm3 : (f.rTensor F₀).comp (ι.lTensor A) =
      (ι.lTensor B).comp (f.rTensor K) := by
    rw [LinearMap.rTensor_comp_lTensor, LinearMap.lTensor_comp_rTensor]
  have h4 : (f.rTensor F₀) (y - (ι.lTensor A) w) = 0 := by
    rw [map_sub]
    have e := LinearMap.congr_fun comm3 w
    rw [LinearMap.comp_apply, LinearMap.comp_apply] at e
    rw [e, hw, hz, sub_self]
  have h5 : y = (ι.lTensor A) w := by
    have := (injective_iff_map_eq_zero _).mp hfF₀ _ h4
    rwa [sub_eq_zero] at this
  -- conclude: `x = π (ι w) = 0`
  have h6 : (π.lTensor A).comp (ι.lTensor A) = 0 := by
    rw [← LinearMap.lTensor_comp, hexact.linearMap_comp_eq_zero, LinearMap.lTensor_zero]
  rw [h5]
  have e := LinearMap.congr_fun h6 w
  rwa [LinearMap.comp_apply, LinearMap.zero_apply] at e