/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DenominatorGluing
import HartshorneLib.Chapter4ProjectiveTwistingSheaf

/-!
# The pulled-back projective twisting sheaf

The projective twisting sheaf is a line bundle on projective space.  This
records the corresponding line-bundle structure after pulling it back along
the actual glued map attached to a base-point-free linear system.  The named
module is the target of the section-compatible comparison with `O(D)`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

namespace BasePointFreeLocalRatioCover

variable (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
  (hD : BasePointFreeLinearSystem D)

local notation "f" =>
  (gluedMap_of_smoothCurve (D := D) basis hD)

/-- Pulling back `O(1)` along the actual glued projective map gives a line
bundle on the curve.  This is the line-bundle producer used by the later
section-compatible comparison with the divisor module.

The construction depends on the chosen basis and denominator data through
`gluedMap_of_smoothCurve`; no canonical identification with `O(D)` is claimed
here.
-/
theorem isLineBundle_pullback_twistingSheafOne :
    IsLineBundle
      ((Scheme.Modules.pullback f).obj
        (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1)))) := by
  exact ProjectiveTwist.isLineBundle_twistingSheafOne.pullback f

/-! ### Selected denominator charts

The global pullback is the object used by the projective morphism.  Its
restriction to each selected local-ratio chart is the local object used in
the eventual cocycle comparison with the denominator presentation of
`divisorModule D`.
-/

theorem isLineBundle_restrict_pullback_twistingSheafOne
    (x : NonGenericPoint X) :
    IsLineBundle
      ((Scheme.Modules.restrictFunctor
          (selectedCoordinates (D := D) basis hD x).chart.U.ι).obj
        ((Scheme.Modules.pullback f).obj
          (ProjectiveTwist.twistingSheafOne (k := k) (J := Fin (n + 1))))) := by
  exact (isLineBundle_pullback_twistingSheafOne basis hD).restrict _

end BasePointFreeLocalRatioCover

end
end Hartshorne
