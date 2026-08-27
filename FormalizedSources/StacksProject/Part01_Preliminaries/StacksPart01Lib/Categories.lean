import Mathlib.CategoryTheory.Groupoid
import Mathlib.CategoryTheory.Iso
import Mathlib.CategoryTheory.Limits.Constructions.LimitsOfProductsAndEqualizers
import Mathlib.CategoryTheory.Yoneda

universe u v w

/-!
# StacksPart01Lib.Categories

Basic categorical facts corresponding to Stacks tags 0017, 0018, and 003B.
-/

namespace StacksPart01Lib

open CategoryTheory

/-- The Yoneda correspondence identifies natural transformations from a
representable functor with the value of the target functor (Stacks, Tag 001P).
-/
noncomputable def yoneda_equiv {C : Type u} [Category.{v} C] {X : C}
    {F : Cᵒᵖ ⥤ Type v} :
    (yoneda.obj X ⟶ F) ≃ F.obj (Opposite.op X) := by
  exact CategoryTheory.yonedaEquiv

/-!
An isomorphism is exactly a morphism admitting a two-sided inverse.  This is
the explicit form of the definition used in Stacks tag 0017.
-/
theorem isIso_iff_exists_inverse {C : Type*} [Category C] {X Y : C}
    (f : X ⟶ Y) :
    IsIso f ↔ ∃ g : Y ⟶ X, f ≫ g = 𝟙 X ∧ g ≫ f = 𝟙 Y := by
  constructor
  · intro hf
    letI : IsIso f := hf
    exact ⟨inv f, IsIso.hom_inv_id f, IsIso.inv_hom_id f⟩
  · rintro ⟨g, hfg, hgf⟩
    exact IsIso.mk ⟨g, hfg, hgf⟩

/-!
The inverse in tag 0017 is unique.
-/
theorem inverse_unique {C : Type*} [Category C] {X Y : C} {f : X ⟶ Y}
    {g h : Y ⟶ X}
    (hg : f ≫ g = 𝟙 X ∧ g ≫ f = 𝟙 Y)
    (hh : f ≫ h = 𝟙 X ∧ h ≫ f = 𝟙 Y) :
    g = h := by
  calc
    g = 𝟙 Y ≫ g := by simp
    _ = (h ≫ f) ≫ g := by rw [hh.2]
    _ = h ≫ (f ≫ g) := by simp only [Category.assoc]
    _ = h ≫ 𝟙 X := by rw [hg.1]
    _ = h := by simp

/-!
A category is a groupoid precisely when all of its morphisms are invertible,
the formulation of Stacks tag 0018.
-/
theorem isGroupoid_iff_all_isIso {C : Type*} [Category C] :
    IsGroupoid C ↔ ∀ {X Y : C} (f : X ⟶ Y), IsIso f := by
  constructor
  · intro h X Y f
    letI : IsGroupoid C := h
    exact IsGroupoid.all_isIso f
  · intro h
    exact IsGroupoid.mk h

/-!
Invertible morphisms are both monomorphisms and epimorphisms, as in the basic
mono/epi discussion of Stacks tag 003B.
-/
theorem isIso_mono_of {C : Type*} [Category C] {X Y : C} (f : X ⟶ Y)
    [IsIso f] : Mono f := by infer_instance

theorem isIso_epi_of {C : Type*} [Category C] {X Y : C} (f : X ⟶ Y)
    [IsIso f] : Epi f := by infer_instance

/- Products and equalizers suffice to construct all limits (Stacks, Tag 002N). -/
theorem hasLimitsOfProductsAndEqualizers
    (C : Type u) [Category.{v} C] [Limits.HasProducts.{w} C]
    [Limits.HasEqualizers C] : Limits.HasLimitsOfSize.{w, w} C :=
  Limits.has_limits_of_hasEqualizers_and_products

/- Coproducts and coequalizers suffice to construct all colimits
(Stacks, Tag 002P). -/
theorem hasColimitsOfCoproductsAndCoequalizers
    (C : Type u) [Category.{v} C] [Limits.HasCoproducts.{w} C]
    [Limits.HasCoequalizers C] : Limits.HasColimitsOfSize.{w, w} C :=
  Limits.has_colimits_of_hasCoequalizers_and_coproducts

end StacksPart01Lib
