/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.RelPicFunctor

/-!
# The `Scheme.Modules.tensorObj` substrate (A.1.c.SubT)

This file is the **A.1.c.SubT** file-skeleton sub-build chapter for the
positive-genus arm of `nonempty_jacobianWitness`. It records the dedicated
substrate on which the abelian-group instance of the relative Picard quotient
`Pic^♯_{C/k}(T) := Pic(C ×_k T) / π_T^* Pic(T)` rests (the residual `sorry`
of `AlgebraicJacobian/Picard/RelPicFunctor.lean`).

The mathematics is straightforward; the obstacle to formalisation is purely
infrastructural. The Lean construction of the abelian-group law
`[L] + [L'] := [L ⊗ L']` on isomorphism classes of line bundles requires three
ingredients on the Lean carrier:

1. a binary tensor-product operation
   `⊗ : Scheme.Modules X × Scheme.Modules X → Scheme.Modules X`;
2. the structure sheaf `O_X` as a designated unit object for `⊗`;
3. an inverse operation on the full subcategory of invertible objects, i.e.
   the dual `L⁻¹ = Hom(L, O_X)` of an invertible sheaf.

At Mathlib's pinned commit (`b80f227`), only a presheaf-level version of (1)
is available (`PresheafOfModules.Monoidal.tensorObj`); (2) and (3) are present
as scheme-level objects, but the binary operation in (1) that ties them
together at the `Scheme.Modules` level is missing, and there is no
`MonoidalCategory` instance on `Scheme.Modules X`. This file records the
project-side substrate that supplies (1) and consequently lifts (2) + (3)
into a monoidal-category structure on `Scheme.Modules X`.

## Status (iter-202 Lane TS — file-skeleton scaffold)

This file is the **iter-202 Lane TS** file-skeleton: each of the 4 pinned
declarations carries the *intended* substantive type signature (matching the
blueprint `\lean{...}` pin in `chapters/Picard_TensorObjSubstrate.tex`) with a
`sorry` body. The bodies are iter-203+ work: the `tensorObj` definition lifts
`PresheafOfModules.Monoidal.tensorObj` through sheafification, and the consumer
`PicSharp.addCommGroup_via_tensorObj` then closes the residual `addCommGroup`
sorry of `RelPicFunctor.lean` L235.

The 4 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.Modules.tensorObj` (def) — the substrate binary
   operation `⊗ : Scheme.Modules X × Scheme.Modules X → Scheme.Modules X`,
   lifting `PresheafOfModules.Monoidal.tensorObj` on underlying presheaves
   composed with sheafification on the small Zariski site.
   Per blueprint `def:scheme_modules_tensorobj`.

2. `AlgebraicGeometry.Scheme.Modules.tensorObj_functoriality` (def) — the
   functorial action of `⊗` on morphisms: a pair `f : M ⟶ M'`, `g : N ⟶ N'`
   determines `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`.
   Per blueprint `lem:scheme_modules_tensorobj_functoriality`.

3. `AlgebraicGeometry.Scheme.Modules.monoidalCategory` (instance) — the
   monoidal-category structure on `Scheme.Modules X` with tensor `⊗`, unit
   `O_X`, associator, unitors, and braiding inherited from
   `PresheafOfModules.Monoidal` under sheafification.
   Per blueprint `thm:scheme_modules_monoidal`.

4. `AlgebraicGeometry.Scheme.PicSharp.addCommGroup_via_tensorObj` (def) — the
   `AddCommGroup` structure on the relative Picard quotient
   `Quotient (RelPicPresheaf.preimage_subgroup πC πT)`, built via the
   `tensorObj` substrate. This is the iter-204+ closure target for the Lane RPF
   L235/L266-269 `addCommGroup` residual sorry.
   Per blueprint `thm:rel_pic_addcommgroup_via_tensorobj`.

Plus (PUSH-BEYOND) the supporting helper lemmas of the lift section
(`lem:tensorobj_preserves_locally_trivial`,
`lem:tensorobj_inverse_invertible`, `lem:tensorobj_lift_onproduct`,
`lem:pullback_compatible_with_tensorobj`).

## References

Blueprint: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (740 LOC,
4 pins). Source: [Kleiman], "The Picard scheme", §2 (FGA Explained Ch.9 §9.2),
Defs. `df:aPf` + `df:Pfs`; Stacks tags 01CR (Picard group), 03DM (relative
tensor product of `O_X`-modules). Mathlib module
`Mathlib.CategoryTheory.Monoidal.PresheafOfModules`
(`PresheafOfModules.Monoidal.tensorObj`).
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

/-! ## Project-local Mathlib supplement — `restrictScalars` is lax monoidal

The presheaf-of-modules restriction-of-scalars functor along a morphism of
presheaves of *commutative* rings is lax monoidal. Mathlib ships the sectionwise
fact `ModuleCat.restrictScalars f` is `LaxMonoidal`
(`Mathlib.Algebra.Category.ModuleCat.Monoidal.Adjunction`); here we lift it to
the presheaf level through the sectionwise presheaf monoidal structure
(`PresheafOfModules.Monoidal`). This is the sole project-side ingredient feeding
the oplax comparison `δ` of `pullback φ` (the mate of `pushforward φ`) used to
close `tensorObj_restrict_iso`. Per blueprint `lem:restrictscalars_laxmonoidal`. -/

namespace PresheafOfModules

universe v'

variable {C : Type u} [Category.{v'} C] {R S : Cᵒᵖ ⥤ CommRingCat.{u}}

set_option backward.isDefEq.respectTransparency false in
/-- The lax-monoidal unit `ε` of `restrictScalars α`, assembled sectionwise from
`ModuleCat.restrictScalars (α.app X)`'s lax-monoidal unit. -/
noncomputable def restrictScalarsLaxε
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat) :
    (𝟙_ (PresheafOfModules.{u} (R ⋙ forget₂ _ _))) ⟶
      (restrictScalars α).obj (𝟙_ (PresheafOfModules.{u} (S ⋙ forget₂ _ _))) where
  app X := Functor.LaxMonoidal.ε (ModuleCat.restrictScalars (α.app X).hom)
  naturality {X Y} f := by
    ext r
    dsimp
    erw [PresheafOfModules.unit_map_one, ModuleCat.restrictScalars_η,
      ModuleCat.restrictScalars_η]
    simp only [map_one]
    erw [PresheafOfModules.unit_map_one]

set_option backward.isDefEq.respectTransparency false in
/-- The lax-monoidal tensorator `μ` of `restrictScalars α`, assembled sectionwise
from `ModuleCat.restrictScalars (α.app X)`'s lax-monoidal tensorator. -/
noncomputable def restrictScalarsLaxμ
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat)
    (M₁ M₂ : PresheafOfModules.{u} (S ⋙ forget₂ _ _)) :
    (restrictScalars α).obj M₁ ⊗ (restrictScalars α).obj M₂ ⟶
      (restrictScalars α).obj (M₁ ⊗ M₂) where
  app X := by
    exact Functor.LaxMonoidal.μ (ModuleCat.restrictScalars (α.app X).hom) (M₁.obj X) (M₂.obj X)
  naturality {X Y} f := by
    refine ModuleCat.MonoidalCategory.tensor_ext (fun m₁ m₂ ↦ ?_)
    dsimp
    erw [PresheafOfModules.Monoidal.tensorObj_map_tmul, ModuleCat.restrictScalars_μ_tmul,
      ModuleCat.restrictScalars_μ_tmul, PresheafOfModules.Monoidal.tensorObj_map_tmul]
    rfl

set_option backward.isDefEq.respectTransparency false in
/-- **`restrictScalars α` is lax monoidal** for a morphism `α` of presheaves of
commutative rings. Project-local lift of `ModuleCat.instLaxMonoidalRestrictScalars`. -/
noncomputable instance restrictScalarsLaxMonoidal
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat) :
    (PresheafOfModules.restrictScalars α).LaxMonoidal where
  ε := restrictScalarsLaxε α
  μ M₁ M₂ := restrictScalarsLaxμ α M₁ M₂
  μ_natural_left := by
    intro X Y f X'
    ext1 Z
    exact Functor.LaxMonoidal.μ_natural_left (F := ModuleCat.restrictScalars (α.app Z).hom)
      (f.app Z) (X'.obj Z)
  μ_natural_right := by
    intro X Y X' f
    ext1 Z
    exact Functor.LaxMonoidal.μ_natural_right (F := ModuleCat.restrictScalars (α.app Z).hom)
      (X'.obj Z) (f.app Z)
  associativity := by
    intro M N P
    ext1 Z
    exact Functor.LaxMonoidal.associativity (F := ModuleCat.restrictScalars (α.app Z).hom)
      (M.obj Z) (N.obj Z) (P.obj Z)
  left_unitality := by
    intro M
    ext1 Z
    exact Functor.LaxMonoidal.left_unitality (F := ModuleCat.restrictScalars (α.app Z).hom)
      (M.obj Z)
  right_unitality := by
    intro M
    ext1 Z
    exact Functor.LaxMonoidal.right_unitality (F := ModuleCat.restrictScalars (α.app Z).hom)
      (M.obj Z)

/-! ## Project-local Mathlib supplement — flat left-whiskering preserves the
sheafification localizer

The single non-formal ingredient of the `⊗`-invertibility associator
(`AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso`, blueprint
`lem:flat_whisker_localizer`): for a sectionwise-*flat* presheaf of modules `F`
and a morphism `g` that is locally injective / locally surjective for the
Grothendieck topology `J` (i.e. lies in the sheafification localizer `J.W`), the
left-whiskered morphism `F ◁ g` is again locally injective / surjective. Local
surjectivity is pure right-exactness of `⊗` (no flatness); local injectivity is
where sectionwise flatness enters, via `Module.Flat.lTensor_exact`. All
ingredients are present in Mathlib — the route uses **no** `MonoidalClosed`
structure. -/

section FlatWhisker

open MonoidalCategory CategoryTheory.Presheaf

variable {J : CategoryTheory.GrothendieckTopology C}

/-- Sectionwise computation: the underlying additive map of `(F ◁ g).app X` is
`LinearMap.lTensor (F.obj X) (g.app X).hom`, acting on a simple tensor by
`a ⊗ₜ b ↦ a ⊗ₜ g(b)`. -/
lemma toPresheaf_whiskerLeft_app_tmul
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (X : Cᵒᵖ)
    (a : F.obj X) (b : M.obj X) :
    (((toPresheaf _).map (F ◁ g)).app X).hom (a ⊗ₜ[(R.obj X)] b)
      = a ⊗ₜ[(R.obj X)] (g.app X).hom b := by
  erw [toPresheaf_map_app_apply]
  exact ModuleCat.MonoidalCategory.whiskerLeft_apply _ _ a b

/-- The underlying additive map of `(F ◁ g).app X` is `LinearMap.lTensor`. -/
lemma toPresheaf_whiskerLeft_app_apply
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (X : Cᵒᵖ)
    (z : (F ⊗ M).obj X) :
    (((toPresheaf _).map (F ◁ g)).app X).hom z
      = LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X) (g.app X).hom z := by
  erw [toPresheaf_map_app_apply, PresheafOfModules.whiskerLeft_app]

/-- **Local surjectivity is preserved by left-whiskering.** Right-exactness of
`⊗`: no flatness needed. Blueprint `lem:flat_whisker_localizer`, surjectivity
half. -/
lemma isLocallySurjective_whiskerLeft
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : IsLocallySurjective J g) :
    IsLocallySurjective J (F ◁ g) := by
  constructor
  intro U s
  induction s using TensorProduct.induction_on with
  | zero =>
      refine J.superset_covering ?_ (J.top_mem U)
      intro V i _
      exact ⟨0, by rw [map_zero]; exact (map_zero _).symm⟩
  | tmul a b =>
      refine J.superset_covering ?_ (hg.imageSieve_mem b)
      intro V i hi
      obtain ⟨c, hc⟩ := hi
      refine ⟨(F.map i.op).hom a ⊗ₜ[(R.obj (Opposite.op V))] c, ?_⟩
      rw [toPresheaf_whiskerLeft_app_tmul]
      erw [presheaf_map_apply_coe, PresheafOfModules.Monoidal.tensorObj_map_tmul]
      congr 1
  | add s t hs ht =>
      refine J.superset_covering ?_ (J.intersection_covering hs ht)
      intro V i hi
      obtain ⟨⟨ds, hds⟩, ⟨dt, hdt⟩⟩ := hi
      refine ⟨ds + dt, ?_⟩
      rw [map_add, hds, hdt]; exact (map_add _ s t).symm

/-- **Local injectivity is preserved by flat left-whiskering.** This is where
sectionwise flatness of `F` enters: via `Module.Flat.lTensor_exact` on the
kernel exact sequence `ker(gₓ) ↪ M(X) →gₓ N(X)`, an element of `ker(F ◁ g)` is
a sum of simple tensors with kernel entries, each of which restricts to `0` on a
covering sieve (local injectivity of `g`). Blueprint `lem:flat_whisker_localizer`,
injectivity half. -/
lemma isLocallyInjective_whiskerLeft_of_flat
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    [∀ X, Module.Flat (R.obj X) (F.obj X)]
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : IsLocallyInjective J g) :
    IsLocallyInjective J (F ◁ g) := by
  constructor
  intro X ξ η h
  -- View the sectionwise map of `g` as `R.obj X`-linear (the ring is commutative).
  let gl : ((M.obj X : ModuleCat _) : Type _) →ₗ[(R.obj X : CommRingCat)]
      ((N.obj X : ModuleCat _) : Type _) := (g.app X).hom
  -- `h` says `F ◁ g` agrees on `ξ, η`, i.e. `lTensor` kills `ξ - η`.
  have hδ : LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X) gl (ξ - η) = 0 := by
    have heq : LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X) gl ξ
        = LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X) gl η := by
      rw [← toPresheaf_whiskerLeft_app_apply, ← toPresheaf_whiskerLeft_app_apply]; exact h
    exact (map_sub (LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X) gl) ξ η).trans
      (sub_eq_zero.mpr heq)
  -- Flatness: `ker(F ⊗ gl) = range(F ⊗ ker.subtype)`, so `ξ - η` is a sum of simple
  -- tensors with kernel entries.
  have hex : Function.Exact
      (LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X) (LinearMap.ker gl).subtype)
      (LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X) gl) :=
    Module.Flat.lTensor_exact (F.obj X) (LinearMap.exact_subtype_ker_map gl)
  obtain ⟨ζ, hζ⟩ := (hex (ξ - η)).mp hδ
  -- Each simple tensor `a ⊗ k` with `gl k = 0` restricts to `0` on a covering sieve
  -- (local injectivity of `g`); induct on the witness `ζ`.
  have key : ∀ ζ : TensorProduct (R.obj X) (F.obj X) (LinearMap.ker gl),
      Presheaf.equalizerSieve (F := (toPresheaf _).obj (F ⊗ M)) (X := X)
        (LinearMap.lTensor (R := (R.obj X : CommRingCat)) (F.obj X)
          (LinearMap.ker gl).subtype ζ) 0 ∈ J X.unop := by
    intro ζ
    induction ζ using TensorProduct.induction_on with
    | zero =>
        rw [map_zero]
        exact J.superset_covering (Presheaf.equalizerSieve_self_eq_top _).ge (J.top_mem _)
    | tmul a kk =>
        rw [LinearMap.lTensor_tmul]
        have hk : ((toPresheaf _).map g).app X kk.1
            = ((toPresheaf _).map g).app X (0 : ((toPresheaf _).obj M).obj X) := by
          rw [map_zero]
          erw [toPresheaf_map_app_apply]
          exact kk.2
        refine J.superset_covering ?_ (hg.equalizerSieve_mem kk.1 0 hk)
        intro V f hf
        rw [Presheaf.equalizerSieve_apply] at hf ⊢
        rw [map_zero] at hf ⊢
        erw [presheaf_map_apply_coe, PresheafOfModules.Monoidal.tensorObj_map_tmul]
        erw [presheaf_map_apply_coe] at hf
        rw [Submodule.subtype_apply, hf]
        erw [TensorProduct.tmul_zero]; rfl
    | add ζ₁ ζ₂ h₁ h₂ =>
        rw [map_add]
        refine J.superset_covering ?_ (J.intersection_covering h₁ h₂)
        intro V f hf
        obtain ⟨hf1, hf2⟩ := hf
        rw [Presheaf.equalizerSieve_apply] at hf1 hf2 ⊢
        rw [map_zero] at hf1 hf2 ⊢
        exact (map_add _ _ _).trans (by rw [hf1, hf2, add_zero])
  -- Transport `equalizerSieve (ξ - η) 0 ∈ J` to `equalizerSieve ξ η ∈ J`.
  have hmain : Presheaf.equalizerSieve (F := (toPresheaf _).obj (F ⊗ M)) (X := X)
      (ξ - η) 0 ∈ J X.unop := hζ ▸ key ζ
  refine J.superset_covering ?_ hmain
  intro V f hf
  rw [Presheaf.equalizerSieve_apply] at hf ⊢
  rw [map_zero, map_sub, sub_eq_zero] at hf
  exact hf

/-- **Flat left-whiskering preserves the sheafification localizer.**
(Blueprint `lem:flat_whisker_localizer`.) For a sectionwise-flat presheaf of
modules `F` and a morphism `g` lying in the sheafification localizer `J.W` (the
class of morphisms inverted by sheafification, equivalently the locally bijective
ones via `WEqualsLocallyBijective`), the left-whiskered morphism `F ◁ g` again
lies in `J.W`. The two halves are `isLocallyInjective_whiskerLeft_of_flat` (where
flatness enters) and `isLocallySurjective_whiskerLeft` (pure right-exactness).
This is the single non-formal ingredient of the `⊗`-invertibility associator
`tensorObj_assoc_iso`; the route uses no `MonoidalClosed` structure. -/
lemma W_whiskerLeft_of_flat [J.WEqualsLocallyBijective Ab.{u}]
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    [∀ X, Module.Flat (R.obj X) (F.obj X)]
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : J.W ((toPresheaf _).map g)) :
    J.W ((toPresheaf _).map (F ◁ g)) := by
  rw [GrothendieckTopology.W_iff_isLocallyBijective] at hg ⊢
  exact ⟨isLocallyInjective_whiskerLeft_of_flat F g hg.1,
    isLocallySurjective_whiskerLeft F g hg.2⟩

end FlatWhisker

end PresheafOfModules

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! ## §1. The substrate tensor-product operation -/

/-- **The substrate operation `⊗` on `Scheme.Modules X`.**

For a scheme `X` and `M, N : X.Modules`, the tensor product
`M ⊗_X N : X.Modules` is the sheafification of the presheaf-of-modules tensor
product `PresheafOfModules.Monoidal.tensorObj` of the underlying presheaves of
`M` and `N` (affine-locally `(M ⊗_X N)(Spec A) = M(Spec A) ⊗_A N(Spec A)`).

Per blueprint `def:scheme_modules_tensorobj`. iter-202 Lane TS scaffold: the
body is a typed `sorry`; the iter-203+ body lifts
`PresheafOfModules.Monoidal.tensorObj` through the sheafification functor on
the small Zariski site of `X`. -/
noncomputable def tensorObj {X : Scheme.{u}} (M N : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val) :
    SheafOfModules X.ringCatSheaf)

/-- **Functoriality of `⊗_X`.**

A pair of morphisms `f : M ⟶ M'` and `g : N ⟶ N'` in `X.Modules` determines a
morphism `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`, compatible with identities
and composition; the assignment `(M, N) ↦ tensorObj M N` thereby extends to a
bifunctor `X.Modules × X.Modules ⥤ X.Modules` natural in both arguments.

Per blueprint `lem:scheme_modules_tensorobj_functoriality`. iter-202 Lane TS
scaffold: the body is a typed `sorry`; the iter-203+ body inherits the
morphism action from `PresheafOfModules.Monoidal.tensorObj` under
sheafification. -/
noncomputable def tensorObj_functoriality {X : Scheme.{u}} {M M' N N' : X.Modules}
    (f : M ⟶ M') (g : N ⟶ N') : tensorObj M N ⟶ tensorObj M' N' :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).map
    (MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) f.val g.val)

/-- **`⊗`-invertibility of an `𝒪_X`-module.** (Blueprint
`def:scheme_modules_isinvertible`.) `M : X.Modules` is `⊗`-invertible when it
admits a tensor inverse: an object `N` with `M ⊗_X N ≅ 𝒪_X`, where
`𝒪_X = SheafOfModules.unit X.ringCatSheaf` is the designated unit. This is the
scheme-level analogue of Mathlib's `Module.Invertible`; the predicate carries its
inverse witness existentially, so the dual needed by the relative Picard group
law is definitional. -/
def IsInvertible {X : Scheme.{u}} (M : X.Modules) : Prop :=
  ∃ N : X.Modules, Nonempty (tensorObj M N ≅ SheafOfModules.unit X.ringCatSheaf)

/-! ## §2. (Off the critical path) the full monoidal-category structure

iter-206 PIVOT: the full `MonoidalCategory (X.Modules)` instance is
**deliberately not built**. Per blueprint `rem:scheme_modules_monoidal_off_path`,
the relative Picard group law is a structure on *isomorphism classes* of line
bundles — every group axiom is a `Nonempty (… ≅ …)` proposition, so no monoidal
coherence (pentagon/triangle/hexagon) and no `MonoidalClosed` structure is ever
consumed. The earlier `monoidalCategory := sorry` instance (and the two
localization-transport supplements `isMonoidal_W_of_whiskerLeft`,
`monoidalCategoryOfIsMonoidalW`) routed through the verified-absent
`MonoidalClosed (PresheafOfModules R₀)` wall; they are removed here. The group
law is built directly on the line-bundle subcategory from the four
existence-of-iso lemmas below, mirroring Mathlib's `CommRing.Pic`. -/

/-! ## §3. The lift through `LineBundle.OnProduct` (PUSH-BEYOND supporting lemmas)

The following helper lemmas record the lift of the substrate to the
locally-trivial subcategory used by the relative Picard consumer. They are not
`\lean{...}`-pinned in the blueprint (their statements are descriptive); the
typed signatures here scaffold the iter-203+ bodies. -/

/-- **The substrate operation respects isomorphisms in both arguments.**

A pair of isomorphisms `e : M ≅ M'` and `e' : N ≅ N'` in `X.Modules` induces an
isomorphism `tensorObj M N ≅ tensorObj M' N'`, obtained by sheafifying the
tensor product (in the presheaf-of-modules monoidal category) of the underlying
presheaf isomorphisms `e.val`, `e'.val`. Its `hom` is
`tensorObj_functoriality e.hom e'.hom`. This is the reusable functor-of-isos
ingredient feeding `tensorObj_isLocallyTrivial`. -/
noncomputable def tensorObjIsoOfIso {X : Scheme.{u}} {M M' N N' : X.Modules}
    (e : M ≅ M') (e' : N ≅ N') : tensorObj M N ≅ tensorObj M' N' :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
    (MonoidalCategory.tensorIso
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
      ((SheafOfModules.forget X.ringCatSheaf).mapIso e)
      ((SheafOfModules.forget X.ringCatSheaf).mapIso e'))

/-- **The substrate tensor of the structure sheaf with itself is the structure
sheaf.**

`tensorObj 𝒪_X 𝒪_X ≅ 𝒪_X`, where `𝒪_X = SheafOfModules.unit X.ringCatSheaf` is the
designated unit object. Built from the presheaf-level left unitor
`λ_ (𝟙_)` (the unit of the `PresheafOfModules` monoidal category is exactly
`SheafOfModules.unit.val`) under sheafification, composed with the
sheafification-adjunction counit isomorphism on the (already-sheaf) unit. -/
noncomputable def tensorObj_unit_iso {X : Scheme.{u}} :
    tensorObj (SheafOfModules.unit X.ringCatSheaf) (SheafOfModules.unit X.ringCatSheaf)
      ≅ SheafOfModules.unit X.ringCatSheaf :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
      (λ_ (𝟙_ (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).counit).app
      (SheafOfModules.unit X.ringCatSheaf)

/-- **Left unitor for `⊗_X`.** `𝒪_X ⊗_X M ≅ M`. (Blueprint
`lem:tensorobj_unit_iso`, left half, `AlgebraicGeometry.Scheme.Modules.tensorObj_left_unitor`.)
Sheafification of the presheaf-level left unitor `λ_ M.val`, composed with the
sheafification counit identifying `sheafification M.val` with the (already-sheaf)
`M`. The cheap `mapIso` pattern; uses no abstract pullback. -/
noncomputable def tensorObj_left_unitor {X : Scheme.{u}} (M : X.Modules) :
    tensorObj (SheafOfModules.unit X.ringCatSheaf) M ≅ M :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
      ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).leftUnitor M.val) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).counit).app M

/-- **Right unitor for `⊗_X`.** `M ⊗_X 𝒪_X ≅ M`. (Blueprint
`lem:tensorobj_unit_iso`, right half, `AlgebraicGeometry.Scheme.Modules.tensorObj_right_unitor`.)
Sheafification of the presheaf-level right unitor `ρ_ M.val`, composed with the
sheafification counit. -/
noncomputable def tensorObj_right_unitor {X : Scheme.{u}} (M : X.Modules) :
    tensorObj M (SheafOfModules.unit X.ringCatSheaf) ≅ M :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
      ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).rightUnitor M.val) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.val)).counit).app M

/-- **Braiding for `⊗_X`.** `M ⊗_X N ≅ N ⊗_X M`. (Blueprint
`lem:tensorobj_comm_iso`, `AlgebraicGeometry.Scheme.Modules.tensorObj_braiding`.)
The presheaf-of-modules monoidal category is symmetric; its braiding `β_ M.val
N.val` sheafifies to the asserted isomorphism by the cheap `mapIso` pattern. -/
noncomputable def tensorObj_braiding {X : Scheme.{u}} (M N : X.Modules) :
    tensorObj M N ≅ tensorObj N M :=
  (PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).mapIso
    (BraidedCategory.braiding
      (C := _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) M.val N.val)

/-- **Associator for `⊗_X` on `⊗`-invertible objects.** (Blueprint
`lem:tensorobj_assoc_iso`, `AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso`.)
For `M, N, P` `⊗`-invertible (hence locally free of rank one, hence sectionwise
flat), there is an isomorphism `(M ⊗_X N) ⊗_X P ≅ M ⊗_X (N ⊗_X P)`. This is the
objectwise existence-of-iso datum the group law
`tensorObjIsoclassCommMonoid` consumes (associativity as a `Nonempty (… ≅ …)`).

iter-211 status (typed `sorry`, recipe scaffolded): the construction is the
three-step composite of the blueprint, absorbing the two nested sheafifications
with the flat-whiskering bridge `PresheafOfModules.W_whiskerLeft_of_flat` (proven
this iter — the go/no-go gate, CLEARED, no `MonoidalClosed`). Writing
`a = PresheafOfModules.sheafification`, `η = toSheafify` (the localizer unit), and
`α` the presheaf-of-modules associator:
  1. `a(η_{M.val ⊗ᵖ N.val} ▷ P.val)` is iso  (P flat ⇒ right-whiskered `η ∈ J.W`,
     by symmetry of `W_whiskerLeft_of_flat`; `a` inverts `J.W`), giving
     `(M ⊗ N) ⊗ P = a(a(M.val⊗N.val).val ⊗ P.val) ≅ a((M.val⊗N.val) ⊗ P.val)`;
  2. `a.mapIso α : a((M.val⊗N.val)⊗P.val) ≅ a(M.val⊗(N.val⊗P.val))`;
  3. `a(M.val ◁ η_{N.val ⊗ᵖ P.val})` is iso  (M flat), giving
     `a(M.val⊗(N.val⊗P.val)) ≅ a(M.val ⊗ a(N.val⊗P.val).val) = M ⊗ (N ⊗ P)`.
The single residual is the bridge `IsIso (a.map f)` from `J.W ((toPresheaf _).map
f)` (steps 1, 3): provable from `toPresheaf` reflecting isomorphisms + the
underlying `AddCommGrpCat`-sheafification localization
(`GrothendieckTopology.W_iff_isIso_map_of_adjunction` on the underlying
adjunction), plus the invertible ⇒ sectionwise-flat derivation feeding
`W_whiskerLeft_of_flat`. See task result for the precise residual. -/
noncomputable def tensorObj_assoc_iso {X : Scheme.{u}} {M N P : X.Modules}
    (hM : IsInvertible M) (hN : IsInvertible N) (hP : IsInvertible P) :
    tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P) :=
  sorry

/-- **Refining a trivialisation to a smaller open.** If `M` is trivialised on an
open `U` (`M.restrict U.ι ≅ 𝒪_U`), it is trivialised on every open `W ≤ U`.

The chart-chase is identical in spirit to `LineBundle.IsLocallyTrivial.pullback`:
factor `W.ι = (X.homOfLE hWU) ≫ U.ι`, transport through `restrictFunctorCongr`
and `restrictFunctorComp` to identify `M.restrict W.ι` with
`(M.restrict U.ι).restrict (X.homOfLE hWU)`, restrict the given trivialisation
`e` along that open immersion, and identify the restricted unit with the unit
via `restrictFunctorIsoPullback` + `pullbackObjUnitToUnit` (an isomorphism
because the open immersion's `Opens.map` is `Final`). -/
noncomputable def restrictIsoUnitOfLE {X : Scheme.{u}} {M : X.Modules} {U W : X.Opens}
    (hWU : W ≤ U)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (U : Scheme).ringCatSheaf) :
    M.restrict W.ι ≅ SheafOfModules.unit (W : Scheme).ringCatSheaf := by
  have hWU' : W ≤ (𝟙 X) ⁻¹ᵁ U := hWU
  set j : (W : Scheme) ⟶ (U : Scheme) := Scheme.Hom.resLE (𝟙 X) U W hWU' with hj
  have hjι : j ≫ U.ι = W.ι := by rw [hj, Scheme.Hom.resLE_comp_ι, Category.comp_id]
  haveI : (TopologicalSpace.Opens.map j.base).Final :=
    CategoryTheory.final_of_representablyFlat _
  -- M.restrict W.ι ≅ (pullback W.ι).obj M
  refine (Scheme.Modules.restrictFunctorIsoPullback W.ι).app M ≪≫ ?_
  -- ≅ (pullback (j ≫ U.ι)).obj M
  refine (Scheme.Modules.pullbackCongr hjι.symm).app M ≪≫ ?_
  -- ≅ (pullback j).obj ((pullback U.ι).obj M)
  refine (Scheme.Modules.pullbackComp j U.ι).symm.app M ≪≫ ?_
  -- ≅ (pullback j).obj (M.restrict U.ι)
  refine (Scheme.Modules.pullback j).mapIso
    ((Scheme.Modules.restrictFunctorIsoPullback U.ι).symm.app M) ≪≫ ?_
  -- ≅ (pullback j).obj 𝒪_U
  refine (Scheme.Modules.pullback j).mapIso e ≪≫ ?_
  -- ≅ 𝒪_W
  haveI hI : IsIso (SheafOfModules.pullbackObjUnitToUnit j.toRingCatSheafHom) := inferInstance
  exact @asIso _ _ _ _ _ hI

/-- **Substrate tensor commutes with restriction along an open immersion.**

For an open immersion `f : Y ⟶ X` and `M N : X.Modules`,
`(tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f)`.

This is the single missing-infrastructure ingredient of `A.1.c.SubT`. It says
the substrate `⊗` (sheafification of the presheaf-of-modules tensor) commutes
with the restriction functor `restrictFunctor f ≅ pullback f` along an open
immersion. Mathematically it factors as: (i) the presheaf-of-modules tensor
commutes with the pullback of presheaves (sectionwise this is the
extension-of-scalars identity
`B ⊗_A (P ⊗_A Q) ≅ (B ⊗_A P) ⊗_B (B ⊗_A Q)` for `A → B`, Stacks 03DM); and
(ii) sheafification commutes with pullback along an open immersion (the
restriction is exact and the small-Zariski sheafification is local). Neither is
in Mathlib at the `SheafOfModules` level (there is no monoidal structure on
`SheafOfModules`, hence no strong-monoidal pullback). A genuine construction
requires either the `Localization.Monoidal` transport of the monoidal structure
through `PresheafOfModules.sheafification.IsLocalization` together with
`W.IsMonoidal` for `W := (J.W).inverseImage (toPresheaf _)` (an instance NOT
present in Mathlib and the real residual obstacle), or a direct sectionwise
construction. Left as a named typed `sorry` feeding `tensorObj_isLocallyTrivial`;
see the task result for the precise missing instance statement. -/
noncomputable def tensorObj_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M N : X.Modules) :
    (tensorObj M N).restrict f ≅ tensorObj (M.restrict f) (N.restrict f) := by
  -- Step 1. Reduce `restrict` to `pullback` along the open immersion `f`
  -- (`restrictFunctorIsoPullback`, Mathlib).
  refine (Scheme.Modules.restrictFunctorIsoPullback f).app (tensorObj M N) ≪≫ ?_
  -- Step 2. **Sheafification commutes with pullback.** `tensorObj M N` is, by
  -- definition, `sheafification.obj (PresheafOfModules.Monoidal.tensorObj
  -- M.val N.val)`, so the genuine Mathlib lemma
  -- `SheafOfModules.sheafificationCompPullback`
  -- (`Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackContinuous`,
  -- `sheafification ⋙ pullback φ ≅ PresheafOfModules.pullback φ.hom ⋙
  -- sheafification`) moves the pullback *inside* the sheafification. This
  -- discharges half (ii) of the original obstruction (sheafification commuting
  -- with pullback). After it the goal is the purely **presheaf-level** residual
  -- `sheafify ((PresheafOfModules.pullback φ.hom).obj (M.val ⊗ N.val))
  --    ≅ (M.restrict f).tensorObj (N.restrict f)`.
  refine (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).app
      (PresheafOfModules.Monoidal.tensorObj M.val N.val) ≪≫ ?_
  -- Step 3. **Strip the outer sheafification.** Both sides are
  -- `PresheafOfModules.sheafification (𝟙 Y.ringCatSheaf.obj)` applied to a
  -- presheaf-of-modules: the LHS to `(pullback φ.hom).obj (M.val ⊗ₚ N.val)`, and
  -- the RHS `(M.restrict f).tensorObj (N.restrict f)` *by definition* to
  -- `(M.restrict f).val ⊗ₚ (N.restrict f).val`. So it suffices to give the
  -- comparison at the PRESHEAF level and sheafify it. This is a genuine reduction
  -- step (verified: the goal below has no sheafification).
  refine (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).mapIso ?_
  -- Step 4 (RESIDUAL — CORRECTED iter-208 analysis). The remaining presheaf goal is
  --   `(PresheafOfModules.pullback φ.hom).obj (M.val ⊗ₚ N.val)
  --      ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`
  -- where `φ.hom = (Scheme.Hom.toRingCatSheafHom f).hom` and `⊗ₚ =
  -- PresheafOfModules.Monoidal.tensorObj`. The Route-A recipe's claim that this is
  -- a "~30–60 LOC sectionwise unfolding of `pullback`" is INCORRECT:
  -- `PresheafOfModules.pullback` is the OPAQUE abstract left adjoint
  -- `(pushforward φ.hom).leftAdjoint` (`Presheaf/Pullback.lean:44`) — it has NO
  -- sectionwise formula, and the kaehler precedent (`analogies/...presheafpullback`
  -- Decision 5) EXCISED the analogous unfolding. The recipe conflates the opaque
  -- `pullback` with the CONCRETE `restrict`/`pushforward` (`restrict_obj` is `rfl`
  -- because `M.restrict f = restrictFunctor f = SheafOfModules.pushforward β`, NOT
  -- a pullback).
  --
  -- The genuine route needs TWO project-side ingredients, BOTH absent from Mathlib:
  --  (H1, the linchpin) a PRESHEAF-level iso `pushforward β.hom ≅ pullback φ.hom`,
  --      where `β.hom` is the open-immersion structure map of `restrictFunctor f`
  --      (so `(M.restrict f).val = (pushforward β.hom).obj M.val` definitionally).
  --      Obtain it via `Adjunction.leftAdjointUniq` from a presheaf-level
  --      `pushforward β.hom ⊣ pushforward φ.hom` — the presheaf analogue of the
  --      sheaf-level `SheafOfModules.pushforwardPushforwardAdj`
  --      (`Sheaf/PushforwardContinuous.lean:226`). That analogue needs presheaf-level
  --      `pushforwardNatTrans` and `pushforwardCongr` (only the SHEAF versions exist).
  --  (H2) the strong-monoidal comparison `(pushforward β.hom).obj (A ⊗ₚ B) ≅
  --      (pushforward β.hom).obj A ⊗ₚ (pushforward β.hom).obj B`. Since
  --      `pushforward = pushforward₀ ⋙ restrictScalars` (`Presheaf/Pushforward.lean:86`),
  --      `pushforward₀OfCommRingCat` is already `Monoidal`, and `β` is along the
  --      ring ISO `f.appIso`, this reduces to upgrading the file's lax
  --      `restrictScalarsLaxMonoidal` to STRONG via `Functor.Monoidal.ofLaxMonoidal`
  --      (`Monoidal/Functor.lean:718`) — needing `IsIso ε` (easy: `ε` is the ring
  --      map `f.appIso`, iso) and `IsIso μ`. The `μ`-iso bottoms out in the absent
  --      Mathlib lemma "`ModuleCat.restrictScalars` along a ring iso is strong
  --      monoidal" (`extendScalars` is `Monoidal` but `restrictScalars` is only
  --      `LaxMonoidal`, `Monoidal/Adjunction.lean`).
  -- Closure once both land:
  --   `(pullback φ.hom).obj (M.val ⊗ₚ N.val)`
  --      `≅[H1.symm] (pushforward β.hom).obj (M.val ⊗ₚ N.val)`
  --      `≅[H2] (pushforward β.hom M.val) ⊗ₚ (pushforward β.hom N.val)`
  --      `=defeq (M.restrict f).val ⊗ₚ (N.restrict f).val`.
  -- This is ~200–300 LOC across 4 absent ingredients — `mathlib-build` scale, NOT a
  -- single prove-mode close. See `informal/tensorObj_restrict_iso.md` for the full
  -- corrected decomposition with exact statements.
  sorry

/-- **Tensor product of locally-trivial modules is locally trivial.**

If `M, N : X.Modules` are locally trivial of rank one (line bundles), so is
their tensor product `tensorObj M N`. Per blueprint
`lem:tensorobj_preserves_locally_trivial`. The proof picks, for each point `x`,
a common affine open `W ∋ x` contained in trivialising opens `U` (for `M`) and
`U'` (for `N`), refines both trivialisations to `W` via `restrictIsoUnitOfLE`,
then transports through `tensorObj_restrict_iso`, the bifunctoriality
`tensorObjIsoOfIso`, and the unit isomorphism `tensorObj_unit_iso`:
`(M ⊗ N)|_W ≅ M|_W ⊗ N|_W ≅ 𝒪_W ⊗ 𝒪_W ≅ 𝒪_W`. The only residual gap is the
substrate-restriction compatibility `tensorObj_restrict_iso`. -/
lemma tensorObj_isLocallyTrivial {X : Scheme.{u}} {M N : X.Modules}
    (hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N) :
    LineBundle.IsLocallyTrivial (tensorObj M N) := by
  intro x
  obtain ⟨U, hxU, hU_aff, ⟨eM⟩⟩ := hM x
  obtain ⟨U', hxU', hU'_aff, ⟨eN⟩⟩ := hN x
  obtain ⟨W, hW_aff, hxW, hWsub⟩ :=
    exists_isAffineOpen_mem_and_subset (X := X) (x := x) (U := U ⊓ U') ⟨hxU, hxU'⟩
  have hWU : W ≤ U := le_trans hWsub inf_le_left
  have hWU' : W ≤ U' := le_trans hWsub inf_le_right
  refine ⟨W, hxW, hW_aff, ⟨?_⟩⟩
  exact tensorObj_restrict_iso W.ι M N ≪≫
    tensorObjIsoOfIso (restrictIsoUnitOfLE hWU eM) (restrictIsoUnitOfLE hWU' eN) ≪≫
    tensorObj_unit_iso

/-- **Inverse of an invertible module.**

Every line bundle `L : X.Modules` has a two-sided tensor inverse: there is a
locally-trivial `Linv : X.Modules` (the dual `L⁻¹ = Hom(L, O_X)`) together with
a tensor isomorphism `L ⊗_X Linv ≅ 𝒪_X`. Per blueprint
`lem:tensorobj_inverse_invertible`. iter-206 flat-pivot: the designated unit is
`SheafOfModules.unit X.ringCatSheaf = 𝒪_X` (the `MonoidalCategory` unit `𝟙_` is
no longer available — the full monoidal instance is off the critical path, see
§2). iter-202 Lane TS scaffold: typed `sorry`; the iter-203+ body builds the
dual and the contraction isomorphism, which is an isomorphism affine-locally on
a trivialising cover. -/
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf) :=
  sorry

/-- **Restriction of `⊗` to the `LineBundle.OnProduct` carrier.**

For `S`-schemes `C, T`, the bifunctor `⊗_{C ×_S T}` restricts to the subtype
`LineBundle.OnProduct πC πT` of locally-trivial modules on `C ×_S T`, with unit
the structure sheaf and the dual as two-sided inverse. Per blueprint
`lem:tensorobj_lift_onproduct`. iter-202 Lane TS scaffold: typed `sorry`. -/
noncomputable def tensorObjOnProduct {S C T : Scheme.{u}} (πC : C ⟶ S) (πT : T ⟶ S)
    (L L' : LineBundle.OnProduct πC πT) : LineBundle.OnProduct πC πT :=
  ⟨tensorObj L.carrier L'.carrier,
    tensorObj_isLocallyTrivial L.isLocallyTrivial L'.isLocallyTrivial⟩

end Modules

/-! ## §4. Consumer: the `AddCommGroup` instance on the relative Picard quotient -/

namespace PicSharp

/-- **Abelian-group structure on the relative Picard quotient via
`Scheme.Modules.tensorObj`.**

For a base scheme `S`, a curve-side morphism `πC : C ⟶ S`, and a test object
`πT : T ⟶ S`, the relative Picard quotient
`Quotient (RelPicPresheaf.preimage_subgroup πC πT) = Pic(C ×_S T) / π_T^* Pic(T)`
carries a canonical `AddCommGroup` structure with addition the descent of the
tensor product `[L] + [L'] := [L ⊗ L']` of `Scheme.Modules.tensorObj`, neutral
element `[O_{C ×_S T}]`, and inverse `-[L] := [L⁻¹]`.

Per blueprint `thm:rel_pic_addcommgroup_via_tensorobj`. iter-202 Lane TS
scaffold: typed `sorry`. This is the iter-204+ closure target for the residual
`addCommGroup` sorry of `RelPicFunctor.lean` (L235); once this body lands, the
RPF instance closes against it. It is supplied as a `def` (rather than a global
`instance`) to avoid an instance diamond with the existing typed-`sorry`
`PicSharp.addCommGroup` instance in `RelPicFunctor.lean`. -/
@[implicit_reducible]
noncomputable def addCommGroup_via_tensorObj {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) :=
  sorry

end PicSharp

end Scheme

end AlgebraicGeometry
