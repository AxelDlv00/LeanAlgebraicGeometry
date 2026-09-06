/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalJump
import HartshorneLib.Chapter4LocalRatioRegularization

/-!
# Nonvanishing of regularized divisor-section ratios

On a smooth curve, a regular function is nonvanishing at a closed point exactly
when its valuation is one. Dividing a divisor section by a denominator of exact
divisor order therefore turns a nonzero local jump into ordinary nonvanishing.
This is the local comparison used in the point-separation argument of IV.3.1.
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

omit [IsAlgClosed k] [IsProper X.hom] in
/-- A regular function on a smooth curve is nonvanishing at a non-generic
point exactly when its function-field value has valuation one. -/
theorem mem_basicOpen_iff_orderAt_eq_one
    (W : LocalRatioOpen X) (f : Γ(X.left, W.U))
    {x : X.left} (hx : x ≠ genericPoint X.left) (hxW : x ∈ W.U) :
    x ∈ X.left.basicOpen f ↔ orderAt X.hom hx (localStructureValue W f) = 1 := by
  letI := smoothCurve_stalk_isDiscreteValuationRing X.hom hx
  letI := smoothCurve_stalk_isDedekindDomain X.hom hx
  rw [X.left.mem_basicOpen f x hxW, localStructureValue,
    germ_generic_eq_algebraMap_germ W.generic_mem hxW f,
    orderAt_eq_valuation,
    IsDedekindDomain.HeightOneSpectrum.valuation_eq_one_iff_notMem]
  exact IsLocalRing.notMem_maximalIdeal.symm

/-- Exact realization of the divisor bound is equivalent to surviving the
one-point quotient. -/
theorem jumpProj_ne_zero_iff_orderAt_eq_divisorBound
    {D : CurveDivisor k X} {U : X.left.Opens}
    {x : X.left} (hx : x ≠ genericPoint X.left) (hxU : x ∈ U)
    (s : divisorSections D U) :
    jumpProj hx D U hxU s ≠ 0 ↔
      orderAt X.hom hx (s : X.left.functionField) = divisorBound D hx := by
  constructor
  · exact orderAt_eq_divisorBound_of_jumpProj_ne_zero hx D hxU s
  · intro hs hzero
    have hle := (mem_pointLattice hx).mp
      ((jumpProj_eq_zero_iff hx D hxU s).mp hzero)
    rw [hs, divisorBound_eq_coeffAt] at hle
    simp only [WithZero.coe_le_coe, Multiplicative.ofAdd_le] at hle
    omega

/-- A regularized ratio with an exact-order denominator is nonvanishing
exactly where its numerator realizes the divisor bound. -/
theorem mem_basicOpen_ratio_iff_orderAt_eq_divisorBound
    {D : CurveDivisor k X} (W : LocalRatioOpen X)
    (f : Γ(X.left, W.U)) (g t : X.left.functionField)
    (hf : localStructureValue W f = g / t)
    {x : X.left} (hx : x ≠ genericPoint X.left) (hxW : x ∈ W.U)
    (htorder : orderAt X.hom hx t = divisorBound D hx) :
    x ∈ X.left.basicOpen f ↔ orderAt X.hom hx g = divisorBound D hx := by
  rw [mem_basicOpen_iff_orderAt_eq_one W f hx hxW, hf, Valuation.map_div]
  have htval : orderAt X.hom hx t ≠ 0 := by
    rw [htorder, divisorBound_eq_coeffAt]
    exact WithZero.coe_ne_zero
  rw [div_eq_one_iff_eq htval, htorder]

/-- Dividing by an exact-order denominator identifies ordinary nonvanishing
with a nonzero local divisor jump. -/
theorem mem_basicOpen_ratio_iff_jumpProj_ne_zero
    {D : CurveDivisor k X} (W : LocalRatioOpen X)
    (f : Γ(X.left, W.U)) (s t : divisorSections D W.U)
    (hf : localStructureValue W f =
      (s : X.left.functionField) / (t : X.left.functionField))
    {x : X.left} (hx : x ≠ genericPoint X.left) (hxW : x ∈ W.U)
    (htorder : orderAt X.hom hx (t : X.left.functionField) = divisorBound D hx) :
    x ∈ X.left.basicOpen f ↔ jumpProj hx D W.U hxW s ≠ 0 := by
  rw [mem_basicOpen_ratio_iff_orderAt_eq_divisorBound W f _ _ hf hx hxW htorder,
    jumpProj_ne_zero_iff_orderAt_eq_divisorBound hx hxW s]

end
end Hartshorne
