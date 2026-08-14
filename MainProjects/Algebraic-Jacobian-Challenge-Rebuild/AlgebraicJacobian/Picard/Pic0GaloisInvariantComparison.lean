/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.GaloisKernelCover
import AlgebraicJacobian.Picard.Pic0FiniteGaloisDescent
import AlgebraicJacobian.Picard.Pic0SigmaEtaleSheaf

/-!
# Finite-Galois invariant comparison for Picard zero
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite
open AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry

noncomputable section

open Scheme Scheme.PicScheme

variable {K L : Type u} [Field K] [Field L] [Algebra K L]
variable (C : Over (Spec (CommRingCat.of K)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

/-- Picard-zero classes on the finite-Galois base change of `T` fixed by every
deck transformation.  The classes are kept in the `K`-slice, where the deck
transformations are honest endomorphisms. -/
def Pic0GaloisInvariant (T : Over (Spec (CommRingCat.of K))) : Type u :=
  {x : (pic0TypeFunctor C).obj
      (op ((restrictTest K L).obj (baseTest (k' := L) T))) //
    ∀ gamma : L ≃ₐ[K] L,
      (pic0TypeFunctor C).map (twistTest T gamma).op x = x}

/-- Restriction of a Picard-zero class to the finite-Galois base change, with
its tautological invariance. -/
noncomputable def pic0RestrictToGaloisInvariant
    (T : Over (Spec (CommRingCat.of K)))
    (x : (pic0TypeFunctor C).obj (op T)) : Pic0GaloisInvariant (L := L) C T := by
  refine ⟨(pic0TypeFunctor C).map (coverMap (k' := L) T).op x, ?_⟩
  intro gamma
  rw [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
    twistTest_comp_coverMap]

/-- A Galois-invariant Picard-zero class satisfies the kernel-pair equality
for the field-extension cover. -/
theorem pic0GaloisInvariant_pullback_condition
    [FiniteDimensional K L] [IsGalois K L]
    (T : Over (Spec (CommRingCat.of K)))
    (x : Pic0GaloisInvariant (L := L) C T) :
    (pic0TypeFunctor C).map
        (pullback.fst (coverMap (k' := L) T) (coverMap (k' := L) T)).op x.1 =
      (pic0TypeFunctor C).map
        (pullback.snd (coverMap (k' := L) T) (coverMap (k' := L) T)).op x.1 := by
  let f := fun gamma : L ≃ₐ[K] L => coverSelfSection (k' := L) T gamma
  letI (gamma : L ≃ₐ[K] L) : IsOpenImmersion (f gamma).left :=
    isOpenImmersion_coverSelfSection_left (k' := L) T gamma
  have hcov : ∀ p : (pullback (coverMap (k' := L) T)
      (coverMap (k' := L) T)).left, ∃ gamma, p ∈ (f gamma).left.opensRange := by
    intro p
    obtain ⟨gamma, y, hy⟩ := coverSelfSection_jointlySurjective (k' := L) T p
    exact ⟨gamma, y, hy⟩
  apply pic0Subgroup_ext_of_cover (C := C) f hcov
  intro gamma
  change (pic0TypeFunctor C).map (f gamma).op
      ((pic0TypeFunctor C).map
        (pullback.fst (coverMap (k' := L) T) (coverMap (k' := L) T)).op x.1) = _
  calc
    _ = (pic0TypeFunctor C).map
        (f gamma ≫ pullback.fst (coverMap (k' := L) T)
          (coverMap (k' := L) T)).op x.1 := by
      rw [op_comp, Functor.map_comp]
      rfl
    _ = x.1 := by rw [coverSelfSection_fst]; rfl
    _ = (pic0TypeFunctor C).map (twistTest T gamma).op x.1 :=
      (x.2 gamma).symm
    _ = (pic0TypeFunctor C).map (f gamma).op
        ((pic0TypeFunctor C).map
          (pullback.snd (coverMap (k' := L) T) (coverMap (k' := L) T)).op x.1) := by
      rw [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
        coverSelfSection_snd]

/-- Galois invariance is the full compatibility condition for the
field-extension cover, not only the equality on its chosen pullback. -/
theorem pic0GaloisInvariant_compatible
    [FiniteDimensional K L] [IsGalois K L]
    (T : Over (Spec (CommRingCat.of K)))
    (x : Pic0GaloisInvariant (L := L) C T)
    {Z : Over (Spec (CommRingCat.of K))}
    (g₁ g₂ : Z ⟶ (restrictTest K L).obj (baseTest (k' := L) T))
    (h : g₁ ≫ coverMap (k' := L) T = g₂ ≫ coverMap (k' := L) T) :
    (pic0TypeFunctor C).map g₁.op x.1 =
      (pic0TypeFunctor C).map g₂.op x.1 := by
  let q : Z ⟶ pullback (coverMap (k' := L) T) (coverMap (k' := L) T) :=
    pullback.lift g₁ g₂ h
  calc
    (pic0TypeFunctor C).map g₁.op x.1 =
        (pic0TypeFunctor C).map q.op
          ((pic0TypeFunctor C).map
            (pullback.fst (coverMap (k' := L) T) (coverMap (k' := L) T)).op x.1) := by
      rw [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
        pullback.lift_fst]
    _ = (pic0TypeFunctor C).map q.op
          ((pic0TypeFunctor C).map
            (pullback.snd (coverMap (k' := L) T) (coverMap (k' := L) T)).op x.1) :=
      congrArg ((pic0TypeFunctor C).map q.op)
        (pic0GaloisInvariant_pullback_condition C T x)
    _ = (pic0TypeFunctor C).map g₂.op x.1 := by
      rw [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
        pullback.lift_snd]

end

end AlgebraicGeometry
