/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.AlgebraicGeometry.Group.Abelian

/-!
# Isogenies

For a homomorphism of group schemes over a field, the kernel is the fibre over
the identity section.  The predicate below records the source-faithful
surjective-and-finite-kernel condition using Mathlib's scheme morphism
properties.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory MonObj
open AlgebraicGeometry

namespace MilneLib

variable {K : Type u} [Field K]
variable {A B : Over (Spec (.of K))} [GrpObj A] [GrpObj B]

/-- The kernel scheme of a group-scheme homomorphism, as the fibre over the identity. -/
noncomputable def isogenyKernel (f : A ⟶ B) : Scheme :=
  pullback f.left (η[B].left)

/-- The structure morphism of the kernel scheme over the base field. -/
noncomputable def isogenyKernelToBase (f : A ⟶ B) :
    isogenyKernel f ⟶ Spec (.of K) :=
  pullback.snd f.left (η[B].left)

/-- A surjective group-scheme homomorphism with finite kernel. -/
def Isogeny (f : A ⟶ B) [IsMonHom f] : Prop :=
  Surjective f.left ∧ IsFinite (isogenyKernelToBase f)

/-- The homomorphism on global sections induced by a homomorphism of group schemes. -/
noncomputable def homSectionMap (f : A ⟶ B) [IsMonHom f] :
    (𝟙_ (Over (Spec (.of K))) ⟶ A) →*
      (𝟙_ (Over (Spec (.of K))) ⟶ B) :=
  { toFun := fun a => a ≫ f
    map_one' := by
      rw [Hom.one_def, Category.assoc, IsMonHom.one_hom, Hom.one_def]
    map_mul' := by
      intro a b
      rw [Hom.mul_def, Category.assoc, IsMonHom.mul_hom, Hom.mul_def]
      simp }

/-- Every section fibre of a group-scheme homomorphism is equivalent to its kernel. -/
noncomputable def homSectionFiberEquivKernel
    (f : A ⟶ B) [IsMonHom f]
    (a₀ : 𝟙_ (Over (Spec (.of K))) ⟶ A) :
    (homSectionMap f ⁻¹' {homSectionMap f a₀}) ≃ (homSectionMap f).ker :=
  MonoidHom.fiberEquivKer (homSectionMap f) a₀

/-- Finiteness of a section fibre is equivalent to finiteness of the section kernel. -/
theorem homSectionFiber_finite_iff_kernel_finite
    (f : A ⟶ B) [IsMonHom f]
    (a₀ : 𝟙_ (Over (Spec (.of K))) ⟶ A) :
    Finite (homSectionMap f ⁻¹' {homSectionMap f a₀}) ↔
      Finite (homSectionMap f).ker := by
  exact (homSectionFiberEquivKernel f a₀).finite_iff

/-- A finite section kernel gives finite section fibres at every chosen section. -/
theorem homSectionFiber_finite_of_kernel_finite
    (f : A ⟶ B) [IsMonHom f]
    (a₀ : 𝟙_ (Over (Spec (.of K))) ⟶ A)
    [Finite (homSectionMap f).ker] :
    Finite (homSectionMap f ⁻¹' {homSectionMap f a₀}) := by
  exact Finite.of_equiv _ (homSectionFiberEquivKernel f a₀).symm

/-- The identity homomorphism is an isogeny. -/
@[simp]
theorem Isogeny.id (A : Over (Spec (.of K))) [GrpObj A] :
    Isogeny (𝟙 A) := by
  constructor
  · infer_instance
  · dsimp [isogenyKernelToBase, isogenyKernel]
    infer_instance

/- An isomorphism of group schemes has trivial (hence finite) kernel.  The
   explicit forgetful transport is needed because the slice-category `IsIso`
   instance is not reducible through `Over.Hom.left` during synthesis. -/
theorem Isogeny.of_isIso (f : A ⟶ B) [IsMonHom f] [IsIso f] :
    Isogeny f := by
  letI : IsIso f.left := (Over.forget (Spec (CommRingCat.of K))).map_isIso f
  constructor
  · infer_instance
  · dsimp [isogenyKernelToBase, isogenyKernel]
    infer_instance

/- When the underlying homomorphisms are finite, the usual closure of finite
   and surjective morphisms under composition gives the corresponding
   isogeny.  The finite-map hypotheses are explicit until the full
   finite-kernel-to-finite-map theorem is available in Mathlib. -/
theorem Isogeny.comp_of_finite
    {C : Over (Spec (.of K))} [GrpObj C]
    (f : A ⟶ B) (g : B ⟶ C) [IsMonHom f] [IsMonHom g]
    [IsFinite f.left] [IsFinite g.left]
    (hf : Isogeny f) (hg : Isogeny g) :
    Isogeny (f ≫ g) := by
  letI : Surjective f.left := hf.1
  letI : Surjective g.left := hg.1
  constructor
  · rw [Over.comp_left]
    infer_instance
  · dsimp [isogenyKernelToBase, isogenyKernel]
    haveI : IsFinite ((f ≫ g).left) := by
      rw [Over.comp_left]
      infer_instance
    infer_instance

/- Composition with an isomorphism is a useful specialization of the finite
   composition lemma: the underlying map of the isomorphism is finite after
   transporting its `IsIso` instance through the slice forgetful functor. -/
theorem Isogeny.comp_of_isIso_left
    {C : Over (Spec (.of K))} [GrpObj C]
    (f : A ⟶ B) (g : B ⟶ C) [IsMonHom f] [IsMonHom g]
    [IsIso f] [IsFinite g.left] (hg : Isogeny g) :
    Isogeny (f ≫ g) := by
  letI : IsIso f.left := (Over.forget (Spec (CommRingCat.of K))).map_isIso f
  letI : IsFinite f.left := inferInstance
  exact Isogeny.comp_of_finite f g (Isogeny.of_isIso f) hg

theorem Isogeny.comp_of_isIso_right
    {C : Over (Spec (.of K))} [GrpObj C]
    (f : A ⟶ B) (g : B ⟶ C) [IsMonHom f] [IsMonHom g]
    [IsFinite f.left] [IsIso g] (hf : Isogeny f) :
    Isogeny (f ≫ g) := by
  letI : IsIso g.left := (Over.forget (Spec (CommRingCat.of K))).map_isIso g
  letI : IsFinite g.left := inferInstance
  exact Isogeny.comp_of_finite f g hf (Isogeny.of_isIso g)

omit [GrpObj A] in
/-- Finiteness of the underlying map makes the kernel finite by base change. -/
theorem isogenyKernelToBase_isFinite_of_finite
    (f : A ⟶ B) [IsFinite f.left] :
    IsFinite (isogenyKernelToBase f) := by
  change IsFinite (pullback.snd f.left (η[B].left))
  exact CategoryTheory.MorphismProperty.pullback_snd _ _
    (inferInstance : IsFinite f.left)

omit [GrpObj A] in
/-- Flatness of a homomorphism is inherited by its kernel over the identity. -/
theorem isogenyKernelToBase_flat_of_flat
    (f : A ⟶ B) [Flat f.left] :
    Flat (isogenyKernelToBase f) := by
  change Flat (pullback.snd f.left (η[B].left))
  exact CategoryTheory.MorphismProperty.pullback_snd _ _
    (inferInstance : Flat f.left)

omit [GrpObj A] in
/-- Surjectivity of a homomorphism is inherited by its kernel over the identity. -/
theorem isogenyKernelToBase_surjective_of_surjective
    (f : A ⟶ B) [Surjective f.left] :
    Surjective (isogenyKernelToBase f) := by
  change Surjective (pullback.snd f.left (η[B].left))
  exact CategoryTheory.MorphismProperty.pullback_snd _ _
    (inferInstance : Surjective f.left)

/- A proper morphism with finite set-theoretic fibres is finite.  This is the
   geometric bridge used in the finite-kernel direction of Milne's
   characterization; the separate group-theoretic argument identifying all
   fibres with translates of the kernel is intentionally left explicit. -/
theorem IsFinite.of_isProper_of_finite_preimage_singleton
    {X Y : Scheme.{u}} (f : X ⟶ Y) [IsProper f]
    (hfib : ∀ y : Y, (f ⁻¹' {y}).Finite) : IsFinite f := by
  letI : LocallyQuasiFinite f :=
    LocallyQuasiFinite.of_finite_preimage_singleton f hfib
  exact IsFinite.of_isProper_of_locallyQuasiFinite f

/- A finite underlying morphism has finite kernel, so in this common case the
   isogeny predicate is exactly surjectivity.  The finite-map hypothesis is
   explicit because the general finite-kernel/finite-map equivalence is not
   available in the current Mathlib API. -/
theorem Isogeny.of_surjective_of_finite
    (f : A ⟶ B) [IsMonHom f] [IsFinite f.left]
    (hf : Surjective f.left) : Isogeny f := by
  exact ⟨hf, isogenyKernelToBase_isFinite_of_finite f⟩

theorem Isogeny.iff_surjective_of_finite
    (f : A ⟶ B) [IsMonHom f] [IsFinite f.left] :
    Isogeny f ↔ Surjective f.left := by
  constructor
  · intro h
    exact h.1
  · exact Isogeny.of_surjective_of_finite f

theorem Isogeny.surjective (f : A ⟶ B) [IsMonHom f] (h : Isogeny f) :
    Surjective f.left :=
  h.1

theorem Isogeny.finite_kernel (f : A ⟶ B) [IsMonHom f] (h : Isogeny f) :
    IsFinite (isogenyKernelToBase f) :=
  h.2

/- The finite-flat-surjective condition from Milne's characterization implies
   the source-faithful isogeny predicate.  The flatness hypothesis is retained
   in the interface because it is part of the geometric characterization and
   is used by the companion kernel lemma below. -/
theorem Isogeny.of_finite_flat_surjective
    (f : A ⟶ B) [IsMonHom f] [IsFinite f.left] [Flat f.left]
    (hf : Surjective f.left) : Isogeny f := by
  exact Isogeny.of_surjective_of_finite f hf

/- A flat isogeny has a finite, flat, and surjective kernel over the base. -/
theorem Isogeny.kernel_isFinite_flat_surjective
    (f : A ⟶ B) [IsMonHom f] [Flat f.left] (h : Isogeny f) :
    IsFinite (isogenyKernelToBase f) ∧
      Flat (isogenyKernelToBase f) ∧ Surjective (isogenyKernelToBase f) := by
  letI : Surjective f.left := h.1
  exact ⟨h.2, isogenyKernelToBase_flat_of_flat f,
    isogenyKernelToBase_surjective_of_surjective f⟩

end MilneLib
