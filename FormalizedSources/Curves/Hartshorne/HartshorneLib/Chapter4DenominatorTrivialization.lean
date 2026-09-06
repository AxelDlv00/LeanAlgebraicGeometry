/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorModuleLocal
import HartshorneLib.Chapter4BasePointFreeLocalRatioCoverUnconditional

/-!
# Divisor-module trivializations on denominator charts

An exact-order denominator locally generates `O(D)`. Dividing by that
denominator gives an isomorphism to `O(0)`, hence to the structure sheaf.
The denominator is specified, so no independence from it is asserted.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

attribute [local instance] functionFieldOverModule Scheme.overModule

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]

/-- The local principalization comparison multiplies rational values by the
specified principalizing function. -/
lemma restrictDivisorModuleIsoZeroOfPrincipalization_hom_app_coe
    (D : CurveDivisor k X) (q : X.left.functionFieldˣ) (W : X.left.Opens)
    (hqW : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz (principalDivisor q) = CurveDivisor.coeffAt hz D)
    (V : W.toScheme.Opens) (hV : (W.ι ''ᵁ V : Set X.left).Nonempty)
    (s : Γ((Scheme.Modules.restrictFunctor W.ι).obj (divisorModule D), V)) :
    ((show divisorSections (0 : CurveDivisor k X) (W.ι ''ᵁ V) from
      (restrictDivisorModuleIsoZeroOfPrincipalization D q W hqW).hom.app V s) :
        X.left.functionField) =
      (q : X.left.functionField) *
        ((show divisorSections D (W.ι ''ᵁ V) from s) : X.left.functionField) := by
  have hzero : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W →
      CurveDivisor.coeffAt hz (D - principalDivisor q) =
        CurveDivisor.coeffAt hz (0 : CurveDivisor k X) := by
    intro z hz hzW
    rw [CurveDivisor.coeffAt_sub, hqW z hz hzW, CurveDivisor.coeffAt_zero, sub_self]
  change ((show divisorSections (0 : CurveDivisor k X) (W.ι ''ᵁ V) from
    restrictDivisorModuleAppOfCoeffAtEqOn (D - principalDivisor q) 0 W hzero V
      (divisorMulPresheafApp q D (W.ι ''ᵁ V) s)) : X.left.functionField) = _
  rw [restrictDivisorModuleAppOfCoeffAtEqOn_coe,
    divisorMulPresheafApp_coe_of_nonempty q D hV]

namespace LocalRatioCoordinateData

variable {D : CurveDivisor k X} {n : ℕ} (a : LocalRatioCoordinateData D n)
variable (hden : ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ a.chart.U →
  orderAt X.hom hz (a.sections a.denominator_index : X.left.functionField) =
    divisorBound D hz)

include hden in
/-- The inverse denominator has principal divisor `D` on the exact-order
chart, with the sign appropriate to the multiplication map on `O(D)`. -/
lemma inverse_denominator_principalizes :
    ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ a.chart.U →
      CurveDivisor.coeffAt hz (principalDivisor
        (Units.mk0 (a.sections a.denominator_index : X.left.functionField)
          a.denominator_value_ne_zero)⁻¹) = CurveDivisor.coeffAt hz D := by
  intro z hz hzU
  rw [principalDivisor_inv]
  have hb : divisorBound (-principalDivisor
      (Units.mk0 (a.sections a.denominator_index : X.left.functionField)
        a.denominator_value_ne_zero)) hz = divisorBound D hz :=
    (orderAt_eq_divisorBound_neg_principalDivisor _ hz).symm.trans (hden z hz hzU)
  rw [divisorBound_eq_coeffAt, divisorBound_eq_coeffAt] at hb
  exact congrArg Multiplicative.toAdd (WithZero.exp_injective hb)

/-- Division by the specified denominator identifies the restricted divisor
module with the restricted zero-divisor module. -/
def denominatorIsoZero :
    (Scheme.Modules.restrictFunctor a.chart.U.ι).obj (divisorModule D) ≅
      (Scheme.Modules.restrictFunctor a.chart.U.ι).obj
        (divisorModule (0 : CurveDivisor k X)) :=
  restrictDivisorModuleIsoZeroOfPrincipalization D
    (Units.mk0 (a.sections a.denominator_index : X.left.functionField)
      a.denominator_value_ne_zero)⁻¹ a.chart.U (a.inverse_denominator_principalizes hden)

/-- An exact-order denominator trivializes the actual scheme module `O(D)`. -/
def denominatorTrivialization :
    (Scheme.Modules.restrictFunctor a.chart.U.ι).obj (divisorModule D) ≅
      SheafOfModules.unit a.chart.U.toScheme.ringCatSheaf :=
  a.denominatorIsoZero hden ≪≫ restrictDivisorModuleZeroIsoUnit a.chart.U

/-- On every nonempty subopen, the forward comparison is division by the
denominator on rational-function representatives. -/
lemma denominatorIsoZero_hom_app_coe
    (V : a.chart.U.toScheme.Opens)
    (hV : (a.chart.U.ι ''ᵁ V : Set X.left).Nonempty)
    (s : Γ((Scheme.Modules.restrictFunctor a.chart.U.ι).obj (divisorModule D), V)) :
    ((show divisorSections (0 : CurveDivisor k X) (a.chart.U.ι ''ᵁ V) from
      (a.denominatorIsoZero hden).hom.app V s) : X.left.functionField) =
      ((show divisorSections D (a.chart.U.ι ''ᵁ V) from s) : X.left.functionField) /
        (a.sections a.denominator_index : X.left.functionField) := by
  rw [denominatorIsoZero, restrictDivisorModuleIsoZeroOfPrincipalization_hom_app_coe
    D _ a.chart.U _ V hV]
  simp only [Units.val_inv_eq_inv_val, Units.val_mk0, div_eq_mul_inv, mul_comm]

/-- The module comparison takes each divisor coordinate to its regularized
projective coordinate on every subopen of the denominator chart. The
zero-divisor module is identified with regular functions by the generic-germ
comparison, so this is an equality of sections, not only of scalar values. -/
lemma denominatorIsoZero_hom_app_sections
    (r : LocalRatioRegularization a) (V : a.chart.U.toScheme.Opens)
    (i : Fin (n + 1)) :
    (a.denominatorIsoZero hden).hom.app V
        (show Γ((Scheme.Modules.restrictFunctor a.chart.U.ι).obj
            (divisorModule D), V) from
          divisorSectionsRes D (a.chart.U.ι_image_le V) (a.sections i)) =
      (show Γ((Scheme.Modules.restrictFunctor a.chart.U.ι).obj
          (divisorModule (0 : CurveDivisor k X)), V) from
        moduleToDivisorZeroPresheafApp (X := X) (a.chart.U.ι ''ᵁ V)
          ((X.left.presheaf.map (homOfLE (a.chart.U.ι_image_le V)).op).hom
            (r.regularized i))) := by
  by_cases hV : (a.chart.U.ι ''ᵁ V : Set X.left).Nonempty
  · apply Subtype.ext
    rw [denominatorIsoZero_hom_app_coe a hden V hV,
      divisorSectionsRes_coe (a.chart.U.ι_image_le V) hV,
      moduleToDivisorZeroPresheafApp_coe_of_nonempty hV]
    rw [X.left.presheaf.germ_res_apply]
    exact (r.regularized_value_eq i).symm
  · letI := divisorSections_subsingleton_of_empty
      (D := (0 : CurveDivisor k X)) hV
    exact @Subsingleton.elim (divisorSections (0 : CurveDivisor k X)
      (a.chart.U.ι ''ᵁ V)) inferInstance _ _

end LocalRatioCoordinateData

namespace BasePointFreeLocalRatioCover

variable {D : CurveDivisor k X} {n : ℕ}

/-- The existing base-point-free denominator cover supplies the exact-order
hypothesis for the divisor-module chart trivialization. -/
lemma selectedCoordinates_denominatorOrderEq
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X)
    (z : X.left) (hz : z ≠ genericPoint X.left)
    (hzU : z ∈ (selectedCoordinates (D := D) basis hD x).chart.U) :
    orderAt X.hom hz
        ((selectedCoordinates (D := D) basis hD x).sections
          (selectedCoordinates (D := D) basis hD x).denominator_index :
            X.left.functionField) = divisorBound D hz := by
  rw [selectedCoordinates_section_value]
  exact (selectedOpen_spec basis hD x).2 z hz hzU

/-- Each chart of the actual fixed-basis projective-map construction has a
divisor-module trivialization, supplied by its selected denominator. -/
def selectedDenominatorTrivialization
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    (Scheme.Modules.restrictFunctor
        (selectedCoordinates (D := D) basis hD x).chart.U.ι).obj (divisorModule D) ≅
      SheafOfModules.unit
        (selectedCoordinates (D := D) basis hD x).chart.U.toScheme.ringCatSheaf :=
  (selectedCoordinates (D := D) basis hD x).denominatorTrivialization
    (selectedCoordinates_denominatorOrderEq basis hD x)

end BasePointFreeLocalRatioCover

end
end Hartshorne
