/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4BasePointFreeLocalJump
import HartshorneLib.Chapter4LocalRatioCoordinates

/-!
# Base-point-free denominator opens

A nonzero rational function whose order realizes a divisor bound at a point
realizes that bound throughout an open neighborhood of the point. The failure
locus is finite: away from the order support of the rational function and the
support of the divisor, both orders are trivial. Applying this to a suitable
uniformizer power locally principalizes any divisor.
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

/-- Exact realization of a divisor bound by a nonzero rational function
persists on a nonempty open neighborhood of the chosen point. -/
theorem exists_localRatioOpen_orderAt_eq_of_function
    {D : CurveDivisor k X} (g : X.left.functionField) (hg : g ≠ 0) {x : X.left}
    (hx : x ≠ genericPoint X.left)
    (hxorder : orderAt X.hom hx g = divisorBound D hx) :
    ∃ W : LocalRatioOpen X, x ∈ W.U ∧
      ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W.U →
        orderAt X.hom hz g = divisorBound D hz := by
  let gu : X.left.functionFieldˣ := Units.mk0 g hg
  have hgu : (gu : X.left.functionField) = g := rfl
  let Bad : Set X.left := {z | ∃ (hz : z ≠ genericPoint X.left),
    orderAt X.hom hz g ≠ divisorBound D hz}
  have hBadFinite : Bad.Finite := by
    apply Set.Finite.subset
      ((orderZAt_support_finite X.hom gu).image Subtype.val |>.union
        ((show PointDivisor X.left from D).support.finite_toSet.image Subtype.val))
    intro z hz
    obtain ⟨hzgeneric, hzorder⟩ := hz
    by_contra houtside
    simp only [Set.mem_union, not_or] at houtside
    obtain ⟨horderSupport, hdivisorSupport⟩ := houtside
    have horderZ : orderZAt X.hom hzgeneric gu = 1 := by
      by_contra hne
      exact horderSupport ⟨⟨z, hzgeneric⟩, hne, rfl⟩
    have hcoeff : (show PointDivisor X.left from D).toFun ⟨z, hzgeneric⟩ = 0 := by
      by_contra hne
      exact hdivisorSupport
        ⟨⟨z, hzgeneric⟩, Finsupp.mem_support_iff.mpr hne, rfl⟩
    have hcoeffAt : CurveDivisor.coeffAt hzgeneric D = 0 := by
      change (show PointDivisor X.left from D).toFun ⟨z, hzgeneric⟩ = 0
      exact hcoeff
    apply hzorder
    have horder : orderAt X.hom hzgeneric g = 1 := by
      rw [← hgu, ← orderZAt_eq_one_iff]
      exact horderZ
    rw [divisorBound_eq_coeffAt, horder, hcoeffAt]
    simp
  have hBadClosed : IsClosed Bad := by
    rw [← Set.biUnion_of_singleton Bad]
    exact hBadFinite.isClosed_biUnion
      (fun z hz => smoothCurve_isClosed_singleton_of_ne_genericPoint X.hom hz.choose)
  let U : X.left.Opens := ⟨Badᶜ, hBadClosed.isOpen_compl⟩
  have hxBad : x ∉ Bad := by
    rintro ⟨_, hne⟩
    exact hne hxorder
  have hxU : x ∈ U := hxBad
  let W : LocalRatioOpen X := LocalRatioOpen.of_nonempty U ⟨x, hxU⟩
  refine ⟨W, hxU, ?_⟩
  intro z hz hzU
  by_contra hne
  exact hzU ⟨hz, hne⟩

/-- Exact realization of a divisor bound by a nonzero global section persists
on a nonempty open neighborhood of the chosen point. -/
theorem exists_localRatioOpen_orderAt_eq
    {D : CurveDivisor k X} (s : divisorSections D (⊤ : X.left.Opens))
    (hs : (s : X.left.functionField) ≠ 0) {x : X.left}
    (hx : x ≠ genericPoint X.left)
    (hxorder : orderAt X.hom hx (s : X.left.functionField) = divisorBound D hx) :
    ∃ W : LocalRatioOpen X, x ∈ W.U ∧
      ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W.U →
        orderAt X.hom hz (s : X.left.functionField) = divisorBound D hz :=
  exists_localRatioOpen_orderAt_eq_of_function (s : X.left.functionField) hs hx hxorder

/-- Every curve divisor agrees with a principal divisor on a nonempty open
neighborhood of any non-generic point. The unit is a power of a uniformizer at
the chosen point, and hence depends on that choice; only its local divisor is
asserted here. -/
theorem exists_localRatioOpen_eq_principalDivisor
    (D : CurveDivisor k X) {x : X.left} (hx : x ≠ genericPoint X.left) :
    ∃ (q : X.left.functionFieldˣ) (W : LocalRatioOpen X),
      x ∈ W.U ∧
        ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W.U →
          CurveDivisor.coeffAt hz (principalDivisor q) =
            CurveDivisor.coeffAt hz D := by
  let q₀ : X.left.functionField :=
    uniformizer hx ^ CurveDivisor.coeffAt hx D
  have hq₀ : q₀ ≠ 0 :=
    zpow_ne_zero (CurveDivisor.coeffAt hx D) (uniformizer_ne_zero hx)
  let q : X.left.functionFieldˣ := Units.mk0 q₀ hq₀
  have hqx : orderAt X.hom hx (q : X.left.functionField) =
      divisorBound (-D) hx := by
    change orderAt X.hom hx
        (uniformizer hx ^ CurveDivisor.coeffAt hx D) =
      divisorBound (-D) hx
    rw [orderAt_uniformizer_zpow, divisorBound_eq_coeffAt,
      CurveDivisor.coeffAt_neg]
  obtain ⟨W, hxW, hW⟩ :=
    exists_localRatioOpen_orderAt_eq_of_function
      (D := -D) (q : X.left.functionField) (Units.ne_zero q) hx hqx
  refine ⟨q, W, hxW, ?_⟩
  intro z hz hzW
  have hbound : divisorBound (-principalDivisor q) hz =
      divisorBound (-D) hz :=
    (orderAt_eq_divisorBound_neg_principalDivisor q hz).symm.trans
      (hW z hz hzW)
  rw [divisorBound_eq_coeffAt, divisorBound_eq_coeffAt,
    CurveDivisor.coeffAt_neg, CurveDivisor.coeffAt_neg] at hbound
  have hcoeff := WithZero.exp_injective hbound
  exact neg_injective (congrArg Multiplicative.toAdd hcoeff)

/-- At every closed point, a base-point-free linear system supplies a nonzero
global denominator section and an open chart on which its order realizes the
divisor bound everywhere. -/
theorem exists_localRatioOpen_orderAt_eq_of_basePointFree
    {D : CurveDivisor k X} (hD : BasePointFreeLinearSystem D)
    (x : X.left) (hx : x ≠ genericPoint X.left) :
    ∃ (s : divisorSections D (⊤ : X.left.Opens)) (W : LocalRatioOpen X),
      (s : X.left.functionField) ≠ 0 ∧ x ∈ W.U ∧
        ∀ (z : X.left) (hz : z ≠ genericPoint X.left), z ∈ W.U →
          orderAt X.hom hz (s : X.left.functionField) = divisorBound D hz := by
  obtain ⟨s, hjump⟩ := exists_jumpProj_ne_zero_of_basePointFree hD x hx
  have hs : (s : X.left.functionField) ≠ 0 := by
    intro hszero
    apply hjump
    have hsSubtype : s = 0 := Subtype.ext hszero
    rw [hsSubtype, map_zero]
  have hxorder :
      orderAt X.hom hx (s : X.left.functionField) = divisorBound D hx :=
    orderAt_eq_divisorBound_of_jumpProj_ne_zero hx D (U := ⊤) trivial s hjump
  obtain ⟨W, hxW, hWorder⟩ :=
    exists_localRatioOpen_orderAt_eq (D := D) s hs hx hxorder
  exact ⟨s, W, hs, hxW, hWorder⟩

end
end Hartshorne
