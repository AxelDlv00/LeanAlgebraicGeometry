/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4OrdinaryFiberBasePointFree

/-!
# Very ampleness through successive ordinary fibers

Hartshorne IV.3.1 expresses very ampleness by the two-dimensional section drop
after deleting two points, including the repeated-point case. This module
identifies that condition with two successive ordinary-fiber evaluations: first
for `O(D)` at `x`, then for `O(D - x)` at `y`. When `x = y`, the second fiber is
the first-order tangent graded piece rather than a duplicate evaluation of
`O(D)` at the same point.
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

/-- Numerical very ampleness is equivalent to surjectivity of the two
successive ordinary-fiber evaluations. The points may coincide; in that case
the second map evaluates `O(D - x)` at `x` and records the tangent step. -/
theorem veryAmpleLinearSystem_iff_successive_divisorModule_fiberEvaluation_surjective
    (D : CurveDivisor k X) :
    VeryAmpleLinearSystem D ↔
      (∀ (x : X.left) (_hx : x ≠ genericPoint X.left),
        Function.Surjective
          (Scheme.Modules.fiberEvaluation (divisorModule D) x)) ∧
      ∀ (x y : X.left) (hx : x ≠ genericPoint X.left)
        (_hy : y ≠ genericPoint X.left),
        Function.Surjective
          (Scheme.Modules.fiberEvaluation
            (divisorModule (CurveDivisor.devissageDivisor hx D)) y) := by
  constructor
  · intro hD
    refine ⟨(basePointFreeLinearSystem_iff_divisorModule_fiberEvaluation_surjective
      D).mp (basePointFreeLinearSystem_of_veryAmple hD), ?_⟩
    intro x y hx hy
    exact
      (h0_sub_h0_devissage_eq_one_iff_divisorModule_fiberEvaluation_surjective
        hy (CurveDivisor.devissageDivisor hx D)).mp
        (h0_sub_point_sub_point_eq_one_of_veryAmple hD x y hx hy)
  · rintro ⟨hfirst, hsecond⟩ x y hx hy
    have hdropFirst :=
      (h0_sub_h0_devissage_eq_one_iff_divisorModule_fiberEvaluation_surjective
        hx D).mpr (hfirst x hx)
    have hdropSecond :=
      (h0_sub_h0_devissage_eq_one_iff_divisorModule_fiberEvaluation_surjective
        hy (CurveDivisor.devissageDivisor hx D)).mpr
        (hsecond x y hx hy)
    omega

end
end Hartshorne
