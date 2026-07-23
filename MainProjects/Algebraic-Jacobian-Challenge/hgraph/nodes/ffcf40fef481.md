---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.section_localization_hfr_aux_general
docstring: '**(gap2 core) Basic-open section localization along an abstract affine
  open immersion.** For an

  open immersion `j : Spec S ⟶ X` with the P1 datum `IsIso (fromTildeΓ ((pullback
  j).obj M))`, a slice

  element `f'' : S`, and `f : Γ(X, j ''''ᵁ ⊤)` with `σ f'' = f` (`σ = (ΓSpecIso S)⁻¹
  ≫ gammaImageRingEquiv

  j ⊤`), the section restriction `Γ(M, j ''''ᵁ ⊤) → Γ(M, j ''''ᵁ D(f''))` is

  `IsLocalizedModule (powers f)` over `Γ(X, j ''''ᵁ ⊤)`.


  The proof mirrors `section_localization_hfr_aux` but over an arbitrary ambient scheme
  `X` (so the

  localization ring is the *local* section ring `A = Γ(X, j ''''ᵁ ⊤)`, not a global
  `R`): the engine

  `isLocalizedModule_restrict_of_isIso_fromTildeΓ` localizes the slice restriction
  `g` over `S`, the

  `σ`-semilinear section comparisons `e₁, e₂` (`gammaPullbackImageIso`) intertwine
  `g` with the

  `M`-side restriction `h = restrictₗ M ii`, and bridge (I)

  `isLocalizedModule_of_ringEquiv_semilinear` transports the localization across `σ`,
  landing

  `powers ((powers f'').map σ) = powers (σ f'') = powers f`. Because the base and
  target rings coincide

  (`R = A`), no `restrictScalars` base-change (bridge II) is needed. Project-local.'
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.section_localization_hfr_aux_general
type: lean
updated: '2026-07-24T03:02:11'
---
theorem section_localization_hfr_aux_general {X : Scheme.{u}} {S : CommRingCat.{u}}
    (M : X.Modules) (j : Spec S ⟶ X) [IsOpenImmersion j]
    (hP1 : IsIso (Scheme.Modules.fromTildeΓ ((Scheme.Modules.pullback j).obj M)))
    (f : Γ(X, j ''ᵁ (⊤ : (Spec S).Opens))) (f' : S)
    (hf' : (gammaImageRingEquiv j ⊤) ((Scheme.ΓSpecIso S).inv f') = f) :
    letI : Module Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f')) :=
      Module.compHom _ (X.presheaf.map (j.opensFunctor.map (homOfLE le_top)).op).hom
    IsLocalizedModule (Submonoid.powers f)
      (show Γ(M, j ''ᵁ (⊤ : (Spec S).Opens)) →ₗ[Γ(X, j ''ᵁ (⊤ : (Spec S).Opens))]
          Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f')) from
        restrictₗ M (j.opensFunctor.map (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤)))) := by
  let M' := (Scheme.Modules.pullback j).obj M
  haveI : IsIso (Scheme.Modules.fromTildeΓ M') := hP1
  let σ : (S : Type _) ≃+* (Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) : Type _) :=
    (Scheme.ΓSpecIso S).symm.commRingCatIsoToRingEquiv.trans (gammaImageRingEquiv j ⊤)
  have hf : σ f' = f := hf'
  let ii : (j ''ᵁ (PrimeSpectrum.basicOpen f') : X.Opens) ⟶ j ''ᵁ (⊤ : (Spec S).Opens) :=
    j.opensFunctor.map (homOfLE le_top)
  letI iAN₂ : Module (Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) : Type _)
      (ToType Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f'))) :=
    Module.compHom _ (X.presheaf.map ii.op).hom
  let e₁ := (gammaPullbackImageIso j M ⊤).addCommGroupIsoToAddEquiv
  let e₂ := (gammaPullbackImageIso j M (PrimeSpectrum.basicOpen f')).addCommGroupIsoToAddEquiv
  let g := ((modulesSpecToSheaf.obj M').presheaf.map
    (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤)).op).hom
  haveI : IsLocalizedModule (Submonoid.powers f') g :=
    isLocalizedModule_restrict_of_isIso_fromTildeΓ M' f'
  let h : ToType Γ(M, j ''ᵁ (⊤ : (Spec S).Opens)) →ₗ[(Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) : Type _)]
      ToType Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f')) :=
    { toFun := fun m => (M.presheaf.map ii.op) m
      map_add' := fun x y => map_add _ x y
      map_smul' := fun a m => Scheme.Modules.map_smul M ii a m }
  have he₁ : ∀ (a : (S : Type _))
      (x : ToType ((modulesSpecToSheaf.obj M').presheaf.obj (.op ⊤))),
      e₁ (a • x) = σ a • e₁ x :=
    fun a x => gammaPullbackImageIso_hom_semilinear j M ⊤ ((Scheme.ΓSpecIso S).inv a) x
  have key0 := j.appIso_inv_naturality (U := (⊤ : (Spec S).Opens))
    (V := PrimeSpectrum.basicOpen f') (homOfLE le_top).op
  have he₂ : ∀ (a : (S : Type _))
      (x : ToType ((modulesSpecToSheaf.obj M').presheaf.obj (.op (PrimeSpectrum.basicOpen f')))),
      e₂ (a • x) = σ a • e₂ x := by
    intro a x
    have h1 := gammaPullbackImageIso_hom_semilinear j M (PrimeSpectrum.basicOpen f')
      ((Spec S).presheaf.map (homOfLE le_top).op ((Scheme.ΓSpecIso S).inv a)) x
    have key : (gammaImageRingEquiv j (PrimeSpectrum.basicOpen f'))
          ((Spec S).presheaf.map (homOfLE le_top).op ((Scheme.ΓSpecIso S).inv a))
        = (X.presheaf.map ii.op).hom (σ a) :=
      congrArg (fun φ => φ.hom ((Scheme.ΓSpecIso S).inv a)) key0
    exact h1.trans (congrArg (· • e₂ x) key)
  have hh : ∀ x, h (e₁ x) = e₂ (g x) := by
    intro x
    have hn := ConcreteCategory.congr_hom
      (gammaPullbackImageIso_hom_naturality j M
        (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤))) x
    simp only [CategoryTheory.comp_apply] at hn
    exact hn.symm
  have RESULT : IsLocalizedModule
      ((Submonoid.powers f').map (σ : S →+* Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)))) h :=
    isLocalizedModule_of_ringEquiv_semilinear σ (Submonoid.powers f') g e₁ e₂ he₁ he₂ h hh
  have key : (Submonoid.powers f').map (σ : S →+* Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)))
      = Submonoid.powers f := by
    rw [Submonoid.map_powers]; exact congrArg Submonoid.powers hf
  rw [key] at RESULT
  exact RESULT