/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4TwoPointFiberEvaluation

/-!
# Point and tangent separation by ordinary fibers

This module splits the numerical very-ampleness criterion of Hartshorne IV.3.1
into its two geometric linear-algebra cases. Distinct points are detected by
simultaneous evaluation in the two fibers of `O(D)`. At a repeated point, the
first evaluation uses `O(D)` and the second uses `O(D - x)`, so it records the
first-order tangent graded piece rather than evaluating the same fiber twice.

No projective closed-immersion theorem is asserted here.
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

/-- Numerical very ampleness is equivalent to separation of distinct ordinary
fibers together with the two successive ordinary-fiber evaluations at every
repeated point. The latter pair records values and first-order tangent data. -/
theorem veryAmpleLinearSystem_iff_ordinaryFiber_point_and_tangent_separation
    (D : CurveDivisor k X) :
    VeryAmpleLinearSystem D ↔
      (∀ (x y : X.left) (_hx : x ≠ genericPoint X.left)
          (_hy : y ≠ genericPoint X.left), x ≠ y →
        Function.Surjective (divisorModuleTwoPointFiberEvaluation D x y)) ∧
      ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
        Function.Surjective
            (Scheme.Modules.fiberEvaluation (divisorModule D) x) ∧
          Function.Surjective
            (Scheme.Modules.fiberEvaluation
              (divisorModule (CurveDivisor.devissageDivisor hx D)) x) := by
  constructor
  · intro hD
    have hsuccessive :=
      (veryAmpleLinearSystem_iff_successive_divisorModule_fiberEvaluation_surjective
        D).mp hD
    refine ⟨?_, ?_⟩
    · intro x y hx hy hxy
      exact divisorModuleTwoPointFiberEvaluation_surjective_of_veryAmple
        hD hx hy hxy
    · intro x hx
      exact ⟨hsuccessive.1 x hx, hsuccessive.2 x x hx hx⟩
  · rintro ⟨hdistinct, hrepeated⟩ x y hx hy
    by_cases hxy : x = y
    · subst y
      have hfirst :=
        (h0_sub_h0_devissage_eq_one_iff_divisorModule_fiberEvaluation_surjective
          hx D).mpr (hrepeated x hx).1
      have hsecond :=
        (h0_sub_h0_devissage_eq_one_iff_divisorModule_fiberEvaluation_surjective
          hx (CurveDivisor.devissageDivisor hx D)).mpr (hrepeated x hx).2
      omega
    · exact
        (h0_sub_h0_twoDevissage_eq_two_iff_twoPointFiberEvaluation_surjective
          hx hy hxy D).mpr (hdistinct x y hx hy hxy)

end
end Hartshorne
