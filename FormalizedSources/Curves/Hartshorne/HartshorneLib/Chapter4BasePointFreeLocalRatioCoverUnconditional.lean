/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalRatioCover
import HartshorneLib.Chapter4CurvePointWitness

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

end BasePointFreeLocalRatioCover

end
end Hartshorne
