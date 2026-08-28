/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import Mathlib.AlgebraicGeometry.Group.Abelian

/-!
# Group schemes and translations

This file records the group-object part of Mumford's definition of an abelian
variety.  A section of a group scheme can be moved to any other section by a
canonical right translation.  The construction is completely categorical, so
the same lemmas are available for group objects in any cartesian monoidal
category.

The final predicate keeps the geometric hypotheses used by the standard
commutativity theorem visible: a proper geometrically integral group scheme
over a field is commutative.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe v u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj

namespace Mumford

namespace GroupScheme

section Categorical

variable {C : Type u} [Category.{v} C] [CartesianMonoidalCategory C]
  {G : C} [GrpObj G] {X : C}

/-- The cartesian identity underlying the rigidity lemma: collapsing the first
variable to a chosen point can be written using either projection. -/
theorem rigidity_snd_lift
    {X Y : C} (x₀ : 𝟙_ C ⟶ X) :
    snd X Y ≫ lift (toUnit Y ≫ x₀) (𝟙 Y) =
      lift (toUnit (X ⊗ Y) ≫ x₀) (snd X Y) := by
  ext1 <;> simp

/-- The group-valued functor of points of a group object. -/
abbrev pointsFunctor (G : C) [GrpObj G] : Cᵒᵖ ⥤ GrpCat :=
  CategoryTheory.yonedaGrpObj G

/-- The functor of points is represented by the underlying group object. -/
def pointsFunctor_representable (G : C) [GrpObj G] :
    (pointsFunctor G ⋙ CategoryTheory.forget GrpCat).RepresentableBy G :=
  CategoryTheory.yonedaGrpObjRepresentableBy G

/-- The Yoneda functor from group objects to group-valued functors is fully faithful. -/
def pointsYoneda : Grp C ⥤ Cᵒᵖ ⥤ GrpCat :=
  CategoryTheory.yonedaGrp

def pointsYoneda_fullyFaithful : (pointsYoneda (C := C)).FullyFaithful :=
  CategoryTheory.yonedaGrpFullyFaithful

/-- Composition with a right translation is multiplication in the Hom-group. -/
theorem comp_mulRight_hom (f : X ⟶ G) (g : 𝟙_ C ⟶ G) :
    f ≫ (GrpObj.mulRight g).hom = f * (toUnit X ≫ g) := by
  rw [GrpObj.mulRight_hom, comp_lift_assoc, Category.comp_id,
    comp_toUnit_assoc, CategoryTheory.Hom.mul_def]

/-- Composition with the inverse right translation is multiplication by the inverse. -/
theorem comp_mulRight_inv (f : X ⟶ G) (g : 𝟙_ C ⟶ G) :
    f ≫ (GrpObj.mulRight g).inv = f * (toUnit X ≫ g)⁻¹ := by
  rw [GrpObj.mulRight_inv, comp_lift_assoc, Category.comp_id,
    ← Category.assoc, comp_toUnit, CategoryTheory.Hom.mul_def,
    CategoryTheory.Hom.inv_def, Category.assoc]

/-- The translation carrying the section `x` to the section `y`. -/
def pointTranslation (G : C) [GrpObj G] (x y : 𝟙_ C ⟶ G) : G ≅ G :=
  (GrpObj.mulRight x).symm ≪≫ GrpObj.mulRight y

@[simp]
theorem pointTranslation_self (x : 𝟙_ C ⟶ G) :
    pointTranslation G x x = Iso.refl G := by
  simp [pointTranslation]

@[simp]
theorem pointTranslation_symm (x y : 𝟙_ C ⟶ G) :
    (pointTranslation G x y).symm = pointTranslation G y x := by
  simp [pointTranslation]

@[simp]
theorem pointTranslation_trans (x y z : 𝟙_ C ⟶ G) :
    pointTranslation G x y ≪≫ pointTranslation G y z = pointTranslation G x z := by
  simp [pointTranslation, Iso.trans_assoc]

@[reassoc (attr := simp)]
theorem comp_pointTranslation_hom (x y : 𝟙_ C ⟶ G) :
    x ≫ (pointTranslation G x y).hom = y := by
  rw [pointTranslation, Iso.trans_hom, Iso.symm_hom, ← Category.assoc,
    comp_mulRight_inv, comp_mulRight_hom, toUnit_unit,
    Category.id_comp, Category.id_comp, mul_inv_cancel, _root_.one_mul]

end Categorical

section RigidityGeometry

open AlgebraicGeometry

variable {kbar : Type u} [Field kbar]

/-- Properness of the first factor makes the second projection a closed map.

The underlying scheme morphism is the pullback of `X.hom` along `Y.hom`; this
is the geometric input used in the closed-map proof of Mumford's rigidity
lemma. -/
theorem snd_left_isClosedMap
    {X Y : Over (Spec (.of kbar))} [IsProper X.hom] :
    IsClosedMap (snd X Y).left.base := by
  haveI hp : UniversallyClosed X.hom := IsProper.toUniversallyClosed
  haveI : UniversallyClosed (snd X Y).left := by
    rw [Over.snd_left]
    exact universallyClosed_isStableUnderBaseChange.of_isPullback
      (IsPullback.of_hasPullback X.hom Y.hom) hp
  exact Scheme.Hom.isClosedMap _

end RigidityGeometry

section ClosedPointExtensionality

open AlgebraicGeometry

variable {W Z : Scheme.{u}} [IsReduced W] [JacobsonSpace W] [Z.IsSeparated]

/-- Two morphisms from a reduced Jacobson scheme into a separated scheme are
equal when their residue-field probes agree at every closed point. -/
theorem morphism_eq_of_eqAt_closedPoints
    {g₁ g₂ : W ⟶ Z}
    (h : ∀ x ∈ closedPoints W,
      W.fromSpecResidueField x ≫ g₁ = W.fromSpecResidueField x ≫ g₂) :
    g₁ = g₂ := by
  let F : closedPoints W → Scheme.{u} := fun x => Spec (W.residueField x.1)
  let probe : (∐ F) ⟶ W := Sigma.desc fun x => W.fromSpecResidueField x.1
  haveI : IsDominant probe := by
    refine ⟨(dense_iff_closure_eq.mpr (closure_closedPoints (X := W))).mono ?_⟩
    intro x hx
    obtain ⟨pt⟩ : Nonempty (Spec (W.residueField x)) := inferInstance
    refine ⟨(Sigma.ι F ⟨x, hx⟩).base pt, ?_⟩
    have hcomp : Sigma.ι F ⟨x, hx⟩ ≫ probe = W.fromSpecResidueField x :=
      Sigma.ι_desc _ _
    have e1 : probe.base ((Sigma.ι F ⟨x, hx⟩).base pt) =
        (W.fromSpecResidueField x).base pt := by
      rw [← Scheme.Hom.comp_apply, hcomp]
    rw [e1]
    exact Set.eq_of_mem_singleton
      (Scheme.range_fromSpecResidueField x ▸ Set.mem_range_self pt)
  refine ext_of_isDominant probe (Sigma.hom_ext _ _ fun x => ?_)
  rw [← Category.assoc, ← Category.assoc, Sigma.ι_desc]
  exact h x.1 x.2

end ClosedPointExtensionality

section Scheme

open AlgebraicGeometry

variable {S : Scheme.{u}} (G : Over S) [GrpObj G]

/-- The underlying-scheme isomorphism induced by a translation of sections. -/
noncomputable def pointTranslationIso (x y : 𝟙_ (Over S) ⟶ G) : G.left ≅ G.left :=
  (Over.forget S).mapIso (pointTranslation G x y)

@[simp]
theorem pointTranslationIso_hom (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).hom = (pointTranslation G x y).hom.left :=
  rfl

@[simp]
theorem pointTranslationIso_inv (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).inv = (pointTranslation G x y).inv.left :=
  rfl

@[simp]
theorem pointTranslationIso_self (x : 𝟙_ (Over S) ⟶ G) :
    pointTranslationIso G x x = Iso.refl G.left := by
  apply Iso.ext
  simp [pointTranslationIso]

@[simp]
theorem pointTranslationIso_symm (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).symm = pointTranslationIso G y x := by
  apply Iso.ext
  simp [pointTranslationIso, pointTranslation]

@[simp]
theorem pointTranslationIso_trans (x y z : 𝟙_ (Over S) ⟶ G) :
    pointTranslationIso G x y ≪≫ pointTranslationIso G y z =
      pointTranslationIso G x z := by
  apply Iso.ext
  simp [pointTranslationIso, pointTranslation, Iso.trans_assoc]

@[reassoc (attr := simp)]
theorem pointTranslationIso_hom_comp (x y : 𝟙_ (Over S) ⟶ G) :
    (pointTranslationIso G x y).hom ≫ G.hom = G.hom :=
  Over.w _

@[simp]
theorem pointTranslationIso_hom_apply (x y : 𝟙_ (Over S) ⟶ G) (s : S) :
    (pointTranslationIso G x y).hom (x.left s) = y.left s := by
  rw [pointTranslationIso_hom, ← Scheme.Hom.comp_apply, ← Over.comp_left,
    comp_pointTranslation_hom]

end Scheme

section Transport

open AlgebraicGeometry

/-- Smooth-locus membership is invariant under an automorphism over the base. -/
theorem mem_smoothLocus_iff_of_comp_eq {X S : Scheme.{u}} (e : X ⟶ X) [IsOpenImmersion e]
    (f : X ⟶ S) [LocallyOfFinitePresentation f] (he : e ≫ f = f) (z : X) :
    e z ∈ f.smoothLocus ↔ z ∈ f.smoothLocus := by
  conv_lhs => rw [← Scheme.Hom.mem_preimage]
  rw [Scheme.Hom.preimage_smoothLocus_eq]
  simp only [he]

/-- Reducedness of a stalk is invariant under an open immersion. -/
theorem isReduced_stalk_iff_of_isOpenImmersion {X Y : Scheme.{u}} (e : X ⟶ Y)
    [IsOpenImmersion e] (z : X) :
    _root_.IsReduced (X.presheaf.stalk z) ↔ _root_.IsReduced (Y.presheaf.stalk (e z)) := by
  constructor
  · intro h
    exact isReduced_of_injective (asIso (e.stalkMap z)).commRingCatIsoToRingEquiv
      (asIso (e.stalkMap z)).commRingCatIsoToRingEquiv.injective
  · intro h
    exact isReduced_of_injective (asIso (e.stalkMap z)).commRingCatIsoToRingEquiv.symm
      (asIso (e.stalkMap z)).commRingCatIsoToRingEquiv.symm.injective

/-- Irreducibility of a subset is invariant under an isomorphism (preimage form). -/
theorem isIrreducible_preimage_iff_of_isIso {X Y : Scheme.{u}} (e : X ⟶ Y) [IsIso e]
    (t : Set Y) : IsIrreducible (e ⁻¹' t) ↔ IsIrreducible t := by
  have hcoe : ⇑(Scheme.homeoOfIso (asIso e)) = ⇑e := by
    rw [Scheme.coe_homeoOfIso, asIso_hom]
  constructor
  · intro hi
    have hsurj : Function.Surjective ⇑e := by
      rw [← hcoe]
      exact (Scheme.homeoOfIso (asIso e)).surjective
    have h2 := hi.image ⇑e e.continuous.continuousOn
    rwa [Set.image_preimage_eq t hsurj] at h2
  · intro ht
    refine ht.preimage ?_ ?_
    · rw [← hcoe]
      exact (Scheme.homeoOfIso (asIso e)).isOpenEmbedding
    · have hr : Set.range ⇑e = Set.univ := by
        rw [← hcoe]
        exact (Scheme.homeoOfIso (asIso e)).surjective.range_eq
      rw [hr, Set.inter_univ]
      exact ht.nonempty

/-- Translation preserves membership in the smooth locus of a group scheme. -/
theorem pointTranslationIso_mem_smoothLocus_iff {S : Scheme.{u}} (G : Over S) [GrpObj G]
    [LocallyOfFinitePresentation G.hom] (x y : 𝟙_ (Over S) ⟶ G) (z : G.left) :
    (pointTranslationIso G x y).hom z ∈ G.hom.smoothLocus ↔ z ∈ G.hom.smoothLocus :=
  mem_smoothLocus_iff_of_comp_eq _ G.hom (pointTranslationIso_hom_comp G x y) z

/-- Translation preserves reducedness of the local ring at a point. -/
theorem isReduced_stalk_pointTranslationIso_iff {S : Scheme.{u}} (G : Over S) [GrpObj G]
    (x y : 𝟙_ (Over S) ⟶ G) (z : G.left) :
    _root_.IsReduced (G.left.presheaf.stalk z) ↔
      _root_.IsReduced (G.left.presheaf.stalk ((pointTranslationIso G x y).hom z)) :=
  isReduced_stalk_iff_of_isOpenImmersion _ z

/-- Irreducibility of subsets is preserved by translation. -/
theorem isIrreducible_pointTranslationIso_preimage_iff {S : Scheme.{u}} (G : Over S)
    [GrpObj G] (x y : 𝟙_ (Over S) ⟶ G) (t : Set G.left) :
    IsIrreducible ((pointTranslationIso G x y).hom ⁻¹' t) ↔ IsIrreducible t :=
  isIrreducible_preimage_iff_of_isIso _ t

end Transport

end GroupScheme

section AbelianVariety

open AlgebraicGeometry

variable {K : Type u} [Field K]

/-- The geometric part of Mumford's abelian-variety condition for a group scheme.

The group-object structure is supplied as a typeclass; the predicate records
completeness (properness) and geometric integrality separately. -/
def IsAbelianVariety (G : Over (Spec (.of K))) [GrpObj G] : Prop :=
  IsProper G.hom ∧ GeometricallyIntegral G.hom

theorem isCommMonObj_of_isAbelianVariety
    (G : Over (Spec (.of K))) [GrpObj G] (hG : IsAbelianVariety G) :
    IsCommMonObj G := by
  letI : IsProper G.hom := hG.1
  letI : GeometricallyIntegral G.hom := hG.2
  exact AlgebraicGeometry.isCommMonObj_of_isProper_of_geometricallyIntegral G

end AbelianVariety

end Mumford
