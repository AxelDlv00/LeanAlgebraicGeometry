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

/-- The matching multiplier `s_j / s_i` for the denominator frames.

For a divisor section `t`, its local representatives satisfy
`t / s_i = (s_j / s_i) * (t / s_j)`, in the convention
`f_i = g_ij * f_j` of `LineBundleGluing.IsCocycle`.

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

@[simp] theorem transitionUnit_self (i : ι)
    (hii : (a i).SameSectionValues (a i)) :
    transitionUnit a r i i hii = 1 := by
  apply Units.ext
  simp only [transitionUnit_val, LocalRatioRegularization.regularized_denominator_eq_one,
    LocalRatioRegularization.restrictSection, map_one, Units.val_one]

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

/-- Denominator matching multipliers satisfy the normalized cocycle law. -/
theorem isCocycle (hsame : ∀ i j, (a i).SameSectionValues (a j)) :
    LineBundleGluing.IsCocycle (fun i => (a i).chart.U)
      (fun i j => transitionUnit a r i j (hsame i j)) where
  unit_self i := by
    rw [transitionUnit_self]
    rfl
  mul_res i j l := by
    have h := transitionUnit_triple_factorization a r
      (hsame i j) (hsame j l) (hsame i l)
    change X.left.resHom _ _ * X.left.resHom _ _ = X.left.resHom _ _ at h
    have hW : (a i).chart.U ⊓ (a j).chart.U ⊓ (a l).chart.U ≤
        LocalRatioRegularization.tripleOpen (a i) (a j) (a l) :=
      le_inf (inf_le_left.trans inf_le_left)
        (le_inf (inf_le_left.trans inf_le_right) inf_le_right)
    have hres := congrArg (X.left.resHom hW) h
    simpa only [map_mul, Scheme.resHom_resHom] using hres

end LocalRatioDenominatorCocycle

end
end Hartshorne
