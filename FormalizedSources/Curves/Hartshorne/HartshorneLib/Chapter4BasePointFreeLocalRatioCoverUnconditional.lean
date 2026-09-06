/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalRatioCover
import HartshorneLib.Chapter4CurvePointWitness
import HartshorneLib.Chapter4ProjectiveMapProducer
import HartshorneLib.Chapter4LocalRatioGluingInvariance

/-!
# Unconditional smooth-curve local-ratio cover

The fixed-basis local-ratio construction only needs a non-generic point to
cover the generic point.  The witness theorem supplies that point for every
integral smooth curve, so the resulting cover and glued morphism no longer
carry an extra existential hypothesis.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

namespace BasePointFreeLocalRatioCover

variable {n : ℕ}

/-- The selected exact-order charts cover a smooth integral curve. -/
theorem selectedCoordinates_isOpenCover_of_smoothCurve
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    IsOpenCover (fun x : NonGenericPoint X =>
      (selectedCoordinates (D := D) basis hD x).chart.U) := by
  exact selectedCoordinates_isOpenCover basis hD
    (nonempty_nonGenericPoint_of_smoothCurve (X := X))

/-- The glued projective morphism on a smooth integral curve, with the
non-generic-point witness supplied by the curve hypotheses. -/
noncomputable def gluedMap_of_smoothCurve
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    X.left ⟶ projectiveSpace k n :=
  gluedMap basis hD (nonempty_nonGenericPoint_of_smoothCurve (X := X))

@[reassoc (attr := simp)] theorem gluedMap_of_smoothCurve_over
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    gluedMap_of_smoothCurve (D := D) basis hD ≫ projectiveSpaceStructureMap k n = X.hom := by
  exact gluedMap_over basis hD (nonempty_nonGenericPoint_of_smoothCurve (X := X))

/-! ### Packaging the glued map as projective-map data -/

/-- The smooth-curve local-ratio construction supplies the explicit map needed
by `ProjectiveMapProducer`, while the chosen basis supplies its homogeneous
coordinate index.  The target dimension is retained as a field of the
producer and is recovered from the basis by `ProjectiveMapProducer.target_dimension`.

The selected indices, opens, and regularizations are obtained with
`Classical.choose`.  For the fixed basis, the resulting morphism is independent
of those auxiliary choices by `gluedFromOpen_eq_gluedMap_of_smoothCurve`.
No independence from the basis is asserted.
-/
noncomputable def projectiveMapProducer_of_smoothCurve
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    ProjectiveMapProducer D :=
  ProjectiveMapProducer.of_basis D n basis
    (gluedMap_of_smoothCurve basis hD)
    (gluedMap_of_smoothCurve_over basis hD)

@[simp] theorem projectiveMapProducer_of_smoothCurve_n
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    (projectiveMapProducer_of_smoothCurve (D := D) basis hD).n = n :=
  rfl

@[simp] theorem projectiveMapProducer_of_smoothCurve_basis
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    (projectiveMapProducer_of_smoothCurve (D := D) basis hD).basis = basis :=
  rfl

@[simp] theorem projectiveMapProducer_of_smoothCurve_map
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map =
      gluedMap_of_smoothCurve basis hD :=
  rfl

theorem projectiveMapProducer_of_smoothCurve_target_dimension
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) :
    ((projectiveMapProducer_of_smoothCurve (D := D) basis hD).n : ℤ) =
      linearSystemDimension D :=
  ProjectiveMapProducer.target_dimension
    (projectiveMapProducer_of_smoothCurve (D := D) basis hD)

/-- Each selected normalized chart is the restriction of the packaged
projective map.  This is the local compatibility statement consumed by the
subsequent closed-immersion and Proj-gluing arguments. -/
@[reassoc]
theorem chartOpenCover_ι_projectiveMapProducer_of_smoothCurve
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (i : NonGenericPoint X) :
    (LocalRatioProjectiveGluing.chartOpenCover
        (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
        (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)).f i ≫
        (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map =
      (selectedRegularization (D := D) basis hD i).chartMap := by
  change (LocalRatioProjectiveGluing.chartOpenCover
      (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
      (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)).f i ≫
      gluedMap_of_smoothCurve (D := D) basis hD =
    (selectedRegularization (D := D) basis hD i).chartMap
  exact LocalRatioProjectiveGluing.chartOpenCover_ι_gluedFromOpen_eq_chartMap
    (a := fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
    (r := fun x : NonGenericPoint X => selectedRegularization (D := D) basis hD x)
    (hcover := selectedCoordinates_isOpenCover_of_smoothCurve basis hD)
    (selectedCoordinates_sameSectionValues (D := D) basis hD) i

/-- The packaged map has the expected ambient principal-open preimages on
each selected chart.  This is the preimage compatibility needed when a
target-local immersion argument restricts the global map to a projective
basic open; it does not assert any global closed-immersion property. -/
@[simp]
theorem chartOpenCover_ι_projectiveMapProducer_of_smoothCurve_preimage_basicOpen
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (i : NonGenericPoint X)
    (j : Fin (n + 1)) :
    ((LocalRatioProjectiveGluing.chartOpenCover
        (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
        (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)).f i ≫
        (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map) ⁻¹ᵁ
      (Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j)) =
      (selectedCoordinates (D := D) basis hD i).chart.U.ι ⁻¹ᵁ
        X.left.basicOpen
          ((selectedRegularization (D := D) basis hD i).regularized j) := by
  rw [chartOpenCover_ι_projectiveMapProducer_of_smoothCurve]
  exact LocalRatioRegularization.chartMap_preimage_basicOpen_ambient
    (a := selectedCoordinates (D := D) basis hD i)
    (r := selectedRegularization (D := D) basis hD i) j

/-- The packaged map is uniquely determined by the selected normalized chart
restrictions.  This is the descent uniqueness statement used when a later
construction supplies another candidate global projective morphism. -/
theorem projectiveMapProducer_of_smoothCurve_eq_of_chart_restrictions
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (f : X.left ⟶ projectiveSpace k n)
    (hf : ∀ i : NonGenericPoint X,
      (LocalRatioProjectiveGluing.chartOpenCover
          (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
          (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)).f i ≫ f =
        (selectedRegularization (D := D) basis hD i).chartMap) :
    f = (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map := by
  apply Scheme.Cover.hom_ext
    (LocalRatioProjectiveGluing.chartOpenCover
      (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
      (selectedCoordinates_isOpenCover_of_smoothCurve basis hD))
  intro i
  rw [hf i, ← chartOpenCover_ι_projectiveMapProducer_of_smoothCurve]
  rfl

/-- Any covering regularized family with the fixed basis section values gives
the same map as the selected smooth-curve construction.  This removes dependence
on the auxiliary opens, denominators, and regularizations, with the basis fixed. -/
theorem gluedFromOpen_eq_gluedMap_of_smoothCurve
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    {ι : Type v} (a : ι → LocalRatioCoordinateData D n)
    (r : (i : ι) → LocalRatioRegularization (a i))
    (hcover : IsOpenCover fun i => (a i).chart.U)
    (hsame : ∀ i j, (a i).SameSectionValues (a j))
    (hvalues : ∀ i j, ((a i).sections j : X.left.functionField) =
      (basisSections (D := D) basis j : X.left.functionField)) :
    LocalRatioProjectiveGluing.gluedFromOpen a r hcover hsame =
      gluedMap_of_smoothCurve (D := D) basis hD := by
  change LocalRatioProjectiveGluing.gluedFromOpen a r hcover hsame =
    LocalRatioProjectiveGluing.gluedFromOpen
      (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
      (fun x => selectedRegularization (D := D) basis hD x)
      (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)
      (selectedCoordinates_sameSectionValues (D := D) basis hD)
  apply LocalRatioProjectiveGluing.gluedFromOpen_eq_of_sameSectionValues
  intro i x j
  exact (hvalues i j).trans
    (selectedCoordinates_section_value (D := D) basis hD x j).symm

end BasePointFreeLocalRatioCover

end
end Hartshorne
