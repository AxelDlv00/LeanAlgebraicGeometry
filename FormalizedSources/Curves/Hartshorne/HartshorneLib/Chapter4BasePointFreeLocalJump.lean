/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4DivisorDevissageExact
import HartshorneLib.Chapter4LinearSystemCriteria

/-!
# Base-point-free sections and the local divisor jump

This file connects the numerical base-point-free criterion with the local
one-point quotient used in divisor dévissage.  A global section survives in the
jump module at `x` exactly when it is not a section of `D - x`.
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

attribute [local instance] functionFieldOverModule

private lemma withZeroMultiplicative_eq_of_not_le_sub_one
    (z : WithZero (Multiplicative ℤ)) (n : ℤ)
    (hnot : ¬ z ≤
      ((Multiplicative.ofAdd (n - 1) : Multiplicative ℤ) :
        WithZero (Multiplicative ℤ)))
    (hle : z ≤
      ((Multiplicative.ofAdd n : Multiplicative ℤ) :
        WithZero (Multiplicative ℤ))) :
    z =
      ((Multiplicative.ofAdd n : Multiplicative ℤ) :
        WithZero (Multiplicative ℤ)) := by
  induction z using WithZero.recZeroCoe with
  | zero => exact (hnot zero_le).elim
  | coe w =>
      simp only [WithZero.coe_le_coe] at hnot hle
      rw [← ofAdd_toAdd w] at hnot hle ⊢
      simp only [Multiplicative.ofAdd_le] at hnot hle
      congr
      omega

/-- A section with nonzero local jump has the exact divisor order at the
chosen point. -/
theorem orderAt_eq_divisorBound_of_jumpProj_ne_zero
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    {U : X.left.Opens} (hxU : x ∈ U) (s : divisorSections D U)
    (hjump : jumpProj hx D U hxU s ≠ 0) :
    orderAt X.hom hx (s : X.left.functionField) = divisorBound D hx := by
  rw [divisorBound_eq_coeffAt hx D]
  apply withZeroMultiplicative_eq_of_not_le_sub_one
  · rw [← mem_pointLattice]
    intro hmem
    exact hjump ((jumpProj_eq_zero_iff hx D hxU s).mpr hmem)
  · exact (mem_pointLattice hx).mp
      (divisorSections_le_pointLattice hx D U hxU s.2)

/-- A global section has nonzero image in the local jump at `x` exactly when it
does not lie in the global sections of `D - x`. -/
theorem jumpProj_ne_zero_iff_not_mem_divisorSections_devissage
    {x : X.left} (hx : x ≠ genericPoint X.left) (D : CurveDivisor k X)
    (s : divisorSections D (⊤ : X.left.Opens)) :
    jumpProj hx D ⊤ trivial s ≠ 0 ↔
      (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ := by
  have hxTop : x ∈ (⊤ : X.left.Opens) := by simp
  constructor
  · intro hjump hdev
    apply hjump
    apply (jumpProj_eq_zero_iff hx D (W := ⊤) hxTop s).mpr
    exact coe_mem_pointLattice_of_devissageSection hx D ⊤ hxTop
      ⟨(s : X.left.functionField), hdev⟩
  · intro hdev hjump
    apply hdev
    exact coe_mem_divisorSections_devissage hx D (W := ⊤) hxTop s
      ((jumpProj_eq_zero_iff hx D (W := ⊤) hxTop s).mp hjump)

/-- At every closed point, numerical base-point-freeness supplies a global
section with nonzero image in the local one-point jump module. -/
theorem exists_jumpProj_ne_zero_of_basePointFree
    {D : CurveDivisor k X} (hD : BasePointFreeLinearSystem D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    ∃ s : divisorSections D (⊤ : X.left.Opens),
      jumpProj hx D ⊤ trivial s ≠ 0 := by
  obtain ⟨s, hs⟩ :=
    exists_divisorSection_not_mem_devissage_of_basePointFree hD x hx
  exact ⟨s,
    (jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hx D s).mpr hs⟩

/-- At every closed point, numerical base-point-freeness supplies a global
section whose order realizes the divisor bound exactly at that point. -/
theorem exists_divisorSection_orderAt_eq_of_basePointFree
    {D : CurveDivisor k X} (hD : BasePointFreeLinearSystem D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    ∃ s : divisorSections D (⊤ : X.left.Opens),
      orderAt X.hom hx (s : X.left.functionField) = divisorBound D hx := by
  obtain ⟨s, hs⟩ := exists_jumpProj_ne_zero_of_basePointFree hD x hx
  exact ⟨s, orderAt_eq_divisorBound_of_jumpProj_ne_zero hx D (U := ⊤) (by simp) s hs⟩

end
end Hartshorne
