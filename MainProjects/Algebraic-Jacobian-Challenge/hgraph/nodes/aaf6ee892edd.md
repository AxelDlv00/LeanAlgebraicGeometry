---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushforward_spec_tilde_iso
docstring: '**Affine pushforward of a tilde-module (unconditional).** For a ring map
  `φ : R ⟶ R''`

  and an `R''`-module `M`, pushing the quasi-coherent sheaf `M^~` forward along `Spec
  φ` is,

  up to canonical isomorphism, the tilde of the restriction of scalars of `M` along
  `φ`. This

  is the unconditional form of `pushforward_spec_tilde_iso_of_isLocalizedModule`:
  the latter''s

  hypothesis `hloc` (each structure-sheaf restriction `Γ(N,⊤) → Γ(N,D(a))` is a localization
  at

  `powers a`) is discharged here by the `D(a)`-level transport. See blueprint

  `lem:pushforward_spec_tilde_iso`.'
file: AlgebraicJacobian/Cohomology/FlatBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushforward_spec_tilde_iso
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def pushforward_spec_tilde_iso {R R' : CommRingCat.{u}}
    (φ : R ⟶ R') (M : ModuleCat.{u} R') :
    (Scheme.Modules.pushforward (Spec.map φ)).obj (tilde M) ≅
      tilde ((ModuleCat.restrictScalars φ.hom).obj M) := by
  apply pushforward_spec_tilde_iso_of_isLocalizedModule φ M
  intro a
  -- STRATEGY (`of_linearEquiv`): the restriction map `ρ : Γ(N,⊤) → Γ(N,D(a))` of
  -- `N := (Spec φ)_* (M^~)` is, under the isomorphisms
  -- `gammaPushforwardIsoAt φ (tilde M) ⊤` and `gammaPushforwardIsoAt φ (tilde M) (D a)`,
  -- identified with the restriction of scalars along `φ` of the `R'`-side tilde restriction
  -- `σ : Γ(M^~, ⊤) → Γ(M^~, D(φ a))`. That `σ` is a localization at `powers (φ a)`
  -- (`tildeRestriction_isLocalizedModule`), so its restriction of scalars along `φ` is a
  -- localization at `powers a` (`IsLocalizedModule.powers_restrictScalars`); transporting along
  -- the two isomorphisms then yields `hloc(a)`.
  -- The two bricks for this discharge are now in place and axiom-clean:
  --   • `gammaPushforwardIsoAt φ (tilde M) U : Γ(N, U) ≅ restrictScalars φ (Γ(M^~, (Spec φ)⁻¹ U))`
  --     — the open-indexed `e_{D(a)}` isomorphism (blueprint movement (1)); and
  --   • `tildeRestriction_isLocalizedModule M (φ a)` — the `R'`-side restriction
  --     `Γ(M^~, ⊤) → Γ(M^~, D(φ a))` is a localization at `powers (φ a)`.
  -- The `of_linearEquiv` finish is: with `e₁ = gammaPushforwardIsoAt φ (tilde M) ⊤` and
  -- `e₂ = gammaPushforwardIsoAt φ (tilde M) (D a)`, the naturality square
  -- `e₂.hom ∘ ρ = (restrictScalars φ σ) ∘ e₁.hom` (where `σ` is the `R'`-side restriction and
  -- `ρ` the pushforward-side one) gives `ρ = e₂.symm ∘ₗ (restrictScalars φ σ) ∘ₗ e₁`; then
  -- `IsLocalizedModule.powers_restrictScalars` upgrades `σ` (localization at `powers (φ a)`,
  -- since `algebraMapSubmonoid R' (powers a) = powers (φ a)` along `φ.hom.toAlgebra`) to a
  -- localization at `powers a` of `restrictScalars φ σ`, and two applications of
  -- `IsLocalizedModule.of_linearEquiv` / `of_linearEquiv_right` transport this to `ρ`.
  --
  -- iter-240 PIVOT (`algebraize`): preimage opens are *definitionally* the basic opens
  -- (`AlgebraicGeometry.SpecMap_preimage_basicOpen` is `rfl`), so the `R'`-side restriction
  -- `σ` is literally `tilde M`'s restriction `⊤ → D(φ a)`, and `algebraize [φ.hom]` supplies the
  -- honest `Algebra ↑R ↑R'`/`IsScalarTower` instances that `powers_restrictScalars` needs.
  algebraize [φ.hom]
  -- `σ` : the `R'`-side restriction map `Γ(M^~, ⊤) → Γ(M^~, D(φ a))` of `tilde M`.
  set σmor := (modulesSpecToSheaf.obj (tilde M)).val.map
      (homOfLE (show PrimeSpectrum.basicOpen (φ.hom a) ≤ ⊤ from le_top)).op with hσmor
  -- Re-expose the `compHom`-via-`φ` `R`-module/scalar-tower instances (the ones the
  -- `ModuleCat.restrictScalars φ.hom` objects carry) on the bare section carriers, so that
  -- `powers_restrictScalars` can see them.
  letI mTop : Module R ↑((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op ⊤)) :=
    inferInstanceAs (Module R ((ModuleCat.restrictScalars φ.hom).obj
      ((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op ⊤))))
  letI mDa : Module R ↑((modulesSpecToSheaf.obj (tilde M)).val.obj
      (Opposite.op (PrimeSpectrum.basicOpen (φ.hom a)))) :=
    inferInstanceAs (Module R ((ModuleCat.restrictScalars φ.hom).obj
      ((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op (PrimeSpectrum.basicOpen (φ.hom a))))))
  haveI tTop : IsScalarTower R R' ↑((modulesSpecToSheaf.obj (tilde M)).val.obj (Opposite.op ⊤)) :=
    ⟨fun x y z => by rw [Algebra.smul_def, mul_smul]; rfl⟩
  haveI tDa : IsScalarTower R R' ↑((modulesSpecToSheaf.obj (tilde M)).val.obj
      (Opposite.op (PrimeSpectrum.basicOpen (φ.hom a)))) :=
    ⟨fun x y z => by rw [Algebra.smul_def, mul_smul]; rfl⟩
  -- `σ` is a localization at `powers (φ a)`.
  haveI hσloc : IsLocalizedModule (Submonoid.powers (φ.hom a)) σmor.hom :=
    tildeRestriction_isLocalizedModule M (φ.hom a)
  -- restriction of scalars of `σ` along `φ` is a localization at `powers a`.
  have himg : Algebra.algebraMapSubmonoid (R' : Type u) (Submonoid.powers a)
      = Submonoid.powers (φ.hom a) := by
    rw [Algebra.algebraMapSubmonoid_powers]; rfl
  haveI : IsLocalizedModule (Algebra.algebraMapSubmonoid (R' : Type u) (Submonoid.powers a))
      σmor.hom := by rw [himg]; exact hσloc
  haveI hGloc := @IsLocalizedModule.powers_restrictScalars (↑R) (↑R') _ _ _ _ _ _ _
    mTop mDa _ _ tTop tDa (Submonoid.powers a) σmor.hom this
  -- The restriction-of-scalars of `σ` as a `ModuleCat R` morphism (bundled `compHom` instances).
  set Gmor := (ModuleCat.restrictScalars φ.hom).map σmor with hGmor
  -- `Gmor.hom` is `σmor.hom.restrictScalars R`, hence a localization at `powers a`.
  haveI hG : IsLocalizedModule (Submonoid.powers a) Gmor.hom := hGloc
  -- The pushforward restriction `ρ` (a `ModuleCat R` morphism).
  set ρ := (modulesSpecToSheaf.obj ((pushforward (Spec.map φ)).obj (tilde M))).val.map
      (homOfLE (show PrimeSpectrum.basicOpen a ≤ ⊤ from le_top)).op with hρdef
  -- The two open-indexed comparison isos (`e_{⊤}`, `e_{D(a)}`), via `gammaPushforwardIsoAt`.
  set e₁ := gammaPushforwardIsoAt φ (tilde M) ⊤ with he₁
  set e₂ := gammaPushforwardIsoAt φ (tilde M) (PrimeSpectrum.basicOpen a) with he₂
  -- Naturality square (at the `ModuleCat R` level): conjugating the pushforward restriction `ρ`
  -- by `e₁`, `e₂` gives the restriction of scalars along `φ` of the `R'`-side restriction `σ`.
  -- The common underlying `R'`-side forget restriction map (with `FN` inlined so it matches
  -- the unfolded `gammaPushforwardIsoAt`).
  set tForget := ((SheafOfModules.forgetToSheafModuleCat (Spec R').ringCatSheaf (Opposite.op ⊤)
        (Limits.initialOpOfTerminal Limits.isTerminalTop)).obj (tilde M)).val.map
      (homOfLE (show (TopologicalSpace.Opens.map (Spec.map φ).base).obj
        (PrimeSpectrum.basicOpen a) ≤ ⊤ from le_top)).op with htForget
  -- Structural identifications (peel `modulesSpecToSheaf`/pushforward through `restrictScalars`),
  -- written with the *raw* ring maps so they match `gammaPushforwardIsoAt`'s unfolding.
  have hσ' : σmor = (ModuleCat.restrictScalars
      (StructureSheaf.globalSectionsIso (↑R' : CommRingCat)).hom.hom).map tForget := rfl
  have hρ' : ρ = (ModuleCat.restrictScalars
        (StructureSheaf.globalSectionsIso (↑R : CommRingCat)).hom.hom).map
      ((ModuleCat.restrictScalars
        ((Spec.map φ).toRingCatSheafHom.hom.app (Opposite.op ⊤)).hom).map tForget) := rfl
  -- The open-naturality square `ρ ≫ e₂.hom = e₁.hom ≫ Gmor` (the residual `hsq`).
  have hsq : ρ ≫ e₂.hom = e₁.hom ≫ Gmor := by
    -- Substitute the structural exposures, then unfold `gammaPushforwardIsoAt`. Here
    --   ρ = rsc gsR ∘ rsc pushTop ∘ tForget,  Gmor = rsc φ ∘ σmor = rsc φ ∘ rsc gsR' ∘ tForget,
    --   e_U = (rsc-comp')⁻¹ ≫ (restrictScalarsCongr hcomp).app SecN ≫ (rsc-comp').
    rw [he₁, he₂, hGmor, hρ', hσ']
    simp only [gammaPushforwardIsoAt, Iso.trans_hom, Iso.symm_hom]
    -- KEY INSIGHT (iter-241): every constituent of `gammaPushforwardIsoAt` is the IDENTITY on
    -- underlying elements — `restrictScalarsComp'App_{hom,inv}_apply`, `restrictScalarsCongr`
    -- app, and `restrictScalars.map_apply` are all `rfl`; the middle `restrictScalarsCongr` (now
    -- replaces the former `eqToIso`, removing the only non-`rfl` cast) merely repackages the module
    -- structure on the unchanged carrier. So both legs of the square send `x` to the underlying
    -- `tForget x` definitionally — a pointwise `rfl` closes it, sidestepping the rewrite-matching
    -- pathology that defeated the prior `restrictScalarsComp'App_inv_naturality`-rewrite route.
    ext x
    rfl
  -- Solve for `ρ` and transport the localization across the two equivalences.
  have hρ : ρ = (e₁.hom ≫ Gmor) ≫ e₂.inv := (Iso.eq_comp_inv e₂).mpr hsq
  have key : ρ.hom
      = e₂.toLinearEquiv.symm.toLinearMap ∘ₗ
          (Gmor.hom ∘ₗ e₁.toLinearEquiv.toLinearMap) := by
    rw [hρ]; rfl
  rw [key]
  haveI hstep : IsLocalizedModule (Submonoid.powers a)
      (Gmor.hom ∘ₗ e₁.toLinearEquiv.toLinearMap) :=
    IsLocalizedModule.of_linearEquiv_right (Submonoid.powers a) Gmor.hom e₁.toLinearEquiv
  exact IsLocalizedModule.of_linearEquiv (Submonoid.powers a)
    (Gmor.hom ∘ₗ e₁.toLinearEquiv.toLinearMap) e₂.toLinearEquiv.symm

/-! ## Project-local Mathlib supplement — affine pullback dictionary -/