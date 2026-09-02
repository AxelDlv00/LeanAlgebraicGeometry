/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioCoordinates
import HartshorneLib.Chapter4DivisorSheafZero

/-!
# Hartshorne IV.3.1: regularizing local ratios

The coordinate API keeps regularity as explicit data.  For the zero divisor,
the divisor sheaf comparison supplies that data whenever each rational
coordinate lies in the zero-divisor section module.  This file packages the
resulting generic-germ representatives and records their uniqueness.
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
variable {n : ℕ}

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

/-- Construct a regularization when all local ratios are sections of `𝒪(0)`.

The hypothesis is the precise regularity boundary: no choice of a local
representative is hidden in the coordinate datum.  `exists_section_germ_eq`
then glues representatives and identifies their generic values.
-/
noncomputable def of_zeroBound
    (hbound : ∀ i, a.coordinate i ∈
      divisorSections (X := X) (0 : CurveDivisor k X) a.chart.U) :
    LocalRatioRegularization a := by
  choose s hs using fun i =>
    exists_section_germ_eq (X := X) a.chart.generic_mem (hbound i)
  exact
    { regularized := s
      regularized_value_eq := by
        intro i
        simpa [localStructureValue] using hs i }

/-- The exact local denominator-order condition supplies the zero-divisor
section bounds needed by `of_zeroBound`. -/
noncomputable def of_denominatorOrderEq
    (a : LocalRatioCoordinateData D n)
    (hden : ∀ (x : X.left) (hx : x ≠ genericPoint X.left),
      x ∈ a.chart.U →
      orderAt X.hom hx
          (a.sections a.denominator_index : X.left.functionField) =
        divisorBound D hx) :
    LocalRatioRegularization a := by
  apply LocalRatioRegularization.of_zeroBound (a := a)
  intro i
  rw [mem_divisorSections_of_nonempty a.chart.nonempty]
  intro x hx hxU
  rw [divisorBound_zero hx]
  change orderAt X.hom hx
    ((a.sections i : X.left.functionField) /
      (a.sections a.denominator_index : X.left.functionField)) ≤ 1
  rw [Valuation.map_div]
  have hnum : orderAt X.hom hx (a.sections i : X.left.functionField) ≤
      divisorBound D hx := by
    exact (mem_divisorSections_of_nonempty a.chart.nonempty).mp
      (a.sections i).property x hx hxU
  have hle : orderAt X.hom hx (a.sections i : X.left.functionField) ≤
      orderAt X.hom hx
        (a.sections a.denominator_index : X.left.functionField) := by
    rw [hden x hx hxU]
    exact hnum
  exact div_le_one_of_le₀ hle bot_le

@[simp] theorem of_zeroBound_value
    (hbound : ∀ i, a.coordinate i ∈
      divisorSections (X := X) (0 : CurveDivisor k X) a.chart.U)
    (i : Fin (n + 1)) :
    localStructureValue a.chart
        ((of_zeroBound (a := a) hbound).regularized i) = a.coordinate i := by
  exact (of_zeroBound (a := a) hbound).regularized_value_eq i

/-- Two regularizations with the same generic values agree sectionwise. -/
theorem regularized_ext
    (r s : LocalRatioRegularization a)
    (h : ∀ i, localStructureValue a.chart (r.regularized i) =
      localStructureValue a.chart (s.regularized i)) :
    r.regularized = s.regularized := by
  funext i
  apply localStructureValue_injective a.chart
  exact h i

end LocalRatioRegularization

end
end Hartshorne
