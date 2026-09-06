/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalRatioCoverUnconditional
import HartshorneLib.Chapter4ProjectiveChartImmersion

/-!
# Conditional immersion producers for the IV.3.1 chart construction

The affine chart producer turns complementary-coordinate algebra generation
into a closed immersion.  This file transports that result across an affine
local-ratio chart and records the target-local assembly step for the chosen
glued map.  The generation and target-restriction hypotheses remain explicit:
they are the unresolved geometric inputs to the global theorem.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry
open MvPolynomial

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}
variable {n : ℕ}

attribute [local instance] MvPolynomial.gradedAlgebra

namespace ProjectiveCoordinates

/-! ### The standard projective affine cover -/

omit [IsAlgClosed k] in
/-- The coordinate standard opens cover projective space. -/
lemma iSup_basicOpen_X_eq_top (n : ℕ) :
    ⨆ i : Fin (n + 1), Proj.basicOpen
      (homogeneousSubmodule (Fin (n + 1)) k) (MvPolynomial.X i) = ⊤ := by
  refine Proj.iSup_basicOpen_eq_top' _ _
    (fun i => ⟨1, isHomogeneous_X k i⟩) ?_
  rw [eq_top_iff]
  rintro a -
  have ha : a ∈ Algebra.adjoin k
      (Set.range (MvPolynomial.X : Fin (n + 1) →
        MvPolynomial (Fin (n + 1)) k)) := by
    rw [MvPolynomial.adjoin_range_X]
    trivial
  induction ha using Algebra.adjoin_induction with
  | mem x hx => exact Algebra.subset_adjoin hx
  | algebraMap r =>
      have hr : (algebraMap k (MvPolynomial (Fin (n + 1)) k)) r
          ∈ homogeneousSubmodule (Fin (n + 1)) k 0 := by
        rw [MvPolynomial.algebraMap_eq]
        exact isHomogeneous_C _ _
      exact Subalgebra.algebraMap_mem
        (Algebra.adjoin (homogeneousSubmodule (Fin (n + 1)) k 0)
          (Set.range (MvPolynomial.X : Fin (n + 1) →
            MvPolynomial (Fin (n + 1)) k)))
        (⟨_, hr⟩ : homogeneousSubmodule (Fin (n + 1)) k 0)
  | add x y _ _ hx hy => exact add_mem hx hy
  | mul x y _ _ hx hy => exact mul_mem hx hy

end ProjectiveCoordinates

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

noncomputable local instance affineChartAlgebra : Algebra k Γ(X.left, a.chart.U) :=
  (X.left.overAlgebraMap k a.chart.U).toAlgebra

/-! ### A local affine immersion -/

/-- On an affine local-ratio chart, complementary-coordinate generation makes
the normalized chart map an immersion.  The proof factors through the
projective standard open, applies the affine closed-immersion producer, and
then composes with the open inclusion. -/
theorem isImmersion_of_affine_complement_adjoin_eq_top
    (r : LocalRatioRegularization a)
    (hU : IsAffineOpen a.chart.U)
    (hgen : Algebra.adjoin k
      (Set.range (fun j : {j : Fin (n + 1) // j ≠ a.denominator_index} =>
        r.regularized j.1)) = ⊤) :
    IsImmersion r.chartMap := by
  let i := a.denominator_index
  have hi : r.regularized i = 1 := r.regularized_denominator_eq_one
  have hCI : IsClosedImmersion
      (ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi) :=
    ProjectiveCoordinates.toBasicOpen_isClosedImmersion_of_complement_adjoin_eq_top
      (k := k) i r.regularized hi hgen
  letI : IsIso a.chart.U.toSpecΓ := by
    rw [← hU.isoSpec_hom]
    infer_instance
  have hcomp : IsClosedImmersion
      (a.chart.U.toSpecΓ ≫
        ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi) := by
    exact MorphismProperty.comp_mem @IsClosedImmersion
      a.chart.U.toSpecΓ
      (ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi)
      inferInstance hCI
  have hfactor :
      r.chartMap =
        a.chart.U.toSpecΓ ≫
          (ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi ≫
            (Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
              (MvPolynomial.X i)).ι) := by
    rw [r.chartMap_eq_fromOpen]
    unfold ProjectiveCoordinates.fromOpen
    change a.chart.U.toSpecΓ ≫
        ProjectiveCoordinates.fromSpec (k := k) i
          r.regularized hi =
      a.chart.U.toSpecΓ ≫
        (ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi ≫
          (Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
            (MvPolynomial.X i)).ι)
    rw [ProjectiveCoordinates.toBasicOpen_ι]
  rw [hfactor]
  letI : IsClosedImmersion
      (a.chart.U.toSpecΓ ≫
        ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi) := hcomp
  have hfirst : IsImmersion
      (a.chart.U.toSpecΓ ≫
        ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi) :=
    inferInstance
  have hopen : IsImmersion
      ((Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X i)).ι) := by
    infer_instance
  exact MorphismProperty.comp_mem @IsImmersion
    (a.chart.U.toSpecΓ ≫
      ProjectiveCoordinates.toBasicOpen (k := k) i r.regularized hi)
    ((Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (MvPolynomial.X i)).ι)
    hfirst hopen

end LocalRatioRegularization

namespace BasePointFreeLocalRatioCover

/-! ### Target-local assembly -/

/-/ A closed-immersion certificate on every projective standard chart promotes
the chosen smooth-curve projective map to a closed immersion.  This is a
conditional assembly theorem: it does not manufacture the chart certificates
or identify the choice-dependent map with a canonical construction. -/
theorem projectiveMapProducer_of_smoothCurve_isClosedImmersion_of_basicOpen_restrictions
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (hclosed : ∀ j : Fin (n + 1), IsClosedImmersion
      ((projectiveMapProducer_of_smoothCurve (D := D) basis hD).map ∣_
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j))) :
    IsClosedImmersion (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map := by
  refine (IsZariskiLocalAtTarget.iff_of_iSup_eq_top
    (f := (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map)
    (fun j : Fin (n + 1) =>
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j))
    (ProjectiveCoordinates.iSup_basicOpen_X_eq_top (k := k) n)).2 ?_
  intro j
  exact hclosed j

/-- A closed-immersion certificate on every projective standard chart promotes
the chosen smooth-curve projective map to an immersion.  This is a conditional
assembly theorem: it does not manufacture the chart certificates or identify
the choice-dependent map with a canonical construction. -/
theorem projectiveMapProducer_of_smoothCurve_isImmersion_of_basicOpen_restrictions
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (hclosed : ∀ j : Fin (n + 1), IsClosedImmersion
      ((projectiveMapProducer_of_smoothCurve (D := D) basis hD).map ∣_
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j))) :
    IsImmersion (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map := by
  refine (IsZariskiLocalAtTarget.iff_of_iSup_eq_top
    (f := (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map)
    (fun j : Fin (n + 1) =>
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j))
    (ProjectiveCoordinates.iSup_basicOpen_X_eq_top (k := k) n)).2 ?_
  intro j
  letI : IsClosedImmersion
      ((projectiveMapProducer_of_smoothCurve (D := D) basis hD).map ∣_
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j)) := hclosed j
  infer_instance

end BasePointFreeLocalRatioCover

end
end Hartshorne
