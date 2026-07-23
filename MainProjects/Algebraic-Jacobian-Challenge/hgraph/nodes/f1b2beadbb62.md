---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: AlgebraicGeometry.SectionCechModule.dDiff_exact_of_affineCover
docstring: '**Route-B1 positive-degree exactness of the un-localised section Čech
  module complex `D•` over a

  cover of a *general affine open* `V = ⨆ᵢ D(sᵢ)`** (`lem:affine_cech_vanishing_general_seed`,
  module

  core).  The cover family `s = g` need NOT span the unit ideal of `R`, and `V` need
  NOT be a single

  distinguished `D(f)`; only the images `sᵢ ↦ S = Γ(V)` span the unit ideal of `S`
  (`hspan`).

  Then the complex `∏_σ M_{s_σ}` is exact in positive degrees.


  Change the ring to `S = Γ(V)` via algebraic base change `M ⊗_R S`: instantiate

  `dDiff_exact` over `S` with the module `M_S = M ⊗_R S` and the spanning family

  `s̄ = algebraMap R S ∘ s`, then transport positive-degree exactness back to the
  `R`-side

  along the degreewise additive isomorphisms `M_{s_σ} ≅ (M_S)_{s̄_σ}`.  These isomorphisms

  come from `isLocalizedModule_baseChange_away` and the universal `IsLocalizedModule.iso`,

  and intertwine the alternating-sum localisation differentials.  The geometric input
  that

  the ring of `(M_S)_{s̄_σ}` is also an `R`-localisation at `powers (s_σ)` is supplied
  by the

  `hloc` family.'
file: AlgebraicJacobian/Cohomology/CechAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.SectionCechModule.dDiff_exact_of_affineCover
type: lean
updated: '2026-07-24T03:02:09'
---
lemma dDiff_exact_of_affineCover [Finite ι]
    (S : Type u) [CommRing S] [Algebra R S]
    (hspan : Ideal.span (Set.range (fun i => algebraMap R S (s i))) = ⊤)
    (hloc : ∀ {n : ℕ} (σ : Fin (n + 1) → ι),
      IsLocalization (Submonoid.powers (sprod s σ))
        (Localization (Submonoid.powers (algebraMap R S (sprod s σ)))))
    (m : ℕ) :
    Function.Exact (dDiff s M (m + 1)) (dDiff s M (m + 2)) := by
  classical
  set MS := TensorProduct R S M with hMS
  set bc : M →ₗ[R] MS := TensorProduct.mk R S M 1 with hbc
  set gS : ι → S := fun i => algebraMap R S (s i) with hgS
  -- `S`-side positive-degree exactness (the black-box reuse of `dDiff_exact`).
  have Hf : Function.Exact (dDiff gS MS (m + 1)) (dDiff gS MS (m + 2)) :=
    dDiff_exact gS MS hspan m
  -- `sprod gS σ` is the image of `sprod s σ`.
  have hsprod : ∀ {n : ℕ} (σ : Fin n → ι), sprod gS σ = algebraMap R S (sprod s σ) := by
    intro n σ; simp only [hgS, sprod, map_prod]
  -- the composite localisation structure map `M → M_S → (M_S)_{s_σ}` localises `M` at `s_σ`.
  have inst_comp : ∀ {n : ℕ} (σ : Fin (n + 1) → ι),
      IsLocalizedModule (Submonoid.powers (sprod s σ))
        ((LocalizedModule.mkLinearMap
          (Submonoid.powers (sprod gS σ)) MS).restrictScalars R ∘ₗ bc) := by
    intro n σ
    haveI hL : IsLocalization (Submonoid.powers (algebraMap R S (sprod s σ)))
        (Localization (Submonoid.powers (sprod gS σ))) := by
      rw [← hsprod σ]; infer_instance
    haveI hLM : IsLocalizedModule (Submonoid.powers (algebraMap R S (sprod s σ)))
        (LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS σ)) MS) := by
      rw [← hsprod σ]; infer_instance
    haveI hR : IsLocalization (Submonoid.powers (sprod s σ))
        (Localization (Submonoid.powers (sprod gS σ))) := by
      rw [hsprod σ]; exact hloc σ
    exact isLocalizedModule_baseChange_away bc (TensorProduct.isBaseChange R M S)
      (LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS σ)) MS)
      (Localization (Submonoid.powers (sprod gS σ))) (a := sprod s σ)
  -- the per-σ `R`-linear comparison `(M_S)_{s_σ} ≅ M_{s_σ}` (S-side → R-side).
  let eσL : ∀ {n : ℕ} (σ : Fin (n + 1) → ι), dCoeff gS MS σ ≃ₗ[R] dCoeff s M σ :=
    fun {n} σ =>
      haveI := inst_comp σ
      (IsLocalizedModule.iso (Submonoid.powers (sprod s σ))
        ((LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS σ)) MS).restrictScalars R ∘ₗ
          bc)).symm
  -- `eσL τ` undoes the composite structure map: it sends `compMap τ mval ↦ mk_{s_τ} mval`.
  have heσL : ∀ {n : ℕ} (τ : Fin (n + 1) → ι) (mval : M),
      eσL τ ((LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS τ)) MS) (bc mval))
        = LocalizedModule.mkLinearMap (Submonoid.powers (sprod s τ)) M mval := by
    intro n τ mval
    haveI := inst_comp τ
    exact DFunLike.congr_fun (IsLocalizedModule.iso_symm_comp (Submonoid.powers (sprod s τ))
      ((LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS τ)) MS).restrictScalars R ∘ₗ
        bc)) mval
  -- per-coface naturality: `eσ` intertwines the two cofaces.
  have nat : ∀ {n : ℕ} (σ : Fin (n + 2) → ι) (j : Fin (n + 2))
      (z : dCoeff gS MS (σ ∘ j.succAbove)),
      eσL σ (dCoface gS MS (n + 1) σ j z)
        = dCoface s M (n + 1) σ j (eσL (σ ∘ j.succAbove) z) := by
    intro n σ j z
    haveI := inst_comp (σ ∘ j.succAbove)
    have key : (eσL σ).toLinearMap ∘ₗ (dCoface gS MS (n + 1) σ j).restrictScalars R
        = (dCoface s M (n + 1) σ j) ∘ₗ (eσL (σ ∘ j.succAbove)).toLinearMap := by
      apply IsLocalizedModule.ext (Submonoid.powers (sprod s (σ ∘ j.succAbove)))
        (LinearMap.restrictScalars R
            (LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS (σ ∘ j.succAbove))) MS)
          ∘ₗ bc)
        (fun x => (AwayComparison.Inverts.of_dvd (sprod_succAbove_dvd s σ j)
          (LocalizedModule.mkLinearMap (Submonoid.powers (sprod s σ)) M)).isUnit_powers x)
      apply LinearMap.ext; intro mval
      simp only [LinearMap.coe_comp, LinearMap.coe_restrictScalars, Function.comp_apply,
        LinearEquiv.coe_coe]
      have hL : dCoface gS MS (n + 1) σ j
            ((LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS (σ ∘ j.succAbove))) MS)
              (bc mval))
          = (LocalizedModule.mkLinearMap (Submonoid.powers (sprod gS σ)) MS) (bc mval) := by
        simp only [dCoface]
        exact AwayComparison.comparison_apply _ _ _ _
      rw [hL, heσL σ mval, heσL (σ ∘ j.succAbove) mval]
      simp only [dCoface]
      exact (AwayComparison.comparison_apply _ _ _ mval).symm
    exact DFunLike.congr_fun key z
  -- bundle the per-σ comparisons into product `AddEquiv`s.
  let E : (n : ℕ) → ((σ : Fin (n + 1) → ι) → dCoeff gS MS σ) ≃+
      ((σ : Fin (n + 1) → ι) → dCoeff s M σ) :=
    fun n => AddEquiv.piCongrRight (fun σ => (eσL σ).toAddEquiv)
  -- the ladder squares.
  have sq : ∀ r : ℕ,
      (dDiff s M (r + 1)).toAddMonoidHom.comp (E r).toAddMonoidHom
        = (E (r + 1)).toAddMonoidHom.comp (dDiff gS MS (r + 1)).toAddMonoidHom := by
    intro r
    apply AddMonoidHom.ext; intro x
    simp only [AddMonoidHom.coe_comp, Function.comp_apply, AddEquiv.coe_toAddMonoidHom,
      LinearMap.toAddMonoidHom_coe]
    funext σ
    change dDiff s M (r + 1) (fun τ => eσL τ (x τ)) σ
      = eσL σ (dDiff gS MS (r + 1) x σ)
    rw [dDiff_apply, dDiff_apply, map_sum]
    refine Finset.sum_congr rfl (fun j _ => ?_)
    rw [map_zsmul, nat]
  exact Function.Exact.of_ladder_addEquiv_of_exact (E m) (E (m + 1)) (E (m + 2))
    (sq m) (sq (m + 1)) Hf

end SectionCechModule

/-! ## Quasi-coherent sections as away localisations

The categorical→module bridge needs the section-identification of
`def:qcoh_sections_localized`: over a basic open `D(g)` the sections of a
quasi-coherent sheaf are the away localisation `M_g`, and the restriction maps
between basic opens are the canonical localisation comparison maps.  For the
standard sheaf `tilde M` this is *verbatim* from Mathlib's `Tilde` development
(`AlgebraicGeometry.tilde.toOpen` carries `IsLocalizedModule (.powers g)` and the
restriction compatibility is `tilde.toOpen_res`); the only project-local content is
(i) the multi-index intersection `⨅ₖ D(s_{σ k}) = D(s_σ)` identification, which lets
the degree-`p` section group over the `(p+1)`-fold intersection be read as the
localisation `M_{s_σ}` (this is what `lem:section_cech_homology_exact` consumes
degreewise), and (ii) the identification of the abstract presheaf restriction with
`AwayComparison.comparison`, the differential brick.

For an *arbitrary* quasi-coherent `F` the remaining input is the affine equivalence
`F ≅ tilde(ΓF)` (Stacks 01I8); see `def:qcoh_sections_localized`.  The tilde case
below is the gap-free part that lands the named target. -/