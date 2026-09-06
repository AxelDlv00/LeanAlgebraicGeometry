/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.SingularCohomologyCup
import MumfordLib.SingularCupSquare
import Mathlib.LinearAlgebra.ExteriorPower.Basic

/-!
# The exterior-square comparison map for integral singular cohomology

The explicit binomial primitive for the self-cup makes the bilinear product
of degree-one classes alternating. The universal property of the exterior
power therefore yields the degree-two cup comparison map.

This constructs the map in Mumford, Chapter I, Section 1, p. 3. Its
bijectivity for tori and the comparison in all degrees remain separate.
-/

set_option autoImplicit false

noncomputable section

namespace Mumford.Analytic

variable {X : TopCat}

/-- The square of every integral singular degree-one class is zero. -/
@[simp]
theorem singularCohomologyCupOne_self (c : IntegralSingularCohomology X 1) :
    singularCohomologyCupOne X c c = 0 := by
  obtain ⟨φ, rfl⟩ := singularFirstCohomologyClass_surjective X c
  rw [singularCohomologyCupOne_class]
  apply (singularSecondCohomologyClass_eq_zero_iff X _).mpr
  obtain ⟨η, hη⟩ := singularCochainCupOne_self_coboundary φ
  exact ⟨η, Subtype.ext hη⟩

/-- Integral degree-one cup products change sign when the factors are exchanged. -/
theorem singularCohomologyCupOne_skew (c d : IntegralSingularCohomology X 1) :
    singularCohomologyCupOne X c d = -singularCohomologyCupOne X d c := by
  have h := singularCohomologyCupOne_self (c + d)
  simp only [map_add, LinearMap.add_apply, singularCohomologyCupOne_self,
    zero_add, add_zero] at h
  exact eq_neg_of_add_eq_zero_right h

/-- The integral singular degree-one cup as an alternating bilinear map. -/
def singularCohomologyCupOneAlternating (X : TopCat) :
    AlternatingMap ℤ (IntegralSingularCohomology X 1)
      (IntegralSingularCohomology X 2) (Fin 2) where
  toFun v := singularCohomologyCupOne X (v 0) (v 1)
  map_update_add' v i a b := by
    fin_cases i <;> simp [map_add]
  map_update_smul' v i r a := by
    fin_cases i
    · simp only [Fin.zero_eta, Fin.isValue, Function.update_self, map_smul,
        ne_eq, one_ne_zero, not_false_eq_true, Function.update_of_ne]
      exact ((LinearMap.applyₗ (R := ℤ) (M₂ := IntegralSingularCohomology X 2)
        (v 1)).toAddMonoidHom.map_zsmul r (singularCohomologyCupOne X a)).trans
          (Int.cast_smul_eq_zsmul ℤ r _).symm
    · simp
  map_eq_zero_of_eq' v i j h hij := by
    fin_cases i <;> fin_cases j
    · exact (hij rfl).elim
    · change v 0 = v 1 at h
      rw [h]
      exact singularCohomologyCupOne_self (v 1)
    · change v 1 = v 0 at h
      rw [h]
      exact singularCohomologyCupOne_self (v 0)
    · exact (hij rfl).elim

@[simp]
theorem singularCohomologyCupOneAlternating_apply
    (v : Fin 2 → IntegralSingularCohomology X 1) :
    singularCohomologyCupOneAlternating X v =
      singularCohomologyCupOne X (v 0) (v 1) := rfl

/-- The cup-product comparison map from the exterior square of `H¹` to `H²`. -/
def singularCohomologyExteriorSquare (X : TopCat) :
    (⋀[ℤ]^2 (IntegralSingularCohomology X 1)) →ₗ[ℤ]
      IntegralSingularCohomology X 2 :=
  exteriorPower.alternatingMapLinearEquiv (singularCohomologyCupOneAlternating X)

@[simp]
theorem singularCohomologyExteriorSquare_ιMulti
    (v : Fin 2 → IntegralSingularCohomology X 1) :
    singularCohomologyExteriorSquare X (exteriorPower.ιMulti ℤ 2 v) =
      singularCohomologyCupOne X (v 0) (v 1) := by
  exact exteriorPower.alternatingMapLinearEquiv_apply_ιMulti
    (singularCohomologyCupOneAlternating X) v

/-- On wedges of represented classes, the comparison is the class of the
Alexander--Whitney cup cochain. -/
theorem singularCohomologyExteriorSquare_classes (φ ψ : singularOneCocycles X) :
    singularCohomologyExteriorSquare X (exteriorPower.ιMulti ℤ 2
        ![singularFirstCohomologyClass X φ, singularFirstCohomologyClass X ψ]) =
      singularSecondCohomologyClass X (singularCocycleCupOne φ ψ) := by
  rw [singularCohomologyExteriorSquare_ιMulti]
  exact singularCohomologyCupOne_class φ ψ

end Mumford.Analytic
