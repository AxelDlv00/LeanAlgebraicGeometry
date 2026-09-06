/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter2LineBundleGluingPullback
import HartshorneLib.Chapter4ProjectivePullbackLineBundle
import HartshorneLib.Chapter4ProjectiveCoordinatePullback

/-!
# Comparing the projective pullback with the divisor module

The actual glued linear-system map pulls the standard projective transition
units back to the selected denominator transition units. The resulting map
from its pullback of `O(1)` to `O(D)` sends each homogeneous coordinate section
to the corresponding basis section.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne.BasePointFreeLocalRatioCover

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}
variable (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
  (hD : BasePointFreeLinearSystem D)

local notation "f" => gluedMap_of_smoothCurve basis hD
local notation "a" => selectedCoordinates basis hD
local notation "r" => selectedRegularization basis hD
local notation "U" => (fun x => LocalRatioOpen.U
  (LocalRatioCoordinateData.chart (selectedCoordinates basis hD x)))
local notation "d" => (fun x => LocalRatioCoordinateData.denominator_index
  (selectedCoordinates basis hD x))
local notation "g" => (fun x y => LocalRatioDenominatorCocycle.transitionUnit a r x y
  (selectedCoordinates_sameSectionValues basis hD x y))

/-- Projective matching units pull back to the divisor's denominator units. -/
theorem appLE_matchingUnit (x y : NonGenericPoint X) :
    (f).appLE (ProjectiveTwist.chart (d x) ⊓ ProjectiveTwist.chart (d y)) (U x ⊓ U y)
        (le_inf (inf_le_left.trans (selectedChart_le_preimage_chart basis hD x))
          (inf_le_right.trans (selectedChart_le_preimage_chart basis hD y)))
        (ProjectiveTwist.matchingUnit (k := k) (d x) (d y)).val = (g x y).val := by
  rw [ProjectiveTwist.matchingUnit_val]
  erw [LineBundleGluing.appLE_resHom, LocalRatioDenominatorCocycle.transitionUnit_val]
  change _ = X.left.resHom inf_le_left ((r x).regularized (d y))
  rw [← gluedMap_of_smoothCurve_appLE_coordinate basis hD x (d y),
    LineBundleGluing.resHom_appLE]

/-- The geometric pullback maps to the matching-family denominator presentation. -/
def pullbackTwistingToDenominator :
    (Scheme.Modules.pullback f).obj
        (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1))) ⟶
      LineBundleGluing.gluedModule U g :=
  LineBundleGluing.pullbackHom.{u, 0} f ProjectiveTwist.chart U
    ProjectiveTwist.matchingUnit g d (selectedChart_le_preimage_chart basis hD)
    (appLE_matchingUnit basis hD)

/-- The comparison from the geometric pullback of `O(1)` to the actual divisor module. -/
def pullbackTwistingToDivisor :
    (Scheme.Modules.pullback f).obj
        (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1))) ⟶ divisorModule D :=
  pullbackTwistingToDenominator basis hD ≫ (divisorModuleIsoSelectedGlued basis hD).inv

/-- Homogeneous coordinate sections have the expected denominator components. -/
theorem toPushforward_coordinateSection
    (W : (projectiveSpace k n).Opens) (j : Fin (n + 1)) :
    (LineBundleGluing.toPushforward.{u, 0} f ProjectiveTwist.chart U
        ProjectiveTwist.matchingUnit g d (selectedChart_le_preimage_chart basis hD)
        (appLE_matchingUnit basis hD)).app W (ProjectiveTwist.coordinateSection j W) =
      (divisorModuleIsoSelectedGlued basis hD).hom.app (f ⁻¹ᵁ W)
        (show Γ(divisorModule D, f ⁻¹ᵁ W) from
          divisorSectionsRes D le_top (basisSections basis j)) := by
  apply Subtype.ext
  funext x
  rw [divisorModuleIsoSelectedGlued_basisSection]
  change (f).appLE _ _ _ ((projectiveSpace k n).resHom inf_le_right
      (ProjectiveTwist.coordinate (d x) j)) =
    X.left.resHom inf_le_right ((r x).regularized j)
  rw [LineBundleGluing.appLE_resHom,
    ← gluedMap_of_smoothCurve_appLE_coordinate basis hD x j,
    LineBundleGluing.resHom_appLE]

/-- Under the comparison, the pullback of `X_j` is the `j`-th basis section of `O(D)`. -/
theorem pullbackTwistingToDivisor_coordinateSection
    (W : (projectiveSpace k n).Opens) (j : Fin (n + 1)) :
    (pullbackTwistingToDivisor basis hD).app (f ⁻¹ᵁ W)
        (((Scheme.Modules.pullbackPushforwardAdjunction f).unit.app
          (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1)))).app W
            (ProjectiveTwist.coordinateSection j W)) =
      (show Γ(divisorModule D, f ⁻¹ᵁ W) from
        divisorSectionsRes D le_top (basisSections basis j)) := by
  have hunit := congrArg
    (fun e => (Scheme.Modules.Hom.app e W) (ProjectiveTwist.coordinateSection j W))
    (LineBundleGluing.unit_comp_pushforward_pullbackHom.{u, 0} f
      ProjectiveTwist.chart U ProjectiveTwist.matchingUnit g d
      (selectedChart_le_preimage_chart basis hD) (appLE_matchingUnit basis hD))
  change (pullbackTwistingToDenominator basis hD).app (f ⁻¹ᵁ W)
      (((Scheme.Modules.pullbackPushforwardAdjunction f).unit.app _).app W
        (ProjectiveTwist.coordinateSection j W)) = _ at hunit
  change (divisorModuleIsoSelectedGlued basis hD).inv.app (f ⁻¹ᵁ W)
    ((pullbackTwistingToDenominator basis hD).app (f ⁻¹ᵁ W) _) = _
  exact (congrArg (fun z => (divisorModuleIsoSelectedGlued basis hD).inv.app (f ⁻¹ᵁ W) z)
    (hunit.trans (toPushforward_coordinateSection basis hD W j))).trans
      (ConcreteCategory.congr_hom
        (congrArg (fun e => Scheme.Modules.Hom.app e (f ⁻¹ᵁ W))
          (divisorModuleIsoSelectedGlued basis hD).hom_inv_id) _)

end
end Hartshorne.BasePointFreeLocalRatioCover
