/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0GaloisInvariantComparison

/-!
# The finite-Galois invariance match for Picard zero

This module identifies deck invariance of a Picard-zero class with equivariance
of its representing morphism for the canonical semilinear Galois action.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite
open AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry

noncomputable section

variable {K L : Type u} [Field K] [Field L] [Algebra K L]

/-! ## The two slice presentations of a deck transformation -/

/-- The deck transformation of a base-changed test, packaged as a morphism in
the slice over `Spec L`. -/
noncomputable def pic0GalTwistMor
    (T : Over (Spec (CommRingCat.of K))) (gamma : L ≃ₐ[K] L) :
    (pic0TwistTestFunctor gamma).obj (baseTest (k' := L) T) ⟶
      baseTest (k' := L) T :=
  Over.homMk (pullbackGalMap K L T.hom gamma)
    (pullbackGalMap_snd K L T.hom gamma)

@[simp]
theorem pic0GalTwistMor_left
    (T : Over (Spec (CommRingCat.of K))) (gamma : L ≃ₐ[K] L) :
    (pic0GalTwistMor T gamma).left = pullbackGalMap K L T.hom gamma :=
  rfl

/-- The inverse comparison from a twisted `L`-test to the original test is the
identity on underlying schemes. -/
theorem pic0GaloisRestrictTwistIso_inv_app_left
    (gamma : L ≃ₐ[K] L) (D : Over (Spec (CommRingCat.of L))) :
    ((pic0GaloisRestrictTwistIso gamma).inv.app D).left = 𝟙 D.left := by
  have h := congrArg Over.Hom.left
    ((pic0GaloisRestrictTwistIso gamma).hom_inv_id_app D)
  rw [Over.comp_left, pic0GaloisRestrictTwistIso_hom_app_left] at h
  have hfixed : @Eq (D.left ⟶ D.left)
      (𝟙 D.left ≫ ((pic0GaloisRestrictTwistIso gamma).inv.app D).left)
      (𝟙 D.left) := h
  rw [Category.id_comp] at hfixed
  exact hfixed

/-- The `K`-slice deck transformation indexed by `gamma⁻¹` is the restriction
of the `L`-slice deck transformation indexed by `gamma`, after the canonical
identity-underlying comparison of their sources. -/
theorem twistTest_eq_pic0GaloisRestrict_galTwistMor
    (T : Over (Spec (CommRingCat.of K))) (gamma : L ≃ₐ[K] L) :
    twistTest T gamma⁻¹ =
      (pic0GaloisRestrictTwistIso gamma).inv.app (baseTest (k' := L) T) ≫
        (pic0GaloisRestrictTest (k := K) (L := L)).map
          (pic0GalTwistMor T gamma) := by
  apply Over.OverMorphism.ext
  rw [Over.comp_left, pic0GaloisRestrictTwistIso_inv_app_left,
    Over.map_map_left, pic0GalTwistMor_left]
  have hfixed : @Eq
      (Limits.pullback T.hom (specMapAlgebra K L) ⟶
        Limits.pullback T.hom (specMapAlgebra K L))
      (𝟙 _ ≫ pullbackGalMap K L T.hom gamma)
      (pullbackGalMap K L T.hom gamma) :=
    Category.id_comp _
  exact hfixed.symm

/-! ## Equivariance as a slice square -/

section Representative

variable (C : Over (Spec (CommRingCat.of K)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {J : Over (Spec (CommRingCat.of L))}
  (rep : (pic0TypeFunctor ((baseChange K L).obj C)).RepresentableBy J)

set_option maxHeartbeats 1000000 in
/-- Equivariance for the canonical action is exactly the corresponding square
in the slice over `Spec L`. -/
theorem pic0_isEquivariant_iff_galTwistMor
    (T : Over (Spec (CommRingCat.of K)))
    (phi : baseTest (k' := L) T ⟶ J) :
    (pullbackSemilinearGalAction K L T.hom).IsEquivariant
        (pic0SemilinearGalActionOfRepresentableBy C rep) phi.left ↔
      ∀ gamma : L ≃ₐ[K] L,
        pic0GalTwistMor T gamma ≫ phi =
          (pic0TwistTestFunctor gamma).map phi ≫
            pic0GaloisTwistMor C rep gamma := by
  constructor
  · intro h gamma
    exact Over.OverMorphism.ext (h gamma)
  · intro h gamma
    exact congrArg Over.Hom.left (h gamma)

end Representative

end

end AlgebraicGeometry
