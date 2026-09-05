/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalRatioCover
import HartshorneLib.Chapter4CurvePointWitness
import HartshorneLib.Chapter4ProjectiveMapProducer

/-!
# Unconditional smooth-curve local-ratio cover

The fixed-basis local-ratio construction only needs a non-generic point to
cover the generic point.  The witness theorem supplies that point for every
integral smooth curve, so the resulting cover and glued morphism no longer
carry an extra existential hypothesis.
-/

set_option autoImplicit false

universe u

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

end BasePointFreeLocalRatioCover

end
end Hartshorne
