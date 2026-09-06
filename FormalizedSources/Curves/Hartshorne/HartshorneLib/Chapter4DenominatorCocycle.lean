/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DenominatorTransition
import HartshorneLib.Chapter2LineBundleGluing

/-!
# Cocycle of denominator trivializations

The denominator trivializations on the local-ratio cover have explicit
transition units.  This file packages their pairwise inverse and triple
overlap identities as the `LineBundleGluing.IsCocycle` datum used by the
subsequent pullback/gluing construction.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ} {ι : Type u}

namespace LocalRatioDenominatorCocycle

variable (a : ι → LocalRatioCoordinateData D n)
variable (r : (i : ι) → LocalRatioRegularization (a i))

/-- The transition unit from the `i`-denominator frame to the `j`-frame.

The inverse is supplied by the opposite denominator, so this definition does
not make any choice of inverse in the structure sheaf.
-/
def transitionUnit (i j : ι)
    (hij : (a i).SameSectionValues (a j)) :
    Γ(X.left, (a i).chart.U ⊓ (a j).chart.U)ˣ :=
  Units.mkOfMulEqOne
    (LocalRatioRegularization.restrictSection
      (inf_le_left : (a i).chart.U ⊓ (a j).chart.U ≤ (a i).chart.U)
      ((r i).regularized (a j).denominator_index))
    (LocalRatioRegularization.restrictSection
      (inf_le_right : (a i).chart.U ⊓ (a j).chart.U ≤ (a j).chart.U)
      ((r j).regularized (a i).denominator_index))
    ((r i).transition_mul_inverse (r j) hij)

@[simp] theorem transitionUnit_val (i j : ι)
    (hij : (a i).SameSectionValues (a j)) :
    (transitionUnit a r i j hij : Γ(X.left, (a i).chart.U ⊓ (a j).chart.U)) =
      LocalRatioRegularization.restrictSection
        (inf_le_left : (a i).chart.U ⊓ (a j).chart.U ≤ (a i).chart.U)
        ((r i).regularized (a j).denominator_index) := by
  exact Units.val_mkOfMulEqOne _

/-- The transition factors compose on a triple overlap. -/
theorem transitionUnit_triple_factorization
    {i j l : ι} (hij : (a i).SameSectionValues (a j))
    (hjl : (a j).SameSectionValues (a l))
    (hil : (a i).SameSectionValues (a l)) :
    LocalRatioRegularization.restrictSection
        (LocalRatioRegularization.tripleOpen_le_ab (a i) (a j) (a l))
        (transitionUnit a r i j hij : Γ(X.left, (a i).chart.U ⊓ (a j).chart.U)) *
      LocalRatioRegularization.restrictSection
        (LocalRatioRegularization.tripleOpen_le_bc (a i) (a j) (a l))
        (transitionUnit a r j l hjl :
          Γ(X.left, (a j).chart.U ⊓ (a l).chart.U)) =
      LocalRatioRegularization.restrictSection
        (show LocalRatioRegularization.tripleOpen (a i) (a j) (a l) ≤
          (a i).chart.U ⊓ (a l).chart.U from
          le_inf (LocalRatioRegularization.tripleOpen_le_a (a i) (a j) (a l))
            (LocalRatioRegularization.tripleOpen_le_c (a i) (a j) (a l)))
        (transitionUnit a r i l hil :
          Γ(X.left, (a i).chart.U ⊓ (a l).chart.U)) := by
  rw [transitionUnit_val, transitionUnit_val, transitionUnit_val]
  simp only [LocalRatioRegularization.restrictSection_restrictSection]
  exact (LocalRatioRegularization.triple_indexed_transition_factorization
    (a := a i) (b := a j) (c := a l) (r i) (r j) hij).symm

end LocalRatioDenominatorCocycle

end
end Hartshorne
