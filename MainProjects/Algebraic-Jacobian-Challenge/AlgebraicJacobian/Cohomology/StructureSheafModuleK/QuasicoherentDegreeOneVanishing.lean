/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cohomology.StructureSheafModuleK.AffineDegreeOneVanishing
import AlgebraicJacobian.RiemannRoch.Adelic.GenusUnconditional
import AlgebraicJacobian.Cohomology.PullbackQuasicoherent
import AlgebraicJacobian.Picard.QuotScheme
import AlgebraicJacobian.Picard.RigidPushforward

/-!
# Degree-one affine vanishing for quasi-coherent modules and Čech cover-independence

The wave-5 keystone of the B3 lane: the degree-one affine vanishing
`H¹(U, M) = 0` (`HModule'`-form) for every affine open `U` and every
**quasi-coherent** sheaf of modules `M` on a `Spec k`-scheme, and the resulting
Čech **cover-independence** of `Ȟ¹`-vanishing on 2-affine covers.

## The bridge

The `HModule'` derived-functor machinery
(`Cohomology/StructureSheafModuleK/*`, `RiemannRoch/Adelic/GenusUnconditional`)
runs on sheaves of `k`-modules on the opens site; the B3 consumers work with
`X.Modules` (sheaves of `𝒪_X`-modules).  `toModuleKSheafOfModules` is the
dialect bridge: the underlying additive sheaf of `M : C.left.Modules`, with the
`k`-action restricted along the structure morphism (mirroring `toModuleKSheaf`
for the structure sheaf itself).  Sections, restriction maps and hence all
Čech difference maps agree **definitionally** with those of `M`.

## The vanishing

`subsingleton_hModule'_one_of_isAffineOpen_of_isQuasicoherent` mirrors the
structure-sheaf proof `subsingleton_hModule'_one_toModuleKSheaf_of_isAffineOpen`
(`AffineDegreeOneVanishing.lean`) step by step; the single 𝒪-specific brick —
sections of the kernel over the basic opens `D(g_σ)` are the localisations
`Γ(M, U)_{g_σ}` — is replaced by the quasi-coherence keystone
`Scheme.Modules.isLocalizedModule_basicOpen` (Stacks 01HV(4)/01I8 at
affine-open generality, `Picard/QuotScheme.lean`), packaged here as the module
section-identification kit `IsAffineOpen.dCoeffModuleSectionsLinearEquiv`
(mirroring `IsAffineOpen.dCoeffSectionsLinearEquiv` of
`CechCoboundarySplitting.lean`).

## Cover-independence

With degree-1 vanishing on the two affine pieces of **every** 2-affine cover
`S`, the Mayer–Vietoris `(0,1)`-slice
(`AffineCoverMVSquare.hModuleOneEquivH1CokOfSubsingleton`,
`GenusUnconditional.lean`) identifies the concrete two-chart Čech cokernel
`S.H1Cok` with the cover-free `HModule k _ 1` — for every `S` at once.
Composing two such identifications makes `Ȟ¹`-vanishing (equivalently,
surjectivity of the difference-of-restrictions map) independent of the chosen
cover (`AffineCoverMVSquare.surjective_moduleSectionDiff_of_surjective`), and
the fibre wrapper `Scheme.Hom.FiberH1Vanishing.surjective_moduleSectionDiff`
turns the ∃-form `FiberH1Vanishing` hypothesis of the pinned B3 statement into
the surjectivity witness on any prescribed cover of the fibre curve — the
`hindep` obligation of
`fiberH1Vanishing_pushforward_finiteMapToP1BaseChange_of_coverIndependence`
(`Picard/RigidPushforwardTransfer.lean`).

Sources: Stacks 01XB (degree 1), 01EW (the Čech splitting), 01HV(4)/01I8
(quasi-coherent sections localise); Hartshorne III.2.7, III.4.5; Leray's
theorem for 2-covers with `H¹`-acyclic pieces.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry Opposite

namespace AlgebraicGeometry.Scheme

variable {k : Type u} [CommRing k]

/-! ## The dialect bridge: the sheaf of `k`-modules underlying an `𝒪`-module

For a `Spec k`-scheme `C` and `M : C.left.Modules`, the sections `Γ(M, U)` are
modules over `Γ(C.left, U)`, hence `k`-modules by restriction along the
structure-morphism algebra map `k → Γ(C.left, U)`
(`toModuleKSheaf.algebraSection`).  Restriction maps are `k`-linear because
they are semilinear over the (algebra-map-preserving) ring restrictions.  This
mirrors `toModuleKPresheaf`/`toModuleKSheaf` with the structure sheaf replaced
by `M`. -/

/-- The `k`-module structure on the sections of a sheaf of modules on a
`Spec k`-scheme: restriction of the native `Γ(C.left, U)`-module structure
along the structure-morphism algebra map.  A `@[reducible] def` registered as
a local instance in this file (mirrors the discipline of
`Scheme.Hom.fiberSectionsModule`). -/
@[reducible] noncomputable def moduleKSections (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) (U : TopologicalSpace.Opens C.left.toTopCat) :
    Module k Γ(M, U) :=
  Module.compHom _ (algebraMap k Γ(C.left, U))

attribute [local instance] moduleKSections

/-- The native `Γ(C.left, W)`-scalar action on `Γ(M, W)`, packaged as a
function whose binders carry the section-notation types (so that the `•`
elaborates against the `Γ`-spelled `Module` instance regardless of the
spelling of the argument terms). -/
private noncomputable def smulSection (C : Over (Spec (CommRingCat.of k))) (M : C.left.Modules)
    (W : TopologicalSpace.Opens C.left.toTopCat)
    (s : Γ(C.left, W)) (z : Γ(M, W)) : Γ(M, W) :=
  s • z

/-- The underlying additive presheaf of `M : C.left.Modules` as a presheaf of
`k`-modules (`toModuleKPresheaf` with the structure sheaf replaced by `M`):
objects are the section groups with the `moduleKSections` `k`-action, maps are
the restriction maps of `M`. -/
noncomputable def toModuleKPresheafOfModules (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} k where
  obj U := ModuleCat.of k Γ(M, U.unop)
  map {U V} f := ModuleCat.ofHom
    { toFun := fun x => M.presheaf.map f x
      map_add' := fun x y => map_add _ x y
      map_smul' := fun r x =>
        (Scheme.Modules.map_smul M f.unop (algebraMap k Γ(C.left, U.unop) r) x).trans
          (congrArg
            (fun (s : Γ(C.left, V.unop)) =>
              smulSection C M V.unop s (M.presheaf.map (f.unop).op x))
            (AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality (C := C) f r)) }
  map_id U := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_id, LinearMap.id_coe, id_eq]
    exact congrFun (congrArg (fun (φ : M.presheaf.obj U ⟶ M.presheaf.obj U) =>
      (ConcreteCategory.hom φ : _ → _)) (M.presheaf.map_id U)) x
  map_comp {U V W} f g := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_comp, LinearMap.coe_comp, Function.comp_apply]
    exact congrFun (congrArg (fun (φ : M.presheaf.obj U ⟶ M.presheaf.obj W) =>
      (ConcreteCategory.hom φ : _ → _)) (M.presheaf.map_comp f g)) x

/-- The presheaf of `k`-modules of `toModuleKPresheafOfModules` is a sheaf:
its underlying type-valued presheaf is that of the (sheaf) `M`. -/
lemma toModuleKPresheafOfModules_isSheaf (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Presheaf.IsSheaf (Opens.grothendieckTopology C.left.toTopCat)
      (toModuleKPresheafOfModules C M) := by
  rw [Presheaf.isSheaf_iff_isSheaf_forget _ _ (CategoryTheory.forget (ModuleCat.{u} k))]
  convert (Presheaf.isSheaf_iff_isSheaf_forget _ _
      (CategoryTheory.forget AddCommGrpCat.{u})).mp (Scheme.Modules.isSheaf M) using 1 <;> rfl

/-- **The dialect bridge**: a sheaf of `𝒪`-modules on a `Spec k`-scheme,
viewed as a sheaf of `k`-modules (`toModuleKSheaf` with the structure sheaf
replaced by `M`).  Sections and restriction maps agree definitionally with
those of `M`. -/
noncomputable def toModuleKSheafOfModules (C : Over (Spec (CommRingCat.of k)))
    (M : C.left.Modules) :
    Sheaf (Opens.grothendieckTopology C.left.toTopCat) (ModuleCat.{u} k) :=
  ⟨toModuleKPresheafOfModules C M, toModuleKPresheafOfModules_isSheaf C M⟩

/-- Restriction maps of `toModuleKSheafOfModules C M` are the restriction maps
of `M` on elements.  Definitional. -/
lemma toModuleKSheafOfModules_obj_map_apply {C : Over (Spec (CommRingCat.of k))}
    (M : C.left.Modules) {V W : TopologicalSpace.Opens C.left.toTopCat} (h : W ≤ V)
    (x : (toModuleKSheafOfModules C M).obj.obj (Opposite.op V)) :
    ((toModuleKSheafOfModules C M).obj.map (homOfLE h).op).hom x
      = M.presheaf.map (homOfLE h).op x :=
  rfl

end AlgebraicGeometry.Scheme

/-! ## The quasi-coherent Čech section-identification kit

The module analogue of the structure-sheaf kit of
`CechCoboundarySplitting.lean` (`IsAffineOpen.dCoeffSectionsLinearEquiv` and
its `dCoface` compatibility): over an affine open `U`, the abstract localised
Čech coefficient `SectionCechModule.dCoeff g Γ(M, U) σ = Γ(M, U)_{g_σ}` of a
**quasi-coherent** `M : X.Modules` is `Γ(X, U)`-linearly the honest section
module `Γ(M, D(g_σ))`, with the Čech coface identified with the presheaf
restriction of `M`.  The quasi-coherence input is the gap2 keystone
`Scheme.Modules.isLocalizedModule_basicOpen` (Stacks 01HV(4)/01I8,
`Picard/QuotScheme.lean`).

The `Γ(X, U)`-module structure on `Γ(M, D(f))` is `Module.compHom` along the
canonical algebra map `Γ(X, U) → Γ(X, D(f))` (the presheaf restriction),
carried as a `letI` in each statement — the caller-supplied-instance
discipline of `restrictBasicOpenₗ`. -/

namespace AlgebraicGeometry

open AlgebraicGeometry.Scheme

variable {X : Scheme.{u}} {U : X.Opens}

/-- Double restriction of sections of a sheaf of modules collapses to the
single restriction (the `M.presheaf` analogue of
`map_homOfLE_map_homOfLE_apply`). -/
lemma Scheme.Modules.map_homOfLE_map_homOfLE_apply (M : X.Modules)
    {V W Z : X.Opens} (hVW : V ≤ W) (hWZ : W ≤ Z) (z : Γ(M, Z)) :
    M.presheaf.map (homOfLE hVW).op (M.presheaf.map (homOfLE hWZ).op z)
      = M.presheaf.map (homOfLE (hVW.trans hWZ)).op z := by
  rw [← CategoryTheory.comp_apply, ← M.presheaf.map_comp, ← op_comp, homOfLE_comp]

/-- The presheaf restriction of `M` between nested basic-open section modules,
as a `Γ(X, U)`-linear map for the `compHom` module structures.  The module
analogue of `Scheme.basicOpenResAlgHom`. -/
noncomputable def Scheme.Modules.basicOpenResₗ (M : X.Modules) {f₁ f₂ : Γ(X, U)}
    (h : X.basicOpen f₂ ≤ X.basicOpen f₁) :
    letI : Module Γ(X, U) Γ(M, X.basicOpen f₁) :=
      Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen f₁))
    letI : Module Γ(X, U) Γ(M, X.basicOpen f₂) :=
      Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen f₂))
    Γ(M, X.basicOpen f₁) →ₗ[Γ(X, U)] Γ(M, X.basicOpen f₂) :=
  letI : Module Γ(X, U) Γ(M, X.basicOpen f₁) :=
    Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen f₁))
  letI : Module Γ(X, U) Γ(M, X.basicOpen f₂) :=
    Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen f₂))
  { toFun := fun z => M.presheaf.map (homOfLE h).op z
    map_add' := fun z₁ z₂ => map_add _ z₁ z₂
    map_smul' := fun r z => by
      show M.presheaf.map (homOfLE h).op
            ((algebraMap Γ(X, U) Γ(X, X.basicOpen f₁) r) • z)
        = (algebraMap Γ(X, U) Γ(X, X.basicOpen f₂) r) •
            M.presheaf.map (homOfLE h).op z
      rw [Scheme.Modules.map_smul M (homOfLE h)
        (algebraMap Γ(X, U) Γ(X, X.basicOpen f₁) r) z]
      congr 1
      rw [Scheme.algebraMap_section_basicOpen, Scheme.algebraMap_section_basicOpen,
        ← CommRingCat.comp_apply, ← X.presheaf.map_comp, ← op_comp, homOfLE_comp] }

@[simp] lemma Scheme.Modules.basicOpenResₗ_apply (M : X.Modules) {f₁ f₂ : Γ(X, U)}
    (h : X.basicOpen f₂ ≤ X.basicOpen f₁) (z : Γ(M, X.basicOpen f₁)) :
    Scheme.Modules.basicOpenResₗ M h z = M.presheaf.map (homOfLE h).op z :=
  rfl

/-- **Čech coefficients of a quasi-coherent module are section modules**: over
an affine open `U`, the abstract Čech coefficient
`SectionCechModule.dCoeff g Γ(M, U) σ = Γ(M, U)_{g_σ}` of a quasi-coherent
`M : X.Modules` is `Γ(X, U)`-linearly the honest section module
`Γ(M, D(g_σ))`.  Sends `x/1` to the restriction of `x`
(`dCoeffModuleSectionsLinearEquiv_mk_one`) and intertwines the Čech coface
with the presheaf restriction of `M`
(`dCoeffModuleSectionsLinearEquiv_dCoface`).  This is the quasi-coherence
brick of the degree-one vanishing: the module analogue of
`IsAffineOpen.dCoeffSectionsLinearEquiv`, powered by the gap2 keystone
`Scheme.Modules.isLocalizedModule_basicOpen`. -/
noncomputable def IsAffineOpen.dCoeffModuleSectionsLinearEquiv (hU : IsAffineOpen U)
    (M : X.Modules) [M.IsQuasicoherent] {ι : Type*} (g : ι → Γ(X, U))
    {m : ℕ} (σ : Fin m → ι) :
    letI : Module Γ(X, U) Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
      Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ)))
    SectionCechModule.dCoeff g (Γ(M, U) : Type u) σ
      ≃ₗ[Γ(X, U)] Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
  letI : Module Γ(X, U) Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ)))
  letI : IsScalarTower Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ))
      Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  haveI := Scheme.Modules.isLocalizedModule_basicOpen M hU (CechLocalized.sprod g σ)
  IsLocalizedModule.iso (Submonoid.powers (CechLocalized.sprod g σ))
    (Scheme.Modules.restrictBasicOpenₗ M (CechLocalized.sprod g σ))

/-- The quasi-coherent section identification sends the localisation structure
map `x ↦ x/1` to the presheaf restriction `Γ(M, U) → Γ(M, D(g_σ))`. -/
@[simp] lemma IsAffineOpen.dCoeffModuleSectionsLinearEquiv_mk_one (hU : IsAffineOpen U)
    (M : X.Modules) [M.IsQuasicoherent] {ι : Type*} (g : ι → Γ(X, U))
    {m : ℕ} (σ : Fin m → ι) (x : Γ(M, U)) :
    hU.dCoeffModuleSectionsLinearEquiv M g σ (LocalizedModule.mk x 1)
      = M.presheaf.map
          (homOfLE (X.basicOpen_le (CechLocalized.sprod g σ))).op x := by
  letI : Module Γ(X, U) Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ)))
  letI : IsScalarTower Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ))
      Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  haveI := Scheme.Modules.isLocalizedModule_basicOpen M hU (CechLocalized.sprod g σ)
  exact IsLocalizedModule.iso_mk_one _ _ x

/-- **Coface = restriction, quasi-coherent form**: under the section
identification `dCoeffModuleSectionsLinearEquiv`, the Čech coface
`dCoface : Γ(M, U)_{g_{σ∘dⱼ}} → Γ(M, U)_{g_σ}` is the presheaf restriction
`Γ(M, D(g_{σ∘dⱼ})) → Γ(M, D(g_σ))` of `M` along `D(g_σ) ⊆ D(g_{σ∘dⱼ})`. -/
lemma IsAffineOpen.dCoeffModuleSectionsLinearEquiv_dCoface (hU : IsAffineOpen U)
    (M : X.Modules) [M.IsQuasicoherent] {ι : Type*} (g : ι → Γ(X, U))
    {m : ℕ} (σ : Fin (m + 1) → ι) (j : Fin (m + 1))
    (x : SectionCechModule.dCoeff g (Γ(M, U) : Type u) (σ ∘ j.succAbove)) :
    hU.dCoeffModuleSectionsLinearEquiv M g σ
        (SectionCechModule.dCoface g (Γ(M, U) : Type u) m σ j x)
      = M.presheaf.map (homOfLE (Scheme.basicOpen_le_basicOpen_of_dvd
            (CechLocalized.sprod_succAbove_dvd g σ j))).op
          (hU.dCoeffModuleSectionsLinearEquiv M g (σ ∘ j.succAbove) x) := by
  letI : Module Γ(X, U) Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    Module.compHom _ (algebraMap Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ)))
  letI : Module Γ(X, U) Γ(M, X.basicOpen (CechLocalized.sprod g (σ ∘ j.succAbove))) :=
    Module.compHom _
      (algebraMap Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g (σ ∘ j.succAbove))))
  letI : IsScalarTower Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g σ))
      Γ(M, X.basicOpen (CechLocalized.sprod g σ)) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  letI : IsScalarTower Γ(X, U) Γ(X, X.basicOpen (CechLocalized.sprod g (σ ∘ j.succAbove)))
      Γ(M, X.basicOpen (CechLocalized.sprod g (σ ∘ j.succAbove))) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  haveI instσ := Scheme.Modules.isLocalizedModule_basicOpen M hU (CechLocalized.sprod g σ)
  haveI instτ := Scheme.Modules.isLocalizedModule_basicOpen M hU
    (CechLocalized.sprod g (σ ∘ j.succAbove))
  have hdvd := CechLocalized.sprod_succAbove_dvd g σ j
  have key : (hU.dCoeffModuleSectionsLinearEquiv M g σ).toLinearMap
        ∘ₗ SectionCechModule.dCoface g (Γ(M, U) : Type u) m σ j
      = (Scheme.Modules.basicOpenResₗ M (Scheme.basicOpen_le_basicOpen_of_dvd hdvd))
        ∘ₗ (hU.dCoeffModuleSectionsLinearEquiv M g (σ ∘ j.succAbove)).toLinearMap := by
    apply IsLocalizedModule.ext
      (Submonoid.powers (CechLocalized.sprod g (σ ∘ j.succAbove)))
      (LocalizedModule.mkLinearMap _ _)
      ((AwayComparison.Inverts.of_dvd hdvd
        (Scheme.Modules.restrictBasicOpenₗ M (CechLocalized.sprod g σ))).isUnit_powers)
    ext y
    simp only [LinearMap.coe_comp, LinearEquiv.coe_coe, Function.comp_apply]
    rw [show (LocalizedModule.mkLinearMap
          (Submonoid.powers (CechLocalized.sprod g (σ ∘ j.succAbove)))
          (Γ(M, U) : Type u)) y
        = LocalizedModule.mk y 1 from rfl]
    rw [show SectionCechModule.dCoface g (Γ(M, U) : Type u) m σ j (LocalizedModule.mk y 1)
        = LocalizedModule.mk y 1 from
      AwayComparison.comparison_apply
        (LocalizedModule.mkLinearMap
          (Submonoid.powers (CechLocalized.sprod g (σ ∘ j.succAbove))) (Γ(M, U) : Type u))
        (LocalizedModule.mkLinearMap
          (Submonoid.powers (CechLocalized.sprod g σ)) (Γ(M, U) : Type u))
        (AwayComparison.Inverts.of_dvd (CechLocalized.sprod_succAbove_dvd g σ j)
          (LocalizedModule.mkLinearMap
            (Submonoid.powers (CechLocalized.sprod g σ)) (Γ(M, U) : Type u)))
        y]
    rw [hU.dCoeffModuleSectionsLinearEquiv_mk_one M g σ y,
      hU.dCoeffModuleSectionsLinearEquiv_mk_one M g (σ ∘ j.succAbove) y,
      Scheme.Modules.basicOpenResₗ_apply]
    exact (Scheme.Modules.map_homOfLE_map_homOfLE_apply M _ _ y).symm
  exact DFunLike.congr_fun key x

end AlgebraicGeometry
