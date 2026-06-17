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

## Status (current)

`tensorObj` and `tensorObj_functoriality` are fully defined (no `sorry`), lifting
`PresheafOfModules.Monoidal.tensorObj` through sheafification on the small Zariski
site. The remaining typed-`sorry` residuals are the `⊗`-inverse lane
(`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) plus the route-(e)
whiskering residual `isLocallyInjective_whiskerLeft_of_W`; the dual block
(`InternalHom.internalHom`, `dual`, `evalLin`/`internalHomEvalApp`) is built
axiom-clean toward closing them. Once the inverse lands, the consumer
`PicSharp.addCommGroup_via_tensorObj` closes the residual `addCommGroup`
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

/-! ## Project-local Mathlib supplement — base change along a ring iso commutes
with `⊗` (the H2 "bottom gap" of `tensorObj_restrict_iso`)

For a *ring isomorphism* `e : R ≃+* S` and `S`-modules `A`, `B`, base change along
`e` (giving each `S`-module its `R`-module structure via `Module.compHom _ e.toRingHom`)
commutes with the tensor product: the canonical map `a ⊗ₜ[R] b ↦ a ⊗ₜ[S] b` is an
`R`-linear equivalence `A ⊗[R] B ≃ₗ[R] A ⊗[S] B`. Equivalently, `restrictScalars`
along a ring iso is *strong* monoidal — the lax tensorator is invertible. Mathlib
has `ModuleCat.extendScalars` strong monoidal but `restrictScalars` only
`LaxMonoidal`; this ring-iso strong upgrade is absent and is the documented "REAL
bottom gap" (H2) of `tensorObj_restrict_iso`. -/

section RestrictScalarsRingIsoTensor

open TensorProduct

variable {R S : Type u} [CommRing R] [CommRing S]

/-- The `R`-linear equivalence `A ⊗[R] B ≃ₗ[R] A ⊗[S] B` (`a ⊗ₜ b ↦ a ⊗ₜ b`),
where the `R`-module structures are base-changed along the ring iso `e : R ≃+* S`.
Base change along a ring iso commutes with `⊗`. -/
noncomputable def restrictScalarsRingIsoTensorEquiv (e : R ≃+* S)
    (A B : Type u) [AddCommGroup A] [Module S A] [AddCommGroup B] [Module S B] :
    letI _iA : Module R A := Module.compHom A e.toRingHom
    letI _iB : Module R B := Module.compHom B e.toRingHom
    letI _iT : Module R (TensorProduct S A B) := Module.compHom _ e.toRingHom
    TensorProduct R A B ≃ₗ[R] TensorProduct S A B := by
  letI _iA : Module R A := Module.compHom A e.toRingHom
  letI _iB : Module R B := Module.compHom B e.toRingHom
  letI _iT : Module R (TensorProduct S A B) := Module.compHom _ e.toRingHom
  -- Forward: `a ⊗ₜ[R] b ↦ a ⊗ₜ[S] b`, an `R`-bilinear-to-linear lift.
  let fwd : TensorProduct R A B →ₗ[R] TensorProduct S A B :=
    TensorProduct.lift
      { toFun := fun a =>
          { toFun := fun b => a ⊗ₜ[S] b
            map_add' := fun b b' => by rw [TensorProduct.tmul_add]
            map_smul' := fun r b => by
              simp only [RingHom.id_apply]
              change a ⊗ₜ[S] (e r • b) = e r • (a ⊗ₜ[S] b)
              rw [TensorProduct.tmul_smul] }
        map_add' := fun a a' => by ext b; simp [TensorProduct.add_tmul]
        map_smul' := fun r a => by
          ext b
          simp only [RingHom.id_apply, LinearMap.smul_apply, LinearMap.coe_mk,
            AddHom.coe_mk]
          change (e r • a) ⊗ₜ[S] b = e r • (a ⊗ₜ[S] b)
          rw [TensorProduct.smul_tmul', TensorProduct.smul_tmul] }
  -- Inverse: `a ⊗ₜ[S] b ↦ a ⊗ₜ[R] b`. Built as an additive lift out of the
  -- `S`-tensor (scalar-swap compatibility uses `s • a = e.symm s •ᵣ a`), then
  -- shown `R`-linear (`R` acting on the `S`-tensor via `e`).
  let bwdAdd : TensorProduct S A B →+ TensorProduct R A B :=
    TensorProduct.liftAddHom
      { toFun := fun a =>
          { toFun := fun b => a ⊗ₜ[R] b
            map_zero' := by rw [TensorProduct.tmul_zero]
            map_add' := fun b b' => by rw [TensorProduct.tmul_add] }
        map_zero' := by ext b; simp [TensorProduct.zero_tmul]
        map_add' := fun a a' => by ext b; simp [TensorProduct.add_tmul] }
      (fun s a b => by
        simp only [AddMonoidHom.coe_mk, ZeroHom.coe_mk]
        -- `(s • a) ⊗ₜ[R] b = a ⊗ₜ[R] (s • b)`; move the `S`-scalar through `e.symm`.
        have hsa : (s • a) = (e.symm s : R) • a := by
          change s • a = e (e.symm s) • a; rw [e.apply_symm_apply]
        have hsb : (s • b) = (e.symm s : R) • b := by
          change s • b = e (e.symm s) • b; rw [e.apply_symm_apply]
        rw [hsa, hsb]; exact TensorProduct.smul_tmul _ _ _ )
  let bwd : TensorProduct S A B →ₗ[R] TensorProduct R A B :=
    { toFun := bwdAdd
      map_add' := bwdAdd.map_add
      map_smul' := fun r x => by
        simp only [RingHom.id_apply]
        -- `R` acts on the `S`-tensor via `e`; reduce to additive `S`-scalar action.
        change bwdAdd (e r • x) = r • bwdAdd x
        induction x using TensorProduct.induction_on with
        | zero => simp
        | tmul a b =>
            rw [TensorProduct.smul_tmul']
            change (e r • a) ⊗ₜ[R] b = r • (a ⊗ₜ[R] b)
            rw [TensorProduct.smul_tmul']
            rfl
        | add x y hx hy =>
            rw [smul_add, map_add, map_add, hx, hy, smul_add] }
  refine LinearEquiv.ofLinear fwd bwd ?_ ?_
  · -- right inverse `fwd ∘ bwd = id`. The composite is `R`-linear over the
    -- `S`-tensor, so check on additive generators by induction.
    refine LinearMap.ext fun x => ?_
    simp only [LinearMap.coe_comp, Function.comp_apply, LinearMap.id_coe, id_eq]
    induction x using TensorProduct.induction_on with
    | zero => simp
    | tmul a b =>
        change fwd (bwdAdd (a ⊗ₜ[S] b)) = a ⊗ₜ[S] b
        change fwd (a ⊗ₜ[R] b) = a ⊗ₜ[S] b
        simp only [fwd, TensorProduct.lift.tmul, LinearMap.coe_mk, AddHom.coe_mk]
    | add x y hx hy => rw [map_add bwd, map_add fwd, hx, hy]
  · -- left inverse `bwd ∘ fwd = id` on `a ⊗ₜ[R] b` (composite `R`-linear over the
    -- `R`-tensor, so `TensorProduct.ext'` applies).
    refine TensorProduct.ext' fun a b => ?_
    change bwdAdd (fwd (a ⊗ₜ[R] b)) = a ⊗ₜ[R] b
    change bwdAdd (a ⊗ₜ[S] b) = a ⊗ₜ[R] b
    rfl

/-- The forward map of `restrictScalarsRingIsoTensorEquiv` on a simple tensor:
`a ⊗ₜ[R] b ↦ a ⊗ₜ[S] b`. -/
@[simp] lemma restrictScalarsRingIsoTensorEquiv_apply_tmul (e : R ≃+* S)
    (A B : Type u) [AddCommGroup A] [Module S A] [AddCommGroup B] [Module S B] (a : A) (b : B) :
    letI _iA : Module R A := Module.compHom A e.toRingHom
    letI _iB : Module R B := Module.compHom B e.toRingHom
    letI _iT : Module R (TensorProduct S A B) := Module.compHom _ e.toRingHom
    restrictScalarsRingIsoTensorEquiv e A B (a ⊗ₜ[R] b) = a ⊗ₜ[S] b := by
  letI _iA : Module R A := Module.compHom A e.toRingHom
  letI _iB : Module R B := Module.compHom B e.toRingHom
  letI _iT : Module R (TensorProduct S A B) := Module.compHom _ e.toRingHom
  simp only [restrictScalarsRingIsoTensorEquiv, LinearEquiv.ofLinear_apply,
    TensorProduct.lift.tmul, LinearMap.coe_mk, AddHom.coe_mk]

/-- **`ModuleCat.restrictScalars` along a ring isomorphism is strong monoidal: the
lax tensorator `μ` is an isomorphism.** This is the "REAL bottom gap" (H2) of
`tensorObj_restrict_iso`. For a ring iso `e : R ≃+* S` and `S`-modules `M₁, M₂`,
the underlying map of the lax tensorator
`μ : restrictScalars(M₁) ⊗_R restrictScalars(M₂) ⟶ restrictScalars(M₁ ⊗_S M₂)`
sends `m₁ ⊗ₜ m₂ ↦ m₁ ⊗ₜ m₂` (`ModuleCat.restrictScalars_μ_tmul`), which is exactly
the forward `R`-linear equivalence `restrictScalarsRingIsoTensorEquiv e`, hence is
bijective, hence an isomorphism. Mathlib has `extendScalars` strong monoidal but
only `restrictScalars` lax; this ring-iso strong upgrade is the documented absent
ingredient. -/
lemma restrictScalars_isIso_μ (e : R ≃+* S) (M₁ M₂ : ModuleCat.{u} S) :
    IsIso (Functor.LaxMonoidal.μ (ModuleCat.restrictScalars e.toRingHom) M₁ M₂) := by
  rw [ConcreteCategory.isIso_iff_bijective]
  have hfun : ⇑(Functor.LaxMonoidal.μ (ModuleCat.restrictScalars e.toRingHom) M₁ M₂)
      = ⇑(restrictScalarsRingIsoTensorEquiv e M₁ M₂) := by
    ext z
    induction z using TensorProduct.induction_on with
    | zero => rw [map_zero]; exact (map_zero _).symm
    | tmul a b =>
        erw [ModuleCat.restrictScalars_μ_tmul]
        exact (restrictScalarsRingIsoTensorEquiv_apply_tmul e M₁ M₂ a b).symm
    | add x y hx hy => rw [map_add, hx, hy]; exact (map_add _ x y).symm
  rw [hfun]
  exact (restrictScalarsRingIsoTensorEquiv e M₁ M₂).bijective

/-- **The lax-monoidal unit `ε` of `restrictScalars` along a ring iso is an
isomorphism.** Its underlying map is the ring map `e` (`ModuleCat.restrictScalars_η`),
which is bijective since `e` is a ring equivalence. -/
lemma restrictScalars_isIso_ε (e : R ≃+* S) :
    IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars e.toRingHom)) := by
  rw [ConcreteCategory.isIso_iff_bijective]
  have hfun : ⇑(Functor.LaxMonoidal.ε (ModuleCat.restrictScalars e.toRingHom)) = ⇑e := by
    ext r
    exact ModuleCat.restrictScalars_η (f := e.toRingHom) r
  rw [hfun]
  exact e.bijective

/-- **`ModuleCat.restrictScalars` along a ring isomorphism is (strong) monoidal.**
The packaged `Functor.Monoidal` structure obtained from the lax structure by
inverting `ε` (`restrictScalars_isIso_ε`) and `μ` (`restrictScalars_isIso_μ`). This
is the clean, reusable strong-monoidal upgrade that Mathlib provides for
`extendScalars` but not `restrictScalars`; it is the ModuleCat-level core of the H2
ingredient of `tensorObj_restrict_iso`. -/
@[implicit_reducible]
noncomputable def restrictScalarsMonoidalOfRingEquiv (e : R ≃+* S) :
    (ModuleCat.restrictScalars e.toRingHom).Monoidal := by
  haveI : IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars e.toRingHom)) :=
    restrictScalars_isIso_ε e
  haveI : ∀ M₁ M₂, IsIso (Functor.LaxMonoidal.μ (ModuleCat.restrictScalars e.toRingHom) M₁ M₂) :=
    fun M₁ M₂ => restrictScalars_isIso_μ e M₁ M₂
  exact Functor.Monoidal.ofLaxMonoidal _

/-- **Bijective-ring-hom form of the strong-monoidal tensorator.** For an arbitrary
*bijective* ring hom `f : R →+* S`, the lax tensorator of `ModuleCat.restrictScalars f`
is an isomorphism. This is the form consumed by the presheaf-level lift, where the
componentwise ring map `(α.app X).hom` of a `NatIso` of ring presheaves is bijective
but not literally presented as `(_ : R ≃+* S).toRingHom`. -/
lemma restrictScalars_isIso_μ_of_bijective (f : R →+* S) (hf : Function.Bijective f)
    (M₁ M₂ : ModuleCat.{u} S) :
    IsIso (Functor.LaxMonoidal.μ (ModuleCat.restrictScalars f) M₁ M₂) := by
  have hfe : f = (RingEquiv.ofBijective f hf).toRingHom := RingHom.ext fun _ => rfl
  rw [hfe]
  exact restrictScalars_isIso_μ (RingEquiv.ofBijective f hf) M₁ M₂

/-- **Bijective-ring-hom form of the strong-monoidal unit.** Companion of
`restrictScalars_isIso_μ_of_bijective` for the lax unit `ε`. -/
lemma restrictScalars_isIso_ε_of_bijective (f : R →+* S) (hf : Function.Bijective f) :
    IsIso (Functor.LaxMonoidal.ε (ModuleCat.restrictScalars f)) := by
  have hfe : f = (RingEquiv.ofBijective f hf).toRingHom := RingHom.ext fun _ => rfl
  rw [hfe]
  exact restrictScalars_isIso_ε (RingEquiv.ofBijective f hf)

end RestrictScalarsRingIsoTensor

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

/-- **Flat right-whiskering preserves the sheafification localizer.** The
braiding-conjugate of `W_whiskerLeft_of_flat`: for a sectionwise-flat presheaf of
modules `F` and a morphism `g` in the sheafification localizer `J.W`, the
right-whiskered morphism `g ▷ F` again lies in `J.W`. Obtained from the
left-whiskered statement by conjugating with the (iso) braiding of the symmetric
presheaf-of-modules monoidal structure, using that `J.W` respects isomorphisms. -/
lemma W_whiskerRight_of_flat [J.WEqualsLocallyBijective Ab.{u}]
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    [∀ X, Module.Flat (R.obj X) (F.obj X)]
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : J.W ((toPresheaf _).map g)) :
    J.W ((toPresheaf _).map (g ▷ F)) := by
  have hwl := W_whiskerLeft_of_flat F g hg
  -- `g ▷ F = (β_ M F).hom ≫ (F ◁ g) ≫ (β_ N F).inv` by braiding naturality.
  have hconj : g ▷ F
      = (BraidedCategory.braiding M F).hom ≫ (F ◁ g) ≫ (BraidedCategory.braiding N F).inv := by
    rw [← Category.assoc, ← BraidedCategory.braiding_naturality_left g F, Category.assoc,
      Iso.hom_inv_id, Category.comp_id]
  rw [hconj, Functor.map_comp, Functor.map_comp]
  -- `J.W` respects isos on both sides (it is the sheafification localizer).
  rw [(J.W).cancel_left_of_respectsIso, (J.W).cancel_right_of_respectsIso]
  exact hwl

/-! ## Project-local Mathlib supplement — flatness-FREE whiskering of a locally
bijective morphism (ROUTE (d), the live associator realization)

The flat whiskering above (`W_whisker{Left,Right}_of_flat`) needs the SECTIONWISE
flatness instance `∀ U, Module.Flat (R(U)) (F(U))`, which is FALSE for invertible
sheaves over non-affine opens and is therefore OFF the associator critical path
(iter-212 finding). The associator only ever whiskers the sheafification UNIT
`η = toSheafify`, which is **locally bijective** (`∈ J.W`), not merely locally
injective. Whiskering a *locally bijective* `g` by an *arbitrary* `F` preserves
local bijectivity with NO flatness hypothesis: stalkwise `(F ◁ g)_x = id_{F_x}
⊗_{R_x} g_x`, and since `g_x` is an isomorphism (a `J.W`-map is a stalkwise iso on
the topological site, `Sites.Point.IsMonoidalW` / `TopCat.hasEnoughPoints`), the
tensor `id ⊗ g_x` is again an isomorphism — no flatness, because *isomorphisms*
tensor to isomorphisms whereas mere *injections* need flatness. This is exactly the
flatness-free technique Mathlib blesses for `J.W.IsMonoidal` via enough points
(analogist `ts-monoidal213.md`, route (d)). -/

section WhiskerOfW

open MonoidalCategory CategoryTheory.Presheaf

variable {J : CategoryTheory.GrothendieckTopology C}

/-- **Whiskering a locally bijective morphism preserves local injectivity
(flatness-free).** For an *arbitrary* presheaf of modules `F` and a morphism `g`
whose underlying additive-presheaf map is locally bijective (`∈ J.W`), the
left-whiskered morphism `F ◁ g` is locally injective.

This is the single residual ingredient of the associator
`tensorObj_assoc_iso` under ROUTE (d). The mathematics is the stalkwise computation
`(F ◁ g)_x = id_{F_x} ⊗_{R_x} g_x`: a `J.W`-morphism on the topological site of `X`
is a *stalkwise isomorphism* (`TopCat.hasEnoughPoints` + the conservative-family
characterisation `hP.W_iff`, `Mathlib.CategoryTheory.Sites.Point.*`, 2026), and
tensoring an isomorphism `g_x` by `id_{F_x}` yields an isomorphism, so `F ◁ g` is a
stalkwise iso, hence locally bijective, hence locally injective — for *any* `F`,
needing NEITHER sectionwise flatness NOR local triviality of `F`.

The two Mathlib-side ingredients this stalkwise argument needs are
(d.1) the stalkwise characterisation of the module-level `J.W` on `Opens X` and
(d.2) the commutation `(A ⊗ᵖ B)_x ≅ A_x ⊗_{R_x} B_x` of the stalk with the
presheaf-of-modules tensor (stalk = filtered colimit, and `tensorLeft`/`tensorRight`
preserve filtered colimits over a module category). Neither ships at the
`PresheafOfModules` level at the pinned commit; porting them is the genuine residual
(analogist `ts-monoidal213.md`, Decision 3, porting ingredients d.1/d.2). Stated
here with its substantive intended type so the rest of the associator closes against
it; see the task result for the precise missing Mathlib statements. -/
lemma isLocallyInjective_whiskerLeft_of_W [J.WEqualsLocallyBijective Ab.{u}]
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : J.W ((toPresheaf _).map g)) :
    IsLocallyInjective J (F ◁ g) := by
  -- ROUTE (e) residual: `(F ◁ g)_x = id_{F_x} ⊗ g_x` is an iso since `g_x` is
  -- (a `J.W`-map is a stalkwise iso); tensoring by `id` of an iso is flatness-free.
  --
  -- iter-214 CORRECTION (Step 0 + d.1 partial): the module-level stalk is NOT
  -- Mathlib-absent — `Mathlib.Algebra.Category.ModuleCat.Stalk` supplies, for
  -- `X : TopCat`, `R : X.Presheaf CommRingCat`, the stalk module
  -- `Module (R.stalk x) ↑(TopCat.Presheaf.stalk M.presheaf x)` and `germ_smul`. The
  -- linear-stalk-map packaging (ingredient d.1) is now built project-side:
  -- `PresheafOfModules.stalkLinearMap` (+ `stalkLinearMap_germ`,
  -- `stalkLinearMap_bijective_of_isIso`), all axiom-clean.
  --
  -- The TWO residual gaps to close this sorry (both require SPECIALISING this lemma
  -- to the topological site `C = Opens X` — the general-site statement here has no
  -- stalks; decl is UNPROTECTED so the specialisation is free, and the only consumer
  -- `tensorObj_assoc_iso` already works over `Opens.grothendieckTopology X`):
  --   (d.1-bridge) `(Opens.grothendieckTopology X).W (toPresheaf-image) ↔ ∀ x,
  --     IsIso (stalkFunctor Ab x map)` — assemble from `HasEnoughPoints
  --     (Opens.grothendieckTopology X)` (`Mathlib/Topology/Sheaves/Points.lean`) +
  --     `W_iff`, OR from `WEqualsLocallyBijective` + the TopCat criteria
  --     `locally_surjective_iff_surjective_on_stalks` /
  --     `app_injective_iff_stalkFunctor_map_injective`
  --     (needs `presheafFiber ≅ TopCat.Presheaf.stalk`, the Mathlib TODO bridge).
  --   (d.2) stalk ⊗ commutation `(F ⊗ᵖ M)_x ≅ F_x ⊗_{R_x} M_x` naturally identifying
  --     `(F ◁ g)_x` with `LinearMap.lTensor F_x (stalkLinearMap g x)` — "tensor
  --     commutes with the filtered colimit defining the stalk" over the varying ring;
  --     genuinely Mathlib-absent (largest piece). Then `stalkLinearMap_bijective_of_isIso`
  --     + `LinearEquiv.lTensor` finish (flatness-free). See task result for full decomp.
  sorry

/-- **Flatness-free left-whiskering preserves the sheafification localizer.** The
ROUTE (d) replacement for `W_whiskerLeft_of_flat`: for an *arbitrary* `F` and a
locally bijective `g` (`∈ J.W`), the left-whiskered `F ◁ g` again lies in `J.W`.
Local surjectivity is free (`isLocallySurjective_whiskerLeft`, right-exactness);
local injectivity is the flatness-free stalkwise residual
`isLocallyInjective_whiskerLeft_of_W`. No flatness, no local triviality. -/
lemma W_whiskerLeft_of_W [J.WEqualsLocallyBijective Ab.{u}]
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : J.W ((toPresheaf _).map g)) :
    J.W ((toPresheaf _).map (F ◁ g)) := by
  have hbij := hg
  rw [GrothendieckTopology.W_iff_isLocallyBijective] at hbij
  rw [GrothendieckTopology.W_iff_isLocallyBijective]
  exact ⟨isLocallyInjective_whiskerLeft_of_W F g hg,
    isLocallySurjective_whiskerLeft F g hbij.2⟩

/-- **Flatness-free right-whiskering preserves the sheafification localizer.** The
braiding-conjugate of `W_whiskerLeft_of_W`, mirroring `W_whiskerRight_of_flat`. -/
lemma W_whiskerRight_of_W [J.WEqualsLocallyBijective Ab.{u}]
    (F : PresheafOfModules.{u} (R ⋙ forget₂ _ _))
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N)
    (hg : J.W ((toPresheaf _).map g)) :
    J.W ((toPresheaf _).map (g ▷ F)) := by
  have hwl := W_whiskerLeft_of_W F g hg
  have hconj : g ▷ F
      = (BraidedCategory.braiding M F).hom ≫ (F ◁ g) ≫ (BraidedCategory.braiding N F).inv := by
    rw [← Category.assoc, ← BraidedCategory.braiding_naturality_left g F, Category.assoc,
      Iso.hom_inv_id, Category.comp_id]
  rw [hconj, Functor.map_comp, Functor.map_comp]
  rw [(J.W).cancel_left_of_respectsIso, (J.W).cancel_right_of_respectsIso]
  exact hwl

end WhiskerOfW

/-- **The sheafification-localization bridge.** A morphism `f` of presheaves of
modules whose underlying additive-presheaf map lies in the sheafification localizer
`J.W` is sent by the associated-sheaf-of-modules functor to an isomorphism. This is
the single residual of the `⊗`-invertibility associator
`AlgebraicGeometry.Scheme.Modules.tensorObj_assoc_iso`. It is the morphism-property
identity `PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`
(the sheafification functor *is* the localization at `J.W.inverseImage (toPresheaf _)`)
read at a single morphism. -/
lemma isIso_sheafification_map_of_W
    {R₀ : Cᵒᵖ ⥤ RingCat} {Rsh : CategoryTheory.Sheaf J RingCat} (α : R₀ ⟶ Rsh.obj)
    [Presheaf.IsLocallyInjective J α] [Presheaf.IsLocallySurjective J α]
    [J.WEqualsLocallyBijective AddCommGrpCat] [CategoryTheory.HasWeakSheafify J AddCommGrpCat]
    {A B : PresheafOfModules.{u} R₀} (f : A ⟶ B)
    (hf : J.W ((PresheafOfModules.toPresheaf R₀).map f)) :
    IsIso ((PresheafOfModules.sheafification α).map f) := by
  have h := PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms (J := J) α
  have h2 : (CategoryTheory.MorphismProperty.isomorphisms (SheafOfModules Rsh)).inverseImage
      (PresheafOfModules.sheafification α) f := by rw [← h]; exact hf
  exact h2

end FlatWhisker

/-! ## Project-local Mathlib supplement — the `R.stalk x`-linear stalk map
(ROUTE (e), ingredient d.1)

The route-(e) residual `isLocallyInjective_whiskerLeft_of_W` is a stalkwise
argument: a `J.W`-morphism `g` is a *stalkwise isomorphism*, so `(F ◁ g)_x =
id_{F_x} ⊗_{R_x} g_x` is again an isomorphism for arbitrary `F`. The stalkwise
characterisation it ultimately rests on (ingredient d.1) requires the induced
Ab-stalk map of a morphism `g : M ⟶ N` of presheaves of `R`-modules to be packaged
as an **`R.stalk x`-linear map** between the stalk modules.

Mathlib (`Mathlib.Algebra.Category.ModuleCat.Stalk`) already supplies, for `X : TopCat`
and `R : X.Presheaf CommRingCat`, the stalk module structure
`Module (R.stalk x) ↑(TopCat.Presheaf.stalk M.presheaf x)` together with the germ /
scalar compatibility `PresheafOfModules.germ_smul`; what it does **not** supply is the
linearity of the induced stalk map `(stalkFunctor Ab x).map ((toPresheaf _).map g)`.
This section provides that packaging (the first concrete ingredient of d.1 toward
`isLocallyInjective_whiskerLeft_of_W`). The base ring presheaf is necessarily
`CommRingCat`-valued, matching the project's `X.presheaf` carrier. -/

section StalkLinearMap

open TopologicalSpace TopCat.Presheaf Opposite

variable {X : TopCat.{u}} {R : X.Presheaf CommRingCat.{u}}

/-- **The `R.stalk x`-linear stalk map of a morphism of presheaves of modules.**
For `g : M ⟶ N` in `PresheafOfModules (R ⋙ forget₂ _ _)` over a topological space
`X` and a point `x`, the induced Ab-stalk map `(stalkFunctor Ab x).map
((toPresheaf _).map g) : M.presheaf.stalk x ⟶ N.presheaf.stalk x` is `R.stalk x`-linear
for the stalk module structures of `Mathlib.Algebra.Category.ModuleCat.Stalk`.
Project-local: Mathlib packages the stalk module structure (`germ_smul`) but not the
linearity of the induced stalk map. This is ingredient (d.1) of the route-(e)
stalkwise argument for `isLocallyInjective_whiskerLeft_of_W`. -/
noncomputable def stalkLinearMap
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (x : X) :
    (↑(TopCat.Presheaf.stalk M.presheaf x) : Type u) →ₗ[↑(R.stalk x)]
      (↑(TopCat.Presheaf.stalk N.presheaf x) : Type u) where
  toFun := (ConcreteCategory.hom
    ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map ((toPresheaf _).map g)))
  map_add' a b := map_add _ a b
  map_smul' r s := by
    dsimp only [RingHom.id_apply]
    obtain ⟨U, hxU, r₀, rfl⟩ := TopCat.Presheaf.germ_exist R x r
    obtain ⟨V, hxV, s₀, rfl⟩ := TopCat.Presheaf.germ_exist M.presheaf x s
    set W : Opens X := U ⊓ V with hW
    have hxW : x ∈ W := ⟨hxU, hxV⟩
    set iWU : W ⟶ U := homOfLE inf_le_left
    set iWV : W ⟶ V := homOfLE inf_le_right
    have hr : (ConcreteCategory.hom (R.germ U x hxU)) r₀
        = (ConcreteCategory.hom (R.germ W x hxW)) ((ConcreteCategory.hom (R.map iWU.op)) r₀) :=
      (TopCat.Presheaf.germ_res_apply R iWU x hxW r₀).symm
    have hs : (ConcreteCategory.hom (TopCat.Presheaf.germ M.presheaf V x hxV)) s₀
        = (ConcreteCategory.hom (TopCat.Presheaf.germ M.presheaf W x hxW))
            ((ConcreteCategory.hom (M.presheaf.map iWV.op)) s₀) :=
      (TopCat.Presheaf.germ_res_apply M.presheaf iWV x hxW s₀).symm
    have key : ∀ (z : (↑(M.obj (op W)) : Type u)),
        (ConcreteCategory.hom ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map
            ((toPresheaf _).map g)))
          ((ConcreteCategory.hom (TopCat.Presheaf.germ M.presheaf W x hxW)) z)
        = (ConcreteCategory.hom (TopCat.Presheaf.germ N.presheaf W x hxW))
            ((ConcreteCategory.hom (g.app (op W))) z) := by
      intro z
      rw [show (ConcreteCategory.hom (g.app (op W))) z
            = (ConcreteCategory.hom (((toPresheaf _).map g).app (op W))) z from
            (toPresheaf_map_app_apply g (op W) z).symm]
      exact TopCat.Presheaf.stalkFunctor_map_germ_apply (F := M.presheaf) (G := N.presheaf)
        W x hxW ((toPresheaf _).map g) z
    rw [hr, hs, ← PresheafOfModules.germ_smul M x W hxW, key, map_smul,
        PresheafOfModules.germ_smul N x W hxW, key]

/-- **Germ characterisation of `stalkLinearMap`.** On the germ of a section `s` over
an open `U ∋ x`, `stalkLinearMap g x` is the germ of `g.app (op U) s`. This is the
defining naturality of the stalk map, exposed for the downstream d.2 assembly
(identifying the stalk map of `F ◁ g` with `id_{F_x} ⊗ g_x`). -/
lemma stalkLinearMap_germ
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (x : X)
    (U : Opens X) (hx : x ∈ U) (s : (↑(M.obj (op U)) : Type u)) :
    stalkLinearMap g x ((ConcreteCategory.hom (TopCat.Presheaf.germ M.presheaf U x hx)) s)
      = (ConcreteCategory.hom (TopCat.Presheaf.germ N.presheaf U x hx))
          ((ConcreteCategory.hom (g.app (op U))) s) := by
  change (ConcreteCategory.hom ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map
        ((toPresheaf _).map g)))
      ((ConcreteCategory.hom (TopCat.Presheaf.germ M.presheaf U x hx)) s) = _
  rw [show (ConcreteCategory.hom (g.app (op U))) s
        = (ConcreteCategory.hom (((toPresheaf _).map g).app (op U))) s from
        (toPresheaf_map_app_apply g (op U) s).symm]
  exact TopCat.Presheaf.stalkFunctor_map_germ_apply (F := M.presheaf) (G := N.presheaf)
    U x hx ((toPresheaf _).map g) s

/-- **A stalkwise-iso morphism induces a bijective `R.stalk x`-linear stalk map.**
If the underlying Ab-stalk map of `g` at `x` is an isomorphism, then `stalkLinearMap
g x` is bijective — hence (being `R.stalk x`-linear) an `R.stalk x`-linear
equivalence `M_x ≃ₗ N_x`. This is the form ingredient (d.1) feeds into the
`id_{F_x} ⊗ g_x` step (tensoring an `R.stalk x`-linear equivalence by `id` stays an
equivalence, flatness-free). -/
lemma stalkLinearMap_bijective_of_isIso
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (x : X)
    (h : IsIso ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map ((toPresheaf _).map g))) :
    Function.Bijective (stalkLinearMap g x) := by
  change Function.Bijective ⇑(ConcreteCategory.hom
    ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map ((toPresheaf _).map g)))
  exact ConcreteCategory.bijective_of_isIso _

/-- **The `R.stalk x`-linear stalk equivalence of a stalkwise-iso morphism.** When the
underlying Ab-stalk map of `g` at `x` is an isomorphism, `stalkLinearMap g x` upgrades
to an `R.stalk x`-linear equivalence `M_x ≃ₗ N_x`. This is the exact object the route-(e)
`id_{F_x} ⊗ g_x` step consumes: tensoring it by `id_{F_x}` (`LinearEquiv.lTensor`) yields
an equivalence with no flatness hypothesis. -/
noncomputable def stalkLinearEquivOfIsIso
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ _ _)} (g : M ⟶ N) (x : X)
    (h : IsIso ((TopCat.Presheaf.stalkFunctor AddCommGrpCat.{u} x).map ((toPresheaf _).map g))) :
    (↑(TopCat.Presheaf.stalk M.presheaf x) : Type u) ≃ₗ[↑(R.stalk x)]
      (↑(TopCat.Presheaf.stalk N.presheaf x) : Type u) :=
  LinearEquiv.ofBijective (stalkLinearMap g x) (stalkLinearMap_bijective_of_isIso g x h)

end StalkLinearMap

end PresheafOfModules

/-! ## Project-local Mathlib supplement — the presheaf-level pushforward adjunction (H1)

De-sheafification of `SheafOfModules.{pushforwardNatTrans, pushforwardCongr,
pushforwardPushforwardAdj}`
(`Mathlib/Algebra/Category/ModuleCat/Sheaf/PushforwardContinuous.lean`, L154/L73/L226) to the
`PresheafOfModules` level. Every line of the sheaf template already manipulates
`.val`/`.val.presheaf` presheaf data, so the de-sheafification is mechanical (drop the `Sheaf`
wrapper and the sheaf-only `IsContinuous` `letI`s). These are the **H1** linchpin of
`tensorObj_restrict_iso`: from a pair `adj : F ⊣ G` one obtains a presheaf-level adjunction
`pushforward φ ⊣ pushforward ψ`, hence — against the existing
`PresheafOfModules.pullbackPushforwardAdjunction` and via `Adjunction.leftAdjointUniq` —
the iso `pushforward β ≅ pullback φ` that moves the abstract presheaf pullback onto the concrete
restriction pushforward. Per blueprint `lem:tensorobj_restrict_iso`, Step 3 (the H1 residual). -/

namespace PresheafOfModules

open CategoryTheory Functor

section PushforwardNatTrans

universe v₁ v₂ uC uD

variable {C : Type uC} [Category.{v₁} C] {D : Type uD} [Category.{v₂} D]
  {F G : C ⥤ D} {S : Cᵒᵖ ⥤ RingCat.{u}} {R : Dᵒᵖ ⥤ RingCat.{u}}
  (φ : S ⟶ G.op ⋙ R)

/-- **Presheaf-level `pushforwardNatTrans`.** A natural transformation `α : F ⟶ G` of functors
`C ⥤ D` induces a natural transformation between the pushforward functors along `F` and `G`.
De-sheafification of `SheafOfModules.pushforwardNatTrans`
(`Sheaf/PushforwardContinuous.lean:154`), dropping the `.val` wrapper. -/
noncomputable def pushforwardNatTrans (α : F ⟶ G) :
    pushforward.{u} φ ⟶ pushforward.{u} (φ ≫ Functor.whiskerRight (NatTrans.op α) R) where
  app M :=
    { app := fun U => (ModuleCat.restrictScalars (φ.app U).hom).map (M.map (α.app U.unop).op)
      naturality := fun {U V} i => by
        ext x
        dsimp
        change (M.presheaf.map (G.map i.unop).op ≫ M.presheaf.map (α.app V.unop).op) _ =
          (M.presheaf.map (α.app U.unop).op ≫ M.presheaf.map (F.map i.unop).op) _
        simp only [← CategoryTheory.Functor.map_comp, ← op_comp, α.naturality] }
  naturality := fun {M N} f => by
    ext U x
    exact congr($(f.naturality (α.app U.unop).op) x).symm

@[simp] lemma pushforwardNatTrans_app_app_apply (α : F ⟶ G) (M : PresheafOfModules.{u} R)
    (U : Cᵒᵖ) (x) :
    ((pushforwardNatTrans φ α).app M).app U x = M.map (α.app U.unop).op x := rfl

end PushforwardNatTrans

section PushforwardCongr

universe v₁ v₂ uC uD

variable {C : Type uC} [Category.{v₁} C] {D : Type uD} [Category.{v₂} D]
  {F : C ⥤ D} {S : Cᵒᵖ ⥤ RingCat.{u}} {R : Dᵒᵖ ⥤ RingCat.{u}}

/-- **Presheaf-level `pushforwardCongr`.** Pushforwards along equal morphisms of presheaves of
rings are isomorphic. De-sheafification of `SheafOfModules.pushforwardCongr`
(`Sheaf/PushforwardContinuous.lean:73`), dropping the `fullyFaithfulForget` preimage (the
presheaf-level `pushforward` lands in `PresheafOfModules` directly). -/
noncomputable def pushforwardCongr {φ ψ : S ⟶ F.op ⋙ R} (e : φ = ψ) :
    pushforward.{u} φ ≅ pushforward.{u} ψ :=
  NatIso.ofComponents (fun M ↦
    PresheafOfModules.isoMk
      (fun U ↦ (ModuleCat.restrictScalarsCongr (R := S.obj U) (S := R.obj _)
        (f := (φ.app U).hom) (g := (ψ.app U).hom) (by subst e; rfl)).app _)
      (fun _ _ _ ↦ by subst e; rfl)) (fun _ ↦ by subst e; rfl)

@[simp] lemma pushforwardCongr_hom_app_app {φ ψ : S ⟶ F.op ⋙ R} (e : φ = ψ)
    (M : PresheafOfModules.{u} R) (U x) :
    ((pushforwardCongr e).hom.app M).app U x = x := by subst e; rfl

@[simp] lemma pushforwardCongr_inv_app_app {φ ψ : S ⟶ F.op ⋙ R} (e : φ = ψ)
    (M : PresheafOfModules.{u} R) (U x) :
    ((pushforwardCongr e).inv.app M).app U x = x := by subst e; rfl

end PushforwardCongr

section PushforwardAdj

universe v₁ v₂ uC uD

variable {C : Type uC} [Category.{v₁} C] {D : Type uD} [Category.{v₂} D]
  {F : C ⥤ D} {G : D ⥤ C} {S : Cᵒᵖ ⥤ RingCat.{u}} {R : Dᵒᵖ ⥤ RingCat.{u}}
  (adj : F ⊣ G)
  (φ : S ⟶ F.op ⋙ R)
  (ψ : R ⟶ G.op ⋙ S)
  (H₁ : Functor.whiskerRight (NatTrans.op adj.counit) R = ψ ≫ G.op.whiskerLeft φ)
  (H₂ : φ ≫ F.op.whiskerLeft ψ ≫ Functor.whiskerRight (NatTrans.op adj.unit) S = 𝟙 S)

set_option backward.isDefEq.respectTransparency false in
/-- **Presheaf-level `pushforwardPushforwardAdj`.** If `F ⊣ G`, then the presheaf-of-modules
pushforwards along `F` and `G` are also adjoint. De-sheafification of
`SheafOfModules.pushforwardPushforwardAdj` (`Sheaf/PushforwardContinuous.lean:226`), dropping the
sheaf-only `IsContinuous` `letI`s and the `.val`/`.hom` wrappers. This is the H1 linchpin: applied
to the open-immersion adjunction `f.opensFunctor ⊣ Opens.map f.base` it gives
`pushforward β ⊣ pushforward φ`. -/
noncomputable def pushforwardPushforwardAdj : pushforward.{u} φ ⊣ pushforward.{u} ψ where
  unit :=
    (pushforwardId _).inv ≫ pushforwardNatTrans (𝟙 _) adj.counit ≫
      (pushforwardCongr (by simpa using H₁)).hom ≫ (pushforwardComp _ _).inv
  counit :=
    (pushforwardComp _ _).hom ≫ pushforwardNatTrans _ adj.unit ≫
      (pushforwardCongr (by simpa using H₂)).hom ≫ (pushforwardId _).hom
  left_triangle_components X := by
    ext U x
    change (X.presheaf.map (adj.counit.app (F.obj U.unop)).op ≫
      X.presheaf.map (F.map (adj.unit.app U.unop)).op) _ = _
    dsimp only [id_obj]
    rw [← Functor.map_comp, ← op_comp, adj.left_triangle_components]
    simp
  right_triangle_components X := by
    ext U x
    change (X.presheaf.map (G.map (adj.counit.app U.unop)).op ≫
      X.presheaf.map (adj.unit.app (G.obj U.unop)).op) _ = _
    rw [← Functor.map_comp, ← op_comp, adj.right_triangle_components]
    simp

end PushforwardAdj

section StrongMonoidalRestrictScalars

universe v'

variable {C : Type u} [Category.{v'} C]

/-- **A sectionwise-isomorphism morphism of presheaves of modules is an isomorphism.**
The inverse is assembled sectionwise via `isoMk` (whose forward naturality is exactly the
naturality of the given morphism). -/
lemma isIso_of_isIso_app {𝓡 : Cᵒᵖ ⥤ RingCat.{u}} {M N : PresheafOfModules.{u} 𝓡}
    (g : M ⟶ N) (h : ∀ U, IsIso (g.app U)) : IsIso g := by
  haveI := h
  have hg : g = (PresheafOfModules.isoMk (fun U => asIso (g.app U))
      (fun _ _ φ => g.naturality φ)).hom :=
    PresheafOfModules.hom_ext (fun _ => rfl)
  rw [hg]; infer_instance

variable {R S : Cᵒᵖ ⥤ CommRingCat.{u}}

/-- **`PresheafOfModules.restrictScalars α` is strong monoidal when `α` is sectionwise
bijective.** The lax tensorator `μ` and unit `ε` (`restrictScalarsLaxMonoidal`) are assembled
sectionwise from the `ModuleCat`-level ones, which are isomorphisms for a bijective ground-ring
map (`restrictScalars_isIso_μ_of_bijective`, `restrictScalars_isIso_ε_of_bijective`); hence the
presheaf `μ`/`ε` are sectionwise isos, hence isos (`isIso_of_isIso_app`), and the lax structure
upgrades to strong via `Functor.Monoidal.ofLaxMonoidal`. This is the **H2** presheaf lift of
`tensorObj_restrict_iso`. -/
@[implicit_reducible]
noncomputable def restrictScalarsMonoidalOfBijective
    (α : R ⋙ forget₂ CommRingCat RingCat ⟶ S ⋙ forget₂ CommRingCat RingCat)
    (hα : ∀ U, Function.Bijective (α.app U).hom) :
    (PresheafOfModules.restrictScalars α).Monoidal := by
  haveI hε : IsIso (Functor.LaxMonoidal.ε (PresheafOfModules.restrictScalars α)) :=
    isIso_of_isIso_app _ (fun U => restrictScalars_isIso_ε_of_bijective (α.app U).hom (hα U))
  haveI hμ : ∀ M₁ M₂, IsIso (Functor.LaxMonoidal.μ (PresheafOfModules.restrictScalars α) M₁ M₂) :=
    fun M₁ M₂ => isIso_of_isIso_app _
      (fun U => restrictScalars_isIso_μ_of_bijective (α.app U).hom (hα U) (M₁.obj U) (M₂.obj U))
  exact Functor.Monoidal.ofLaxMonoidal _

end StrongMonoidalRestrictScalars

/-! ## Project-local Mathlib supplement — the internal hom of presheaves of modules
(slice formula): the `R(T)`-module structure on `Hom(M, N)`

This section builds the FIRST primitive of the sheaf internal-hom / dual block
(blueprint `sec:tensorobj_dual_infra`, the `⊗`-inverse's missing ingredient): the
`R(T)`-module structure on the morphism abelian group `M ⟶ N` of presheaves of
modules over a base category `C` with a **terminal object** `T`, where the scalar
ring is the global ring `R(T)`.

This is exactly the module attached to each value of the slice internal hom
`ℋom(M, N)(U) := ModuleCat.of (R(U)) (M|_U ⟶ N|_U)` of
blueprint `def:presheaf_internal_hom`: over the restricted site (terminal `U`),
the section module over `U` is `Hom(M|_U, N|_U)` with its `R(U)`-action. The slice
formula is forced by contravariance of the naive pointwise rule
`U ↦ Hom_{R(U)}(M(U), N(U))`; the module of morphisms of *restricted* objects is
the covariant remedy, and its `R(U)`-module structure is the content here.

The action is `f • φ := φ ≫ globalSMul f`, where `globalSMul f : N ⟶ N` is the
"multiply by the global scalar `f ∈ R(T)`" endomorphism: at an object `Y`, with
`R(T) → R(Y)` the canonical map `termRingMap` induced by the unique `Y → T`, it is
scalar multiplication by the image of `f`. Mathlib has the fixed-ring internal hom
`ihom M N = (M ⟶ N)` (`Mathlib/Algebra/Category/ModuleCat/Monoidal/Closed.lean`) but
nothing for the varying structure sheaf at the `PresheafOfModules` level; this is the
project-local supplement. -/

namespace InternalHom

open CategoryTheory Limits

universe vC uC

variable {C : Type uC} [Category.{vC} C] {R : Cᵒᵖ ⥤ CommRingCat.{u}}
  {T : C} (hT : IsTerminal T)

/-- **The canonical ring map `R(T) → R(Y)` from a terminal object `T`.** For each
object `Y`, the unique morphism `Y.unop → T` (terminality) induces, after `op` and
applying `R`, the ring map `R(T) → R(Y)` along which a global scalar `f ∈ R(T)` acts
on `R(Y)`-modules. Project-local: the `R(T)`-module structure on `Hom(M, N)` (the slice
internal-hom value) is defined through this map. -/
noncomputable def termRingMap (Y : Cᵒᵖ) : R.obj (Opposite.op T) ⟶ R.obj Y :=
  R.map (hT.from Y.unop).op

/-- **Naturality of `termRingMap`.** The restriction map `R(g) : R(X) → R(Y)` of `R`
along `g : X ⟶ Y` carries `termRingMap X f` to `termRingMap Y f`; equivalently the
images of a global scalar `f ∈ R(T)` are compatible with restriction. This is the
sole ingredient making `globalSMul f` a genuine morphism of presheaves of modules. -/
lemma termRingMap_naturality {X Y : Cᵒᵖ} (g : X ⟶ Y) (f) :
    (ConcreteCategory.hom ((R ⋙ forget₂ CommRingCat RingCat).map g))
        ((ConcreteCategory.hom (termRingMap hT X)) f)
      = (ConcreteCategory.hom (termRingMap hT Y)) f := by
  have h : (hT.from X.unop).op ≫ g = (hT.from Y.unop).op := by
    apply Quiver.Hom.unop_inj; apply hT.hom_ext
  change (ConcreteCategory.hom (R.map g)) ((ConcreteCategory.hom (R.map (hT.from X.unop).op)) f) = _
  rw [show termRingMap hT Y = R.map (hT.from Y.unop).op from rfl, ← h, Functor.map_comp]; rfl

/-- **Multiplication by a global scalar `f ∈ R(T)` as an endomorphism of `N`.** At an
object `Y`, it is scalar multiplication by `termRingMap Y f ∈ R(Y)` on `N(Y)`; the
naturality square commutes by `termRingMap_naturality` and the semilinearity of the
restriction maps of `N` (`PresheafOfModules.map_smul`). This is the central object: it
gives the `R(T)`-action on `Hom(M, N)` by post-composition (`homModule`). -/
noncomputable def globalSMul (N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat))
    (f : (R.obj (Opposite.op T) : Type u)) : N ⟶ N :=
  PresheafOfModules.Hom.mk
    (fun Y => ModuleCat.ofHom
      (LinearMap.lsmul (R.obj Y : Type u) (N.obj Y) ((ConcreteCategory.hom (termRingMap hT Y)) f)))
    (by
      intro X Y g; ext m
      change (LinearMap.lsmul (R.obj Y : Type u) (N.obj Y)
            ((ConcreteCategory.hom (termRingMap hT Y)) f)) ((ConcreteCategory.hom (N.map g)) m)
          = (ConcreteCategory.hom (N.map g)) ((LinearMap.lsmul (R.obj X : Type u) (N.obj X)
            ((ConcreteCategory.hom (termRingMap hT X)) f)) m)
      rw [LinearMap.lsmul_apply, LinearMap.lsmul_apply]; erw [PresheafOfModules.map_smul]
      rw [termRingMap_naturality]; rfl)

variable {N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}

/-- The section-wise action of `globalSMul f`: at `Y`, it is scalar multiplication by
`termRingMap Y f`. -/
lemma globalSMul_hom_apply (f : (R.obj (Opposite.op T) : Type u)) (Y : Cᵒᵖ) (m : N.obj Y) :
    ((globalSMul hT N f).app Y).hom m = ((ConcreteCategory.hom (termRingMap hT Y)) f) • m := rfl

/-- `globalSMul 1 = 𝟙`. -/
lemma globalSMul_one : globalSMul hT N 1 = 𝟙 N := by
  ext Y m; rw [globalSMul_hom_apply, map_one, one_smul]; rfl

/-- `globalSMul 0 = 0`. -/
lemma globalSMul_zero : globalSMul hT N 0 = 0 := by
  ext Y m; rw [globalSMul_hom_apply, map_zero, zero_smul]; rfl

/-- `globalSMul` is additive in the scalar. -/
lemma globalSMul_add (f g : (R.obj (Opposite.op T) : Type u)) :
    globalSMul hT N (f + g) = globalSMul hT N f + globalSMul hT N g := by
  ext Y m; rw [add_app, globalSMul_hom_apply, _root_.map_add, add_smul]; rfl

/-- `globalSMul` turns ring multiplication into composition (the scalar endomorphisms
commute, so the order is immaterial). -/
lemma globalSMul_mul (f g : (R.obj (Opposite.op T) : Type u)) :
    globalSMul hT N (f * g) = globalSMul hT N g ≫ globalSMul hT N f := by
  ext Y m; rw [comp_app, globalSMul_hom_apply, map_mul, mul_smul, ModuleCat.hom_comp,
    LinearMap.comp_apply, globalSMul_hom_apply, globalSMul_hom_apply]

/-- **The `R(T)`-module structure on `Hom(M, N)` of presheaves of modules over a base
category `C` with a terminal object `T`.** The action `f • φ := φ ≫ globalSMul f` scales
a morphism by post-composing with multiplication by the global scalar `f ∈ R(T)`; the
module axioms reduce to the `globalSMul_{one,zero,add,mul}` ring-homomorphism facts and
the bilinearity of composition (`Preadditive`). This is the module carried by each value
of the slice internal hom `ℋom(M, N)(U)` of blueprint `def:presheaf_internal_hom`
(take `C =` the restricted site over `U`, with terminal `U`, so `R(T) = R(U)`).
Project-local: Mathlib has the fixed-ring internal hom but no `PresheafOfModules`-level
internal hom for the varying structure sheaf. -/
@[implicit_reducible]
noncomputable def homModule (M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)) :
    Module (R.obj (Opposite.op T) : Type u) (M ⟶ N) where
  smul f φ := φ ≫ globalSMul hT N f
  one_smul φ := by change φ ≫ globalSMul hT N 1 = φ; rw [globalSMul_one, Category.comp_id]
  mul_smul f g φ := by
    change φ ≫ globalSMul hT N (f * g) = (φ ≫ globalSMul hT N g) ≫ globalSMul hT N f
    rw [globalSMul_mul, Category.assoc]
  smul_zero f := by change (0 : M ⟶ N) ≫ globalSMul hT N f = 0; rw [Limits.zero_comp]
  zero_smul φ := by change φ ≫ globalSMul hT N 0 = 0; rw [globalSMul_zero, Limits.comp_zero]
  smul_add f φ ψ := by
    change (φ + ψ) ≫ globalSMul hT N f = φ ≫ globalSMul hT N f + ψ ≫ globalSMul hT N f
    rw [Preadditive.add_comp]
  add_smul f g φ := by
    change φ ≫ globalSMul hT N (f + g) = φ ≫ globalSMul hT N f + φ ≫ globalSMul hT N g
    rw [globalSMul_add, Preadditive.comp_add]

/-! ### The slice value at an object `U` via the over-category `Over U`

The slice internal hom `ℋom(M, N)(U) := ModuleCat.of (R(U)) (M|_U ⟶ N|_U)` of
blueprint `def:presheaf_internal_hom` is realized object-by-object here. The
restriction `M|_U` is `PresheafOfModules.pushforward₀` along the over-category
projection `Over.forget U : Over U ⥤ C`; the over-category has terminal object
`Over.mk (𝟙 U)` (`Over.mkIdTerminal`), at which the restricted ring is `R(U)`
(by `rfl`), so the `R(U)`-module structure on `M|_U ⟶ N|_U` is exactly `homModule`
applied to that terminal. -/

/-- **Restriction of a presheaf of modules to the over-category `Over U`.** This is
the `M|_U` of the slice internal-hom formula: `PresheafOfModules.pushforward₀` along
the over-category projection `Over.forget U`. The new base presheaf of rings is
`(Over.forget U).op ⋙ R`, whose value at the terminal `Over.mk (𝟙 U)` is `R(U)`. -/
noncomputable def restr (U : C)
    (M : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)) :
    PresheafOfModules.{u} (((Over.forget U).op ⋙ R) ⋙ forget₂ CommRingCat RingCat) :=
  (PresheafOfModules.pushforward₀ (Over.forget U) (R ⋙ forget₂ CommRingCat RingCat)).obj M

/-- **The slice internal-hom value at `U`: `Hom(M|_U, N|_U)` as an `R(U)`-module.**
This is the `R(U)`-module underlying `ℋom(M, N)(U)` of blueprint
`def:presheaf_internal_hom`: the morphism group of the over-category restrictions
`M|_U ⟶ N|_U`, equipped with the `homModule` action for the terminal object
`Over.mk (𝟙 U)` of `Over U`. The full presheaf `internalHom` (the assembly of these
values over the restriction maps `V ⟶ U`) was assembled iter-220 (`internalHom`). -/
@[implicit_reducible]
noncomputable def internalHomObjModule (U : C)
    (M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)) :
    Module (R.obj (Opposite.op U) : Type u) (restr U M ⟶ restr U N) :=
  homModule (R := (Over.forget U).op ⋙ R) (T := Over.mk (𝟙 U)) Over.mkIdTerminal
    (restr U M) (restr U N)

/-- **The restriction map of the presheaf internal hom.** For a morphism `g : V ⟶ U`
of `C`, restricting a morphism `φ : M|_U ⟶ N|_U` of restricted presheaves of modules
along `Over.map g : Over V ⥤ Over U` yields a morphism `M|_V ⟶ N|_V`. Realised as
`(pushforward₀ (Over.map g) …).map φ`; the target base ring presheaf
`(Over.map g).op ⋙ (Over.forget U).op ⋙ R` is definitionally `(Over.forget V).op ⋙ R`,
so the result has the expected type `restr V M ⟶ restr V N`. This is the
further-restriction map `φ ↦ φ|_V` of blueprint `lem:presheaf_internal_hom_restriction`. -/
noncomputable def restrictionMap {U V : C} (g : V ⟶ U)
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}
    (φ : restr U M ⟶ restr U N) : restr V M ⟶ restr V N :=
  (PresheafOfModules.pushforward₀ (Over.map g)
    ((Over.forget U).op ⋙ (R ⋙ forget₂ CommRingCat RingCat))).map φ

/-- **`restrictionMap` is additive.** Part of the additivity assertion of blueprint
`lem:presheaf_internal_hom_restriction`. -/
lemma restrictionMap_add {U V : C} (g : V ⟶ U)
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}
    (φ ψ : restr U M ⟶ restr U N) :
    restrictionMap g (φ + ψ) = restrictionMap g φ + restrictionMap g ψ := by
  ext1 X; rfl

/-- **`restrictionMap` preserves zero.** -/
lemma restrictionMap_zero {U V : C} (g : V ⟶ U)
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)} :
    restrictionMap g (0 : restr U M ⟶ restr U N) = 0 := by
  ext1 X; rfl

/-- Helper: the component of a morphism of presheaves of modules at two *equal*
objects agrees up to `HEq`. Proven by `subst`. Used to discharge the
pseudofunctoriality coherence of `restrictionMap` (`Over.map` is only functorial in
its argument up to `Over.mapId_eq` / `Over.mapComp_eq`). -/
private lemma hom_app_heq {B : Cᵒᵖ ⥤ RingCat.{u}} {M N : PresheafOfModules.{u} B}
    (φ : M ⟶ N) {X Y : Cᵒᵖ} (h : X = Y) : HEq (φ.app X) (φ.app Y) := by
  subst h; rfl

/-- **Functoriality of `restrictionMap`: identity.** -/
lemma restrictionMap_id {U : C}
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}
    (φ : restr U M ⟶ restr U N) :
    restrictionMap (𝟙 U) φ = φ := by
  ext1 X
  exact eq_of_heq (hom_app_heq φ (by rw [Over.mapId_eq]; rfl))

/-- **Functoriality of `restrictionMap`: composition.** For `g : V ⟶ U`, `h : W ⟶ V`,
restricting along `h ≫ g` is restricting along `g` then along `h`. -/
lemma restrictionMap_comp {U V W : C} (g : V ⟶ U) (h : W ⟶ V)
    {M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}
    (φ : restr U M ⟶ restr U N) :
    restrictionMap (h ≫ g) φ = restrictionMap h (restrictionMap g φ) := by
  ext1 X
  exact eq_of_heq (hom_app_heq φ (by rw [Over.mapComp_eq]; rfl))

/-- **`restrictionMap` respects composition of morphisms** (functoriality of
`pushforward₀.map`). -/
lemma restrictionMap_comp_hom {U V : C} (g : V ⟶ U)
    {M N P : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}
    (φ : restr U M ⟶ restr U N) (ψ : restr U N ⟶ restr U P) :
    restrictionMap g (φ ≫ ψ) = restrictionMap g φ ≫ restrictionMap g ψ :=
  Functor.map_comp _ _ _

/-- **Restriction commutes with the global-scalar endomorphism.** For `g : V ⟶ U`
and a global scalar `r ∈ R(U)`, restricting the multiplication-by-`r` endomorphism of
`N|_U` yields the multiplication-by-`R(g)(r)` endomorphism of `N|_V`. This is the heart
of the semilinearity of `restrictionMap` (blueprint `lem:presheaf_internal_hom_restriction`):
both sides act on each section by scalar multiplication, and the scalars agree by
functoriality of `R` (`termRingMap_naturality`). -/
lemma restrictionMap_globalSMul {U V : C} (g : V ⟶ U)
    {N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)}
    (r : (R.obj (Opposite.op U) : Type u)) :
    restrictionMap g (globalSMul (R := (Over.forget U).op ⋙ R) (T := Over.mk (𝟙 U))
        Over.mkIdTerminal (restr U N) r)
      = globalSMul (R := (Over.forget V).op ⋙ R) (T := Over.mk (𝟙 V))
        Over.mkIdTerminal (restr V N) ((ConcreteCategory.hom (R.map g.op)) r) := by
  ext1 Y
  ext m
  rw [globalSMul_hom_apply]
  erw [globalSMul_hom_apply]
  congr 1
  simp only [termRingMap, Functor.comp_map]
  have hmor : (Over.forget U).op.map
        (Over.mkIdTerminal.from ((Over.map g).op.obj Y).unop).op
      = g.op ≫ (Over.forget V).op.map (Over.mkIdTerminal.from Y.unop).op := by
    apply Quiver.Hom.unop_inj
    change Over.Hom.left (Over.mkIdTerminal.from ((Over.map g).obj Y.unop))
      = Over.Hom.left (Over.mkIdTerminal.from Y.unop) ≫ g
    have e1 : Over.Hom.left (Over.mkIdTerminal.from ((Over.map g).obj Y.unop))
        = ((Over.map g).obj Y.unop).hom := by simp
    have e2 : Over.Hom.left (Over.mkIdTerminal.from Y.unop) = Y.unop.hom := by simp
    rw [e1, e2]
    simp [Over.map_obj_hom]
  rw [hmor]
  erw [← CommRingCat.comp_apply, ← R.map_comp]
  rfl

/-- **`restrictionMap` packaged as an additive group homomorphism** on the morphism
groups, using `restrictionMap_zero` and `restrictionMap_add`. This is the value of the
underlying `Ab`-presheaf morphism of `internalHom`. -/
noncomputable def restrictionMapAddHom {U V : C} (g : V ⟶ U)
    (M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)) :
    (restr U M ⟶ restr U N) →+ (restr V M ⟶ restr V N) where
  toFun := restrictionMap g
  map_zero' := restrictionMap_zero g
  map_add' := restrictionMap_add g

/-- **The underlying `Ab`-valued presheaf of `internalHom M N`**: `U ↦ (M|_U ⟶ N|_U)`
with the further-restriction maps. Functoriality is `restrictionMap_id` /
`restrictionMap_comp`. This is piece (a)+(b)+(c) of blueprint `def:presheaf_internal_hom`
at the abelian-group level; the `R(U)`-module refinement is added by `internalHom`. -/
noncomputable def internalHomPresheaf
    (M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat)) :
    Cᵒᵖ ⥤ AddCommGrpCat.{max u uC vC} where
  obj X := AddCommGrpCat.of (restr X.unop M ⟶ restr X.unop N)
  map {X Y} f := AddCommGrpCat.ofHom (restrictionMapAddHom f.unop M N)
  map_id X := by
    apply AddCommGrpCat.hom_ext
    refine AddMonoidHom.ext fun φ => ?_
    exact restrictionMap_id φ
  map_comp {X Y Z} f f' := by
    apply AddCommGrpCat.hom_ext
    refine AddMonoidHom.ext fun φ => ?_
    exact restrictionMap_comp f.unop f'.unop φ

/-- **Semilinearity of `restrictionMap`** in the form consumed by
`PresheafOfModules.ofPresheaf`: for `f : X ⟶ Y` in `Cᵒᵖ`, a global scalar
`r ∈ R(X)` and `m : M|_{X} ⟶ N|_{X}`, `restrictionMap f.unop (r • m) =
R(f)(r) • restrictionMap f.unop m`, where the `•`'s are the slice-value module
actions (`internalHomObjModule`). This is `lem:presheaf_internal_hom_restriction`'s
compatibility datum; it follows from `restrictionMap_comp_hom` and
`restrictionMap_globalSMul`. -/
lemma restrictionMap_smul {X Y : Cᵒᵖ} (f : X ⟶ Y)
    (M N : PresheafOfModules.{u} (R ⋙ forget₂ CommRingCat RingCat))
    (r : (R.obj X : Type u)) (m : restr X.unop M ⟶ restr X.unop N) :
    restrictionMap f.unop
        (letI := internalHomObjModule X.unop M N; r • m)
      = (letI := internalHomObjModule Y.unop M N;
          (ConcreteCategory.hom (R.map f)) r • restrictionMap f.unop m) := by
  change restrictionMap f.unop (m ≫ globalSMul Over.mkIdTerminal (restr X.unop N) r)
    = restrictionMap f.unop m
        ≫ globalSMul Over.mkIdTerminal (restr Y.unop N) ((ConcreteCategory.hom (R.map f)) r)
  rw [restrictionMap_comp_hom, restrictionMap_globalSMul, Quiver.Hom.op_unop]

end InternalHom

/-! ### Assembly of the presheaf internal hom over a single-universe base

`PresheafOfModules.ofPresheaf` ties the underlying `Ab`-presheaf to the ground ring
presheaf `R`'s universe (`Type u`), but for a general base category the morphism groups
`M|_U ⟶ N|_U` live in `Type (max u uC vC)`. The two coincide exactly when the base
category is single-universe (`Category.{u, u}`), which is the case for the topological
site `Opens X` underlying the structure sheaf of a scheme. The full presheaf internal
hom is therefore assembled in this specialised universe context. -/

namespace InternalHom

section Assembly

variable {D : Type u} [Category.{u, u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}

/-- **The presheaf internal hom `ℋom(M, N)`** (blueprint `def:presheaf_internal_hom`):
the presheaf of `R`-modules assembled from the slice value modules
`internalHomObjModule` (a), the further-restriction maps `internalHomPresheaf` (b)(c),
and the semilinearity datum `restrictionMap_smul`, via `PresheafOfModules.ofPresheaf`.
Stated over a single-universe base (e.g. the topological site `Opens X`); see the
section note for the universe constraint. -/
noncomputable def internalHom
    (M N : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) :
    PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat) :=
  @PresheafOfModules.ofPresheaf D _ (R₀ ⋙ forget₂ CommRingCat RingCat)
    (internalHomPresheaf M N)
    (fun X => internalHomObjModule X.unop M N)
    (fun {_ _} f r m => restrictionMap_smul f M N r m)

end Assembly

end InternalHom

namespace InternalHom

open CategoryTheory Limits Opposite

universe vC uC

variable {C : Type uC} [Category.{vC} C] {R : Cᵒᵖ ⥤ CommRingCat.{u}}
  {T : C} (hT : IsTerminal T)

/-- **`termRingMap` at the terminal object itself is the identity.** The unique
`T → T` is the identity, so the induced ring map `R(T) → R(T)` is `id`. This is the
fact that the global-scalar action evaluated at the terminal section is the scalar
itself, used to prove the evaluation map of `internalHomEval` is `R(U)`-bilinear. -/
lemma termRingMap_terminal (f : (R.obj (op T) : Type u)) :
    (ConcreteCategory.hom (termRingMap hT (op T))) f = f := by
  have hid : hT.from T = 𝟙 T := hT.hom_ext _ _
  simp only [termRingMap, unop_op, hid, op_id, R.map_id]
  rfl

end InternalHom

/-! ### The presheaf dual `M^∨ := ℋom(M, R)`

The presheaf dual is the internal hom into the monoidal unit (the structure presheaf
viewed as a module over itself), assembled in the same single-universe context as
`InternalHom.internalHom`. Blueprint `def:presheaf_dual`. -/

section Dual

open InternalHom Opposite

variable {D : Type u} [Category.{u, u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}

/-- **The presheaf dual `M^∨ := ℋom(M, R)`** (blueprint `def:presheaf_dual`): the
internal hom into the monoidal unit `𝟙_` (the structure presheaf `R` viewed as a module
over itself / the regular representation). The value
`M^∨(U) = ModuleCat.of (R(U)) (M|_U ⟶ R|_U)` is the `R(U)`-module of `R|_U`-linear
functionals on `M|_U`, the presheaf-of-modules analogue of the fixed-ring linear dual
`Module.Dual R M = (M ⟶ R)` that serves as the `⊗`-inverse of an invertible module.
Project-local: Mathlib has the fixed-ring dual but no `PresheafOfModules`-level dual for
the varying structure sheaf. -/
noncomputable def dual
    (M : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) :
    PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat) :=
  InternalHom.internalHom M (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))

/-- The evaluation functional `φ ↦ (s ↦ φ(s))` of a dual section `φ`, cast to an
`R₀.obj X`-linear map `M(X) → R(X)` (the over-category ring at the terminal section is
definitionally `R₀.obj X`). Helper for `internalHomEvalApp`. -/
noncomputable def evalLin
    (M : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) (X : Dᵒᵖ)
    (φ : (dual M).obj X) :
    (M.obj X : Type u) →ₗ[(R₀.obj X : Type u)] (R₀.obj X : Type u) :=
  ((φ : restr X.unop M ⟶ restr X.unop
      (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).app
        (op (Over.mk (𝟙 X.unop)))).hom

/-- `evalLin` is additive in the dual section `φ` (the dual-section addition is the
categorical `Hom`-addition, on which `app`/`hom`-application is definitionally additive). -/
lemma evalLin_add
    (M : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) (X : Dᵒᵖ)
    (φ φ' : (dual M).obj X) :
    evalLin M X (φ + φ') = evalLin M X φ + evalLin M X φ' :=
  LinearMap.ext fun _ => rfl

/-- `evalLin` is `R₀.obj X`-linear in the dual section `φ`, using the `homModule`
action `c • φ = φ ≫ globalSMul c` and `termRingMap_terminal`. -/
lemma evalLin_smul
    (M : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) (X : Dᵒᵖ)
    (c : (R₀.obj X : Type u)) (φ : (dual M).obj X) :
    evalLin M X (c • φ) = c • evalLin M X φ := by
  refine LinearMap.ext fun s => ?_
  rw [LinearMap.smul_apply]
  change ((ConcreteCategory.hom
      (termRingMap (R := (Over.forget X.unop).op ⋙ R₀) Over.mkIdTerminal
        (op (Over.mk (𝟙 X.unop)))) c)
    • ((φ : restr X.unop M ⟶ restr X.unop
        (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).app
          (op (Over.mk (𝟙 X.unop)))).hom s : (R₀.obj X : Type u))
    = c • evalLin M X φ s
  rw [termRingMap_terminal]
  rfl

/-- **The open-by-open evaluation/contraction map** underlying `internalHomEval`. At an
object `X` it is the `R(X)`-bilinear contraction
`(M(X)) ⊗_{R(X)} (M|_X ⟶ R|_X) → R(X)`, `s ⊗ φ ↦ φ(s)`, where `φ(s)` evaluates the
functional `φ` (a morphism of restricted presheaves of modules over `Over X.unop`) at its
terminal section, applied to `s`. Bilinearity over `R(X)`: linearity in `s` is linearity
of `evalLin`; linearity in `φ` is `evalLin_add` / `evalLin_smul`. The codomain is cast to
`R₀.obj X` (defeq to the unit value `(𝟙_).obj X`) to pin the `CommRingCat` module. -/
noncomputable def internalHomEvalApp
    (M : PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) (X : Dᵒᵖ) :
    (PresheafOfModules.Monoidal.tensorObj M (dual M)).obj X ⟶
      (𝟙_ (PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))).obj X :=
  show ModuleCat.of (R₀.obj X : Type u)
        (TensorProduct (R₀.obj X : Type u) (M.obj X) ((dual M).obj X))
      ⟶ ModuleCat.of (R₀.obj X : Type u) (R₀.obj X : Type u) from
  ModuleCat.ofHom
    (TensorProduct.lift
      (LinearMap.mk₂ (R₀.obj X : Type u)
        (fun (s : M.obj X) (φ : (dual M).obj X) => evalLin M X φ s)
        (fun s s' φ => _root_.map_add (evalLin M X φ) s s')
        (fun c s φ => _root_.map_smul (evalLin M X φ) c s)
        (fun s φ φ' => by
          change evalLin M X (φ + φ') s = evalLin M X φ s + evalLin M X φ' s
          rw [evalLin_add, LinearMap.add_apply])
        (fun c s φ => by
          change evalLin M X (c • φ) s = c • evalLin M X φ s
          rw [evalLin_smul, LinearMap.smul_apply])))

end Dual

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

Per blueprint `def:scheme_modules_tensorobj`. The body lifts
`PresheafOfModules.Monoidal.tensorObj` through the sheafification functor on
the small Zariski site of `X` (fully defined, no `sorry`). -/
noncomputable def tensorObj {X : Scheme.{u}} (M N : X.Modules) : X.Modules :=
  ((PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).obj
      (PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val) :
    SheafOfModules X.ringCatSheaf)

/-- **Functoriality of `⊗_X`.**

A pair of morphisms `f : M ⟶ M'` and `g : N ⟶ N'` in `X.Modules` determines a
morphism `f ⊗ g : tensorObj M N ⟶ tensorObj M' N'`, compatible with identities
and composition; the assignment `(M, N) ↦ tensorObj M N` thereby extends to a
bifunctor `X.Modules × X.Modules ⥤ X.Modules` natural in both arguments.

Per blueprint `lem:scheme_modules_tensorobj_functoriality`. The body inherits
the morphism action from `PresheafOfModules.Monoidal.tensorObj` under
sheafification (fully defined, no `sorry`). -/
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

iter-212 status (typed `sorry`; **go/no-go bridge CLEARED, a NEW residual
located**). The construction is the blueprint's three-step composite. Writing
`a = PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)`,
`η = sheafificationAdjunction.unit` (the localizer unit, `toPresheaf`-image
`toSheafify ∈ J.W`), and `α` the presheaf-of-modules associator:
  1. `a(η_{M.val ⊗ᵖ N.val} ▷ P.val)` is iso  (P flat ⇒ right-whiskered `η ∈ J.W`
     by `W_whiskerRight_of_flat`; `a` inverts `J.W` by `isIso_sheafification_map_of_W`),
     giving `(M ⊗ N) ⊗ P = a(a(M.val⊗N.val).val ⊗ P.val) ≅ a((M.val⊗N.val) ⊗ P.val)`;
  2. `a.mapIso α : a((M.val⊗N.val)⊗P.val) ≅ a(M.val⊗(N.val⊗P.val))`;
  3. `a(M.val ◁ η_{N.val ⊗ᵖ P.val})` is iso  (M flat), giving
     `a(M.val⊗(N.val⊗P.val)) ≅ a(M.val ⊗ a(N.val⊗P.val).val) = M ⊗ (N ⊗ P)`.

**The go/no-go bridge `IsIso (a.map f)` from `J.W ((toPresheaf _).map f)` is now
CLOSED, axiom-clean**, as `PresheafOfModules.isIso_sheafification_map_of_W` (it is
`PresheafOfModules.inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms` — the
sheafification functor IS the localization at `J.W.inverseImage (toPresheaf _)` —
read at one morphism). The right-whisker conjugate
`PresheafOfModules.W_whiskerRight_of_flat` is also closed axiom-clean.

**The genuine residual is now the flatness feeding steps 1 and 3**: steps 1/3
need `J.W (toPresheaf (η ▷ P.val))` / `J.W (toPresheaf (M.val ◁ η))`, which
`W_whiskerLeft/Right_of_flat` supply ONLY from the SECTIONWISE flatness instance
`∀ U : (Opens X)ᵒᵖ, Module.Flat (𝒪_X(U)) (P.val(U))` (resp. M). This is NOT
derivable from `IsInvertible`: the only Mathlib route is single-ring
`Module.Invertible R m → Projective → Flat`, which would require `P.val(U)` to be
an invertible `𝒪_X(U)`-module for EVERY open `U` — false in general (the global
sections functor over a non-affine open is not exact and does not preserve
flatness; invertibility is a LOCAL/affine property). The blueprint's
"invertible ⇒ projective ⇒ flat" conflates global module-invertibility with
sectionwise-over-all-opens flatness. The mathematically-correct fix scopes
injectivity LOCALLY (local-triviality whiskering: on the cover where `P ≅ 𝒪`,
`η ▷ P ≅ η`, locally injective) — a new lemma needing `IsInvertible ⇒
IsLocallyTrivial` (blueprint-flagged nontrivial). A second obstacle is pure Lean
friction: `X.ringCatSheaf.val` is only defeq (not syntactically equal) to
`X.presheaf ⋙ forget₂ CommRingCat RingCat`, so the unit `η`'s monoidal
whiskering and the `Module.Flat` instance both fail typeclass synthesis / hit
heartbeat timeouts. See task result for the full corrected decomposition. -/
noncomputable def tensorObj_assoc_iso {X : Scheme.{u}} {M N P : X.Modules}
    (hM : LineBundle.IsLocallyTrivial M) (hN : LineBundle.IsLocallyTrivial N)
    (hP : LineBundle.IsLocallyTrivial P) :
    tensorObj (tensorObj M N) P ≅ tensorObj M (tensorObj N P) := by
  -- Re-scoped to `IsLocallyTrivial` (decl unprotected). ROUTE (d) three-step
  -- composite of the blueprint `lem:tensorobj_assoc_iso`; the locally-trivial
  -- hypotheses are not even consumed (the whiskered-unit localizer fact holds for
  -- arbitrary modules under ROUTE (d)), but are retained to match the blueprint pin.
  -- Bridge the monoidal structure across the `rfl`-defeq carrier
  -- `Sheaf.val X.ringCatSheaf = X.presheaf ⋙ forget₂ CommRingCat RingCat`.
  letI instMS : MonoidalCategoryStruct (_root_.PresheafOfModules (Sheaf.val X.ringCatSheaf)) :=
    inferInstanceAs (MonoidalCategoryStruct
      (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)))
  set a := PresheafOfModules.sheafification (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val) with ha
  -- Underlying presheaf tensors and the sheafification unit `η = toSheafify`.
  set MN := PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) M.val N.val with hMN
  set NP := PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) N.val P.val with hNP
  set η := (PresheafOfModules.sheafificationAdjunction
    (R := X.ringCatSheaf) (𝟙 X.ringCatSheaf.val)).unit with hη
  -- The two whiskered-unit localizer facts (ROUTE (d), via `W_whisker{Right,Left}_of_W`).
  -- `η_A = toSheafify` lies in `J.W` (`W_toSheafify`).
  have hηMN : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app MN)) := by
    rw [hη, PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
    exact CategoryTheory.GrothendieckTopology.W_toSheafify _ _
  have hηNP : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app NP)) := by
    rw [hη, PresheafOfModules.toPresheaf_map_sheafificationAdjunction_unit_app]
    exact CategoryTheory.GrothendieckTopology.W_toSheafify _ _
  have hW1 : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (η.app MN ▷ P.val)) :=
    PresheafOfModules.W_whiskerRight_of_W (R := X.presheaf) P.val (η.app MN) hηMN
  have hW3 : (Opens.grothendieckTopology X).W
      ((PresheafOfModules.toPresheaf _).map (M.val ◁ η.app NP)) :=
    PresheafOfModules.W_whiskerLeft_of_W (R := X.presheaf) M.val (η.app NP) hηNP
  -- Steps 1 and 3: the sheafification functor inverts the whiskered units.
  have hi1 : IsIso (a.map (η.app MN ▷ P.val)) :=
    PresheafOfModules.isIso_sheafification_map_of_W (𝟙 X.ringCatSheaf.val) _ hW1
  have hi3 : IsIso (a.map (M.val ◁ η.app NP)) :=
    PresheafOfModules.isIso_sheafification_map_of_W (𝟙 X.ringCatSheaf.val) _ hW3
  -- Step 2: the presheaf-of-modules associator, transported under `a`.
  have e2 := a.mapIso
    ((PresheafOfModules.monoidalCategoryStruct (R := X.presheaf)).associator M.val N.val P.val)
  exact (@asIso _ _ _ _ _ hi1).symm ≪≫ e2 ≪≫ (@asIso _ _ _ _ _ hi3)

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

This is the single substrate linchpin of `A.1.c.SubT` — **CLOSED, axiom-clean**
(iter-217). It says the substrate `⊗` (sheafification of the presheaf-of-modules
tensor) commutes with the restriction functor along an open immersion. The proof
is the blueprint's four-step composite:
  Step 1 (`restrictFunctorIsoPullback`): reduce `restrict` to the abstract pullback.
  Step 2 (`SheafOfModules.sheafificationCompPullback`): move the pullback inside the
    sheafification (sheafification commutes with pullback).
  Step 3: strip the outer sheafification (`.mapIso`), descending to the presheaf goal
    `(pullback φ).obj (M.val ⊗ₚ N.val) ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`.
  Step 4: close that presheaf goal by **H1 ∘ H2**:
    • H1 (the sole Mathlib-ABSENT ingredient, BUILT this iter): the presheaf-level iso
      `pushforward β ≅ pullback φ`, obtained from the de-sheafified presheaf
      `PresheafOfModules.pushforwardPushforwardAdj` (adjunction along the open-immersion
      pair `f.opensFunctor ⊣ Opens.map f.base`) against the existing
      `pullbackPushforwardAdjunction` via `Adjunction.leftAdjointUniq`. Here `β` is the
      `restrictFunctor` structure map, so `(M.restrict f).val = (pushforward β).obj M.val`
      definitionally.
    • H2 (strong-monoidal tensorator): `pushforward β = pushforward₀ ⋙ restrictScalars β`
      with `β` sectionwise the open-immersion ring ISO `f.appIso`, so `restrictScalars β`
      is STRONG monoidal (`restrictScalarsMonoidalOfBijective`, resting on the closed
      `restrictScalarsRingIsoTensorEquiv` / `restrictScalars_isIso_{μ,ε}`); the composite
      `μIso` is the tensorator.
The superseded `Localization.Monoidal` / `J.W.IsMonoidal` route is NOT used. -/
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
  -- Step 4 (RESIDUAL CLOSURE — iter-217 H1 build). The remaining presheaf goal is
  --   `(PresheafOfModules.pullback φ).obj (M.val ⊗ₚ N.val)
  --      ≅ (M.restrict f).val ⊗ₚ (N.restrict f).val`
  -- where `φ = (Scheme.Hom.toRingCatSheafHom f).hom` and `⊗ₚ =
  -- PresheafOfModules.Monoidal.tensorObj`. We close it via:
  --  (H1, the linchpin) the presheaf-level iso `pushforward β ≅ pullback φ`, built from
  --      the presheaf `pushforwardPushforwardAdj` (above) against the existing
  --      `pullbackPushforwardAdjunction` via `leftAdjointUniq`. Here `β` is the
  --      open-immersion structure map of `restrictFunctor f`, so
  --      `(M.restrict f).val = (pushforward β).obj M.val` definitionally.
  --  (H2) the strong-monoidal comparison `(pushforward β).obj (A ⊗ₚ B) ≅
  --      (pushforward β).obj A ⊗ₚ (pushforward β).obj B`.
  -- `φR` (the scheme structure map) and `β` (the restrictFunctor structure map) are kept as
  -- `let`-bindings (zeta-transparent) so the unit/counit triangle goals below reduce; the
  -- open-immersion adjunction is INLINED for the same reason (a `have` would make `adj.unit`
  -- opaque and block the `congr` defeq, exactly as in Mathlib's sheaf-level `restrictAdjunction`).
  let φR := (Scheme.Hom.toRingCatSheafHom f).hom
  -- The restrictFunctor structure map `β` (so `(M.restrict f).val = (pushforward β).obj M.val`).
  let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
    { app := fun U => (f.appIso U.unop).inv }
  let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight α (forget₂ CommRingCat RingCat)
  -- H1 via the presheaf pushforward-pushforward adjunction + `leftAdjointUniq`.
  have hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φR :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φR
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let H1 := hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)
  refine (H1.app (PresheafOfModules.Monoidal.tensorObj M.val N.val)).symm ≪≫ ?_
  -- H2: the strong-monoidal tensorator of `pushforward β = pushforward₀ ⋙ restrictScalars β`.
  -- `β` is sectionwise bijective (it is the `forget₂`-image of the open-immersion structure ring
  -- ISO `f.appIso`), so `restrictScalars β` is STRONG monoidal (`restrictScalarsMonoidalOfBijective`),
  -- and `pushforward₀OfCommRingCat` is `Monoidal` (Mathlib); the composite's `μIso` is the tensorator.
  -- It is built over the SYNTACTIC `_ ⋙ forget₂` base form (where the `MonoidalCategory` instance is
  -- found canonically); the result is DEFEQ to the goal — whose base `X.ringCatSheaf.obj` is only
  -- defeq, not syntactically, `X.presheaf ⋙ forget₂` — and `(pushforward β).obj M.val =
  -- (M.restrict f).val` definitionally, so `exact` closes it without any instance diamond.
  have hβ : ∀ U, Function.Bijective (β.app U).hom := by
    intro U
    haveI : IsIso (β.app U) :=
      inferInstanceAs (IsIso ((forget₂ CommRingCat RingCat).map (f.appIso U.unop).inv))
    exact ConcreteCategory.bijective_of_isIso (β.app U)
  let β' : (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (f.opensFunctor.op ⋙ X.presheaf) ⋙ forget₂ CommRingCat RingCat := β
  haveI : (PresheafOfModules.restrictScalars β').Monoidal :=
    PresheafOfModules.restrictScalarsMonoidalOfBijective β' hβ
  exact (Functor.Monoidal.μIso
    (PresheafOfModules.pushforward₀OfCommRingCat f.opensFunctor X.presheaf
      ⋙ PresheafOfModules.restrictScalars β')
    (M.val : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))
    (N.val : _root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat))).symm

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
§2).

**iter-218 INCOMPLETE gate (INFRASTRUCTURE MISSING).** The blueprint route sets
`Linv := ℋom_{𝒪_X}(L, 𝒪_X)` (the internal-hom dual) and uses the evaluation
`L ⊗_X Linv → 𝒪_X`. Both are Mathlib-ABSENT at `b80f227`: there is no
`MonoidalClosed (PresheafOfModules R)` and no `MonoidalClosed (SheafOfModules R)`
instance, and no `SheafOfModules`-level internal-hom / dual / evaluation object
(`CategoryTheory.sheafHom` lands in `Sheaf J (Type …)`, carrying no module
structure). The categorical "invertible object ⇒ inverse" escape is unavailable
by design (no `MonoidalCategory (X.Modules)` for the varying structure sheaf, see
§2). The object-gluing fallback (assemble a global `Linv` from local `𝒪_{U_i}`
along `g_{ij}⁻¹`) needs object-level descent for `SheafOfModules`, also absent.
The construction is blocked at its FIRST step — `Linv` cannot even be named — so
no tactic state can be advanced; per the INCOMPLETE gate we do NOT push a
`dual`-shaped helper-sorry forward (the iter-214 d.1 anti-pattern). The two
downstream ingredients (local-triviality of `Linv`; the local-iso-⇒-global-iso
contraction via the CLOSED `tensorObj_restrict_iso` + `tensorObj_unit_iso`,
mirroring `tensorObj_isLocallyTrivial` at L1349) are available and waiting on the
dual. EXACT missing primitive + full decomposition: `informal/exists_tensorObj_inverse.md`.
-/
lemma exists_tensorObj_inverse {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    ∃ Linv : X.Modules, LineBundle.IsLocallyTrivial Linv ∧
      Nonempty (tensorObj L Linv ≅ SheafOfModules.unit X.ringCatSheaf) :=
  -- BLOCKED at step 1: the dual `Linv := ℋom_{𝒪_X}(L, 𝒪_X)` has no
  -- `SheafOfModules`-level construction (no `MonoidalClosed`/internal-hom on
  -- `PresheafOfModules`/`SheafOfModules`; no object-level descent). See the
  -- docstring and `informal/exists_tensorObj_inverse.md` for the exact missing
  -- primitive (internal-hom/dual + evaluation, the mathlib-analogist target).
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
`PicSharp.addCommGroup` instance in `RelPicFunctor.lean`.

iter-218 note: `@[implicit_reducible]` is RETAINED (the plan directive to drop it
was not applied): being a `def` of class type `AddCommGroup`, dropping it triggers
the "class type must be marked `@[reducible]`/`@[implicit_reducible]`" linter and
adds a warning, so retaining it keeps the build clean. -/
@[implicit_reducible]
noncomputable def addCommGroup_via_tensorObj {S C T : Scheme.{u}}
    (πC : C ⟶ S) (πT : T ⟶ S) :
    AddCommGroup (Quotient (RelPicPresheaf.preimage_subgroup πC πT)) :=
  sorry

end PicSharp

end Scheme

end AlgebraicGeometry
