/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalRatioCoverUnconditional
import HartshorneLib.Chapter4ProjectiveMapClosedImmersion

/-!
# Chart-restriction descent for projective embeddings

A candidate projective map whose restrictions agree with the normalized
fixed-basis charts is equal to the glued complete-linear-system map.  Hence a
closed-immersion proof for that candidate recovers numerical very ampleness.
The chart restriction data is explicit: extracting it from an arbitrary
pullback isomorphism remains a separate producer.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne.BasePointFreeLocalRatioCover

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

/-- A closed immersion with the normalized fixed-basis chart restrictions
recovers the numerical very-ampleness criterion. -/
theorem veryAmple_of_closedImmersion_of_chart_restrictions
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (f : X.left ⟶ projectiveSpace k n)
    (hf : ∀ i : NonGenericPoint X,
      (LocalRatioProjectiveGluing.chartOpenCover
          (fun x : NonGenericPoint X => selectedCoordinates (D := D) basis hD x)
          (selectedCoordinates_isOpenCover_of_smoothCurve basis hD)).f i ≫ f =
        (selectedRegularization (D := D) basis hD i).chartMap)
    [IsClosedImmersion f] :
    VeryAmpleLinearSystem D := by
  have hEq : f = (projectiveMapProducer_of_smoothCurve (D := D) basis hD).map :=
    projectiveMapProducer_of_smoothCurve_eq_of_chart_restrictions basis hD f hf
  have hclosed :
      IsClosedImmersion (gluedMap_of_smoothCurve (D := D) basis hD) := by
    rw [← projectiveMapProducer_of_smoothCurve_map]
    rw [← hEq]
    infer_instance
  letI := hclosed
  exact veryAmple_of_gluedMap_isClosedImmersion basis hD

end
end Hartshorne.BasePointFreeLocalRatioCover
