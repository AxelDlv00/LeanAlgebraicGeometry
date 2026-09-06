/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectivePointSeparation

/-!
# Tangent-separating ratios generate the maximal ideal

A section realizing the divisor bound after one point is removed, divided by
an exact-order denominator, has order one at that point. Its regularized germ
is therefore a uniformizer. For the selected charts of a very ample system,
such a germ is a linear combination of the regularized basis coordinates.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

/-- Dividing a tangent-order section by an exact-order denominator gives a
rational function with a simple zero. -/
theorem orderAt_ratio_eq_exp_neg_one
    {x : X.left} (hx : x ≠ genericPoint X.left)
    (s t : X.left.functionField)
    (hs : orderAt X.hom hx s =
      divisorBound (CurveDivisor.devissageDivisor hx D) hx)
    (ht : orderAt X.hom hx t = divisorBound D hx) :
    orderAt X.hom hx (s / t) = WithZero.exp (-1 : ℤ) := by
  rw [Valuation.map_div, hs, ht, divisorBound_eq_coeffAt,
    divisorBound_eq_coeffAt, devissageDivisor_coeffAt]
  change WithZero.exp (CurveDivisor.coeffAt hx D - 1) /
    WithZero.exp (CurveDivisor.coeffAt hx D) = _
  rw [← WithZero.exp_sub]
  congr 1
  omega

omit [IsAlgClosed k] [IsProper X.hom] in
/-- A regular function with a simple zero on a smooth curve has irreducible
germ, equivalently a uniformizer in the discrete valuation ring. -/
theorem irreducible_germ_of_orderAt_eq_exp_neg_one
    (W : LocalRatioOpen X) (f : Γ(X.left, W.U))
    {x : X.left} (hx : x ≠ genericPoint X.left) (hxW : x ∈ W.U)
    (hf : orderAt X.hom hx (localStructureValue W f) =
      WithZero.exp (-1 : ℤ)) :
    Irreducible ((X.left.presheaf.germ W.U x hxW).hom f) := by
  letI := smoothCurve_stalk_isDiscreteValuationRing X.hom hx
  letI := smoothCurve_stalk_isDedekindDomain X.hom hx
  let a := (X.left.presheaf.germ W.U x hxW).hom f
  have hva : (stalkHeightOne X.left x).intValuation a =
      WithZero.exp (-1 : ℤ) := by
    rw [localStructureValue,
      germ_generic_eq_algebraMap_germ W.generic_mem hxW f,
      orderAt_eq_valuation,
      IsDedekindDomain.HeightOneSpectrum.valuation_of_algebraMap] at hf
    exact hf
  have hmem : a ∈ IsLocalRing.maximalIdeal (X.left.presheaf.stalk x) := by
    apply ((stalkHeightOne X.left x).intValuation_lt_one_iff_mem a).mp
    rw [hva]
    change WithZero.exp (-1 : ℤ) < WithZero.exp 0
    rw [WithZero.exp_lt_exp]
    norm_num
  have hnot : a ∉ IsLocalRing.maximalIdeal (X.left.presheaf.stalk x) ^ 2 := by
    intro ha
    have hle := ((stalkHeightOne X.left x).intValuation_le_pow_iff_mem a 2).mpr ha
    rw [hva, WithZero.exp_le_exp] at hle
    norm_num at hle
  change Irreducible a
  refine ⟨hmem, ?_⟩
  intro b c hab
  by_contra! hbc
  apply hnot
  rw [hab, pow_two]
  exact Ideal.mul_mem_mul hbc.1 hbc.2

namespace BasePointFreeLocalRatioCover

variable {n : ℕ}

/-- On every selected chart, numerical very ampleness supplies a linear form
whose regularized germ is a uniformizer. -/
theorem exists_regularizedLinearForm_irreducible_germ_of_veryAmple
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : VeryAmpleLinearSystem D) (x : NonGenericPoint X) :
    let hbase := basePointFreeLinearSystem_of_veryAmple hD
    let a := selectedCoordinates (D := D) basis hbase x
    let r := selectedRegularization (D := D) basis hbase x
    ∃ c : Fin (n + 1) → k,
      Irreducible ((X.left.presheaf.germ a.chart.U x.1
        (selectedOpen_spec basis hbase x).1).hom (r.regularizedLinearForm c)) := by
  let hbase := basePointFreeLinearSystem_of_veryAmple hD
  let a := selectedCoordinates (D := D) basis hbase x
  let r := selectedRegularization (D := D) basis hbase x
  obtain ⟨s, hs⟩ := exists_tangent_order_witness_of_veryAmple hD x.1 x.2
  let t : divisorSections D ⊤ :=
    ⟨s, divisorSections_mono (devissageDivisor_le x.2 D) ⊤ s.2⟩
  let c : Fin (n + 1) → k :=
    basis.repr ((divisorSectionSpaceEquiv (D := D)).symm t)
  refine ⟨c, irreducible_germ_of_orderAt_eq_exp_neg_one a.chart
    (r.regularizedLinearForm c) x.2 (selectedOpen_spec basis hbase x).1 ?_⟩
  have hvalue : localStructureValue a.chart (r.regularizedLinearForm c) =
      (s : X.left.functionField) /
        (a.sections a.denominator_index : X.left.functionField) := by
    rw [r.regularizedLinearForm_value]
    simpa only [a, selectedCoordinates_section_value] using
      congrArg (fun z : X.left.functionField =>
        z / (a.sections a.denominator_index : X.left.functionField))
        (basisSections_sum_repr basis t)
  rw [hvalue]
  apply orderAt_ratio_eq_exp_neg_one x.2 _ _ hs
  rw [show (a.sections a.denominator_index : X.left.functionField) =
    (basisSections (D := D) basis (selectedIndex basis hbase x) : X.left.functionField)
    from selectedCoordinates_section_value basis hbase x _]
  exact selectedSection_orderAt basis hbase x

end BasePointFreeLocalRatioCover

end
end Hartshorne
