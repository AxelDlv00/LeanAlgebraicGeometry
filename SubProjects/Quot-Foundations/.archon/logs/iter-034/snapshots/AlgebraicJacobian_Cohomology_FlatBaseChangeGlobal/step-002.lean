/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.FlatBaseChange

/-!
# Flat base change for the pushforward, global (`H⁰`-as-equalizer) chain

This file builds the global ("FBC-B") leg of the `i = 0` flat-base-change package:
`H⁰(X, F) = Γ(X, F)` of a quasi-compact, quasi-separated scheme is the equalizer of
a *finite* affine cover, and flat base change commutes with that finite equalizer.

It is the companion of `AlgebraicJacobian.Cohomology.FlatBaseChange`, which it imports
read-only (using the affine global-sections comparison as a per-term black box).

See `blueprint/src/chapters/Cohomology_FlatBaseChange.tex` (FBC-B section).
-/

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

/-! ## Project-local Mathlib supplement — finite affine covers with quasi-compact overlaps -/

/-- A quasi-compact scheme admits a *finite* affine open cover; when it is moreover
quasi-separated, every pairwise intersection of cover members is quasi-compact.

Project-local: packages `isCompact_iff_finite_and_eq_biUnion_affineOpens` (finite affine
subcover of `⊤`) with `quasiSeparatedSpace_iff_forall_affineOpens` (quasi-compact overlaps)
into the single combinatorial input feeding the finite sheaf-condition equalizer of the
`H⁰` flat-base-change argument. -/
theorem Scheme.exists_finite_affineCover_inter_isQuasiCompact (X : Scheme.{u})
    [CompactSpace X] [QuasiSeparatedSpace X] :
    ∃ s : Set X.affineOpens, s.Finite ∧ (⨆ i ∈ s, (i : X.Opens)) = ⊤ ∧
      ∀ U ∈ s, ∀ V ∈ s, IsCompact ((U : Set X) ∩ (V : Set X)) := by
  obtain ⟨s, hs, he⟩ :=
    (isCompact_iff_finite_and_eq_biUnion_affineOpens (U := (⊤ : X.Opens))).mp
      (by simpa using isCompact_univ (X := ↥X))
  refine ⟨s, hs, he.symm, ?_⟩
  intro U _ V _
  exact quasiSeparatedSpace_iff_forall_affineOpens.mp ‹_› U V

/-! ## Project-local Mathlib supplement — the global sections as a sheaf-condition equalizer -/

open TopCat.Presheaf SheafConditionEqualizerProducts in
/-- For `M : X.Modules` and any open cover `U : ι → X.Opens`, the sheaf-condition fork
of the underlying abelian-group presheaf of `M` is a limit (an equalizer of products):
```
Γ(M, ⨆ i, U i) ⟶ ∏ i, Γ(M, U i) ⇉ ∏ (i,j), Γ(M, U i ⊓ U j).
```
This is the equalizer-products form of the sheaf condition specialised to the abelian
presheaf `M.presheaf` of a sheaf of `𝒪_X`-modules. Combined with the finite affine cover
of `Scheme.exists_finite_affineCover_inter_isQuasiCompact` it computes `Γ(X, M) = Γ(M, ⊤)`
as a *finite* equalizer; that finiteness is what the flat-base-change argument needs to
commute `- ⊗_A B` past the equalizer.

Project-local: packages `M.isSheaf` through Mathlib's
`isSheaf_iff_isSheafEqualizerProducts` at the level of `X.Modules`. -/
noncomputable def Modules.gammaIsLimitSheafConditionFork {X : Scheme.{u}} (M : X.Modules)
    {ι : Type u} (U : ι → X.Opens) :
    IsLimit (fork M.presheaf U) :=
  ((isSheaf_iff_isSheafEqualizerProducts M.presheaf).mp M.isSheaf U).some

open TopCat.Presheaf SheafConditionEqualizerProducts in
/-- Consolidation of the two preceding supplements: for a quasi-compact, quasi-separated
scheme `X` and `M : X.Modules`, there is a *finite* affine open cover `U : ι → X.Opens`
(`ι` finite, each `U i` affine, `⨆ i, U i = ⊤`, all pairwise intersections quasi-compact)
for which `Γ(X, M) = Γ(M, ⊤)` is the equalizer of the finite sheaf-condition fork of `U`.

Project-local: combines `Scheme.exists_finite_affineCover_inter_isQuasiCompact` (L1) with
`Modules.gammaIsLimitSheafConditionFork` (L2) into the directly-usable "global sections as a
finite equalizer" input of the flat-base-change argument. -/
theorem Modules.exists_finite_affineCover_isLimit_sheafConditionFork (X : Scheme.{u})
    [CompactSpace X] [QuasiSeparatedSpace X] (M : X.Modules) :
    ∃ (ι : Type u) (_ : Finite ι) (U : ι → X.Opens),
      (∀ i, IsAffineOpen (U i)) ∧ (⨆ i, U i = ⊤) ∧
      (∀ i j, IsCompact ((U i : Set X) ∩ (U j : Set X))) ∧
      Nonempty (IsLimit (fork M.presheaf U)) := by
  obtain ⟨s, hs, hcov, hqc⟩ := X.exists_finite_affineCover_inter_isQuasiCompact
  have hfin : Finite ↥s := hs.to_subtype
  refine ⟨↥s, hfin, fun i => ((i : X.affineOpens) : X.Opens), fun i => i.1.2, ?_, ?_,
    ⟨Modules.gammaIsLimitSheafConditionFork M _⟩⟩
  · rw [← hcov, iSup_subtype']
  · rintro ⟨i, hi⟩ ⟨j, hj⟩
    exact hqc i hi j hj

/-! ## Project-local Mathlib supplement — global sections as an `A`-module `eqLocus`

This block presents `Γ(X, M)` of a sheaf of modules as a `LinearMap.eqLocus` of two
`A`-linear maps over the ground ring `A = Γ(X, ⊤)`, the shape required by
`LinearMap.tensorEqLocusEquiv` (flat base change preserves finite equalizers). Every
section over an open `U` is viewed as an `A`-module by restriction of scalars along the
structure-sheaf restriction `A → Γ(X, U)`, and the structure-sheaf restriction maps of
`M` become `A`-linear maps between these. -/

/-- The ground ring `A = Γ(X, ⊤)` of a scheme, as a `CommRing` (taken from the
`CommRingCat`-valued structure presheaf so the `CommRing`/`Algebra` instances resolve). -/
abbrev groundRing (X : Scheme.{u}) : Type u := X.presheaf.obj (Opposite.op (⊤ : X.Opens))

/-- The structure-sheaf restriction ring hom `A = Γ(X, ⊤) → Γ(X, U)`. Project-local:
the `A`-algebra structure on the sections over `U` used to view them as `A`-modules. -/
noncomputable def rhoU (X : Scheme.{u}) (U : X.Opens) :
    groundRing X →+* (X.ringCatSheaf.obj.obj (Opposite.op U)) :=
  (X.ringCatSheaf.obj.map (homOfLE (le_top)).op).hom

/-- The sections `Γ(M, U)` of a sheaf of modules over an open `U`, regarded as an
`A`-module (`A = Γ(X, ⊤)`) by restriction of scalars along `rhoU`. Project-local: the
common `A`-module home for the global-sections equalizer presentation. -/
noncomputable abbrev gammaModA {X : Scheme.{u}} (M : X.Modules) (U : X.Opens) :
    ModuleCat (groundRing X) :=
  (ModuleCat.restrictScalars (rhoU X U)).obj (M.val.obj (Opposite.op U))

/-- Restriction-of-scalars transitivity: `(Γ(X,U) → Γ(X,V)) ∘ (A → Γ(X,U)) = (A → Γ(X,V))`.
Project-local glue making the structure-sheaf restriction maps `A`-linear. -/
theorem rhoU_comp {X : Scheme.{u}} {U V : X.Opens} (h : V ≤ U) :
    ((X.ringCatSheaf.obj.map (homOfLE h).op).hom).comp (rhoU X U) = rhoU X V := by
  ext a
  change (X.ringCatSheaf.obj.map (homOfLE h).op).hom (rhoU X U a) = rhoU X V a
  have e : (X.ringCatSheaf.obj.map (homOfLE (le_top) : V ⟶ ⊤).op)
      = (X.ringCatSheaf.obj.map (homOfLE (le_top) : U ⟶ ⊤).op)
          ≫ (X.ringCatSheaf.obj.map (homOfLE h).op) := by
    rw [← X.ringCatSheaf.obj.map_comp]; rfl
  simp only [rhoU, e, RingCat.hom_comp]; rfl

/-- The structure-sheaf restriction `Γ(M, U) → Γ(M, V)` (`V ≤ U`) as a morphism of
`A`-modules, built from `M.val.map` by restriction of scalars. -/
noncomputable def gammaResAHom {X : Scheme.{u}} (M : X.Modules) {U V : X.Opens} (h : V ≤ U) :
    gammaModA M U ⟶ gammaModA M V :=
  (ModuleCat.restrictScalars (rhoU X U)).map (M.val.map (homOfLE h).op) ≫
    (ModuleCat.restrictScalarsComp'App (rhoU X U)
        (X.ringCatSheaf.obj.map (homOfLE h).op).hom (rhoU X V)
        (rhoU_comp h).symm (M.val.obj (Opposite.op V))).inv

/-- The structure-sheaf restriction `Γ(M, U) → Γ(M, V)` (`V ≤ U`) as an `A`-linear map.
Project-local: the building block of the `leftRes`/`rightRes` legs of the equalizer. -/
noncomputable def gammaResA {X : Scheme.{u}} (M : X.Modules) {U V : X.Opens} (h : V ≤ U) :
    gammaModA M U →ₗ[groundRing X] gammaModA M V := (gammaResAHom M h).hom

@[simp] theorem gammaResA_apply {X : Scheme.{u}} (M : X.Modules) {U V : X.Opens} (h : V ≤ U)
    (x : gammaModA M U) :
    gammaResA M h x = (M.val.map (homOfLE h).op).hom x := by
  simp only [gammaResA, gammaResAHom, ModuleCat.hom_comp, LinearMap.comp_apply,
    ModuleCat.restrictScalars.map_apply, ModuleCat.restrictScalarsComp'App_inv_apply]

/-- Functoriality of the `A`-linear restriction maps. -/
theorem gammaResA_comp {X : Scheme.{u}} (M : X.Modules) {U V W : X.Opens} (h1 : V ≤ U)
    (h2 : W ≤ V) (x : gammaModA M U) :
    gammaResA M h2 (gammaResA M h1 x) = gammaResA M (h2.trans h1) x := by
  simp only [gammaResA_apply]
  change (M.presheaf.map (homOfLE h2).op) ((M.presheaf.map (homOfLE h1).op) x)
     = (M.presheaf.map (homOfLE (h2.trans h1)).op) x
  rw [← CategoryTheory.ConcreteCategory.comp_apply, ← M.presheaf.map_comp]
  congr 1

end AlgebraicGeometry
