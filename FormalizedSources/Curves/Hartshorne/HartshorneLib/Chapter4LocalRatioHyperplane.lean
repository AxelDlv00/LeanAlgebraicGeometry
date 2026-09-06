/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioProjectiveChart

/-!
# Hyperplane pullbacks on local-ratio charts

A homogeneous linear form pulls back to the same linear combination of the
regularized coordinates. Its projective basic open therefore pulls back to
the nonvanishing locus of that combination on the chart.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry MvPolynomial

namespace Hartshorne

noncomputable section

namespace ProjectiveCoordinates

variable {J : Type v} [Fintype J] {k : Type u} [Field k]

/-- The homogeneous linear form with the specified coordinate coefficients. -/
def linearForm (c : J → k) : MvPolynomial J k :=
  ∑ j, MvPolynomial.C (c j) * MvPolynomial.X j

/-- Every coordinate linear combination is homogeneous of degree one. -/
theorem linearForm_isHomogeneous (c : J → k) :
    (linearForm c).IsHomogeneous 1 := by
  exact MvPolynomial.IsHomogeneous.sum _ _ _
    (fun j _ => MvPolynomial.isHomogeneous_C_mul_X (c j) j)

theorem linearForm_mem_homogeneousSubmodule (c : J → k) :
    linearForm c ∈ MvPolynomial.homogeneousSubmodule J k 1 :=
  (MvPolynomial.mem_homogeneousSubmodule _ _).mpr (linearForm_isHomogeneous c)

end ProjectiveCoordinates

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

attribute [local instance] MvPolynomial.gradedAlgebra Scheme.overModule

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

noncomputable local instance hyperplaneChartAlgebra : Algebra k Γ(a.chart.U, ⊤) :=
  (a.chart.U.toScheme.overAlgebraMap k (⊤ : a.chart.U.toScheme.Opens)).toAlgebra

/-- The regular section representing a coordinate linear form on the chart. -/
def regularizedLinearForm (r : LocalRatioRegularization a)
    (c : Fin (n + 1) → k) : Γ(X.left, a.chart.U) :=
  ∑ j, X.left.overAlgebraMap k a.chart.U (c j) * r.regularized j

theorem regularizedLinearForm_eq_sum_smul (r : LocalRatioRegularization a)
    (c : Fin (n + 1) → k) :
    r.regularizedLinearForm c = ∑ j, c j • r.regularized j := by
  simp only [regularizedLinearForm, Scheme.overModule_smul_def]

/-- A regularized linear form has the rational value of the corresponding
divisor-section combination divided by the chosen denominator. -/
theorem regularizedLinearForm_value (r : LocalRatioRegularization a)
    (c : Fin (n + 1) → k) :
    localStructureValue a.chart (r.regularizedLinearForm c) =
      (∑ j, functionFieldOverAlgebraMap k X.left (c j) *
        (a.sections j : X.left.functionField)) /
          (a.sections a.denominator_index : X.left.functionField) := by
  simp only [regularizedLinearForm, localStructureValue, map_sum, map_mul,
    germ_generic_overAlgebraMap]
  change (∑ j, functionFieldOverAlgebraMap k X.left (c j) *
      localStructureValue a.chart (r.regularized j)) = _
  simp only [r.regularized_value_eq, LocalRatioCoordinateData.coordinate,
    LocalRatioCoordinateData.ratioAt, LocalDivisorSectionRatio.ratio,
    LocalDivisorSectionRatio.numeratorValue, LocalDivisorSectionRatio.denominatorValue,
    mul_div_assoc, Finset.sum_div]

/-- Evaluation of a linear form gives the corresponding chart section sum. -/
theorem chartEval_linearForm (r : LocalRatioRegularization a)
    (c : Fin (n + 1) → k) :
    r.chartEval (ProjectiveCoordinates.linearForm c) =
      ∑ j, c j • r.chartSection j := by
  simp [chartEval, ProjectiveCoordinates.linearForm, Algebra.smul_def]

/-- The projective complement of a hyperplane pulls back to the basic open of
the corresponding linear combination on the open subscheme. -/
theorem chartMap_preimage_linearForm_basicOpen (r : LocalRatioRegularization a)
    (c : Fin (n + 1) → k) :
    r.chartMap ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (ProjectiveCoordinates.linearForm c) =
      a.chart.U.toScheme.basicOpen (∑ j, c j • r.chartSection j) := by
  change (Proj.fromOfGlobalSections
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      r.chartEval r.chartEval_irrelevant_span) ⁻¹ᵁ _ = _
  rw [Proj.fromOfGlobalSections_preimage_basicOpen
    (𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
    (f := r.chartEval) (hf := r.chartEval_irrelevant_span)
    (r := ProjectiveCoordinates.linearForm c) (n := 1)
    Nat.zero_lt_one (ProjectiveCoordinates.linearForm_mem_homogeneousSubmodule c),
    r.chartEval_linearForm]

private theorem topIso_inv_overAlgebraMap (z : k) :
    a.chart.U.topIso.inv.hom (X.left.overAlgebraMap k a.chart.U z) =
      a.chart.U.toScheme.overAlgebraMap k ⊤ z := by
  have hpi : a.chart.U.ι ≫ (X.left ↘ Spec (CommRingCat.of k)) =
      (a.chart.U.toScheme ↘ Spec (CommRingCat.of k)) := by
    exact (inferInstance : a.chart.U.ι.IsOver (Spec (CommRingCat.of k))).1
  have hiso : a.chart.U.topIso.inv.hom =
      (a.chart.U.ι.appLE a.chart.U (⊤ : a.chart.U.toScheme.Opens)
        a.chart.U.ι_preimage_self.ge).hom := by
    rw [Scheme.Opens.ι_appLE]
    simp only [Scheme.Opens.topIso_inv]
    congr 1
  rw [hiso]
  exact Scheme.Hom.appLE_overAlgebraMap a.chart.U.ι hpi
    a.chart.U.ι_preimage_self.ge z

/-- The chart sum is the transport of the same linear combination of ambient
regularized sections. -/
theorem chartSection_sum_eq_topIso_inv (r : LocalRatioRegularization a)
    (c : Fin (n + 1) → k) :
    (∑ j, c j • r.chartSection j) =
      a.chart.U.topIso.inv.hom (∑ j, c j • r.regularized j) := by
  simp only [map_sum, Scheme.overModule_smul_def, map_mul,
    topIso_inv_overAlgebraMap, chartSection]

/-- The hyperplane pullback is the ambient basic open of the corresponding
linear combination of regularized coordinates, restricted to the chart. -/
theorem chartMap_preimage_linearForm_basicOpen_ambient
    (r : LocalRatioRegularization a) (c : Fin (n + 1) → k) :
    r.chartMap ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (ProjectiveCoordinates.linearForm c) =
      a.chart.U.ι ⁻¹ᵁ X.left.basicOpen (∑ j, c j • r.regularized j) := by
  rw [r.chartMap_preimage_linearForm_basicOpen, r.chartSection_sum_eq_topIso_inv]
  rw [← Scheme.Opens.ι_image_basicOpen_topIso_inv
    (X := X.left) (U := a.chart.U) (∑ j, c j • r.regularized j)]
  exact (a.chart.U.ι.preimage_image_eq _).symm

/-- A named-section version of the ambient hyperplane pullback formula. -/
theorem chartMap_preimage_linearForm_basicOpen_regularized
    (r : LocalRatioRegularization a) (c : Fin (n + 1) → k) :
    r.chartMap ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (ProjectiveCoordinates.linearForm c) =
      a.chart.U.ι ⁻¹ᵁ X.left.basicOpen (r.regularizedLinearForm c) := by
  rw [r.regularizedLinearForm_eq_sum_smul]
  exact r.chartMap_preimage_linearForm_basicOpen_ambient c

end LocalRatioRegularization

end
end Hartshorne
