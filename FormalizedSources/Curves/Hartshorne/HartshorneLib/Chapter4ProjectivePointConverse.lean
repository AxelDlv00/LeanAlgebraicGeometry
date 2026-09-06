/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectivePointSeparation
import HartshorneLib.Chapter4TwoPointFiberEvaluation

/-!
# Distinct-point converse for the divisor-section projective map

Injectivity of the projective morphism attached to a fixed section basis forces
the complete linear system to separate distinct closed points.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry MvPolynomial

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

attribute [local instance] functionFieldOverModule MvPolynomial.gradedAlgebra

private def closedPointResidueEquiv {x : X.left}
    (hx : x ≠ genericPoint X.left) : k ≃+* X.left.residueField x := by
  letI : SmoothOfRelativeDimension 1 (X.left ↘ Spec (CommRingCat.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 X.hom)
  letI : Smooth (X.left ↘ Spec (CommRingCat.of k)) :=
    SmoothOfRelativeDimension.smooth 1 _
  letI : Module k (X.left.residueField x) := X.left.residueFieldOverModule k x
  letI := Scheme.residueDeg_finite (K := k) hx
  letI : Algebra k (X.left.residueField x) :=
    (X.left.residueOverAlgebraMap k x).toAlgebra
  letI : Algebra.IsIntegral k (X.left.residueField x) :=
    Algebra.IsIntegral.of_finite k _
  exact RingEquiv.ofBijective (X.left.residueOverAlgebraMap k x)
    IsAlgClosed.algebraMap_bijective_of_isIntegral

private def closedPointEvaluation {x : X.left}
    (hx : x ≠ genericPoint X.left) (U : X.left.Opens) (hxU : x ∈ U) :
    Γ(X.left, U) →+* k :=
  (closedPointResidueEquiv hx).symm.toRingHom.comp (X.left.evaluation U x hxU).hom

omit [IsProper X.hom] in
private theorem closedPointEvaluation_overAlgebraMap {x : X.left}
    (hx : x ≠ genericPoint X.left) (U : X.left.Opens) (hxU : x ∈ U) (c : k) :
    closedPointEvaluation hx U hxU (X.left.overAlgebraMap k U c) = c := by
  have hgr : X.left.presheaf.germ ⊤ x trivial =
      X.left.presheaf.map (homOfLE (le_top : U ≤ ⊤)).op ≫
        X.left.presheaf.germ U x hxU :=
    (X.left.presheaf.germ_res (homOfLE (le_top : U ≤ ⊤)) x hxU).symm
  have hscalar : (X.left.evaluation U x hxU).hom (X.left.overAlgebraMap k U c) =
      X.left.residueOverAlgebraMap k x c := by
    unfold Scheme.residueOverAlgebraMap
    rw [hgr]
    simp only [RingHom.comp_apply, CommRingCat.hom_comp, Scheme.evaluation,
      X.left.overAlgebraMap_apply_res k (homOfLE (le_top : U ≤ ⊤)).op]
  change (closedPointResidueEquiv hx).symm _ = c
  rw [hscalar]
  exact (closedPointResidueEquiv hx).symm_apply_apply c

omit [IsProper X.hom] in
private theorem closedPointEvaluation_ne_zero_iff {x : X.left}
    (hx : x ≠ genericPoint X.left) (U : X.left.Opens) (hxU : x ∈ U)
    (s : Γ(X.left, U)) :
    closedPointEvaluation hx U hxU s ≠ 0 ↔ x ∈ X.left.basicOpen s := by
  change (closedPointResidueEquiv hx).symm ((X.left.evaluation U x hxU).hom s) ≠ 0 ↔ _
  rw [map_ne_zero_iff _ (closedPointResidueEquiv hx).symm.injective]
  exact X.left.evaluation_ne_zero_iff_mem_basicOpen x hxU s

namespace BasePointFreeLocalRatioCover

omit [IsAlgClosed k] in
private theorem projectivePoint_eq_of_linearForm_vanishing
    (z w : projectiveSpace k n) (a b : Fin (n + 1) → k)
    (i l : Fin (n + 1)) (hai : a i = 1) (hbl : b l = 1)
    (ha : ∀ (p : MvPolynomial (Fin (n + 1)) k) (m : ℕ) (_ : 0 < m)
      (_ : p ∈ homogeneousSubmodule (Fin (n + 1)) k m),
      z ∈ Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k) p ↔
        ProjectiveCoordinates.eval a p ≠ 0)
    (hb : ∀ (p : MvPolynomial (Fin (n + 1)) k) (m : ℕ) (_ : 0 < m)
      (_ : p ∈ homogeneousSubmodule (Fin (n + 1)) k m),
      w ∈ Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k) p ↔
        ProjectiveCoordinates.eval b p ≠ 0)
    (hlin : ∀ c : Fin (n + 1) → k,
      ProjectiveCoordinates.eval a (ProjectiveCoordinates.linearForm c) = 0 →
      ProjectiveCoordinates.eval b (ProjectiveCoordinates.linearForm c) = 0) :
    z = w := by
  classical
  have hproportional (j : Fin (n + 1)) : b j = a j * b i := by
    let c : Fin (n + 1) → k :=
      fun t => (if t = j then 1 else 0) - (if t = i then a j else 0)
    have hza : ProjectiveCoordinates.eval a (ProjectiveCoordinates.linearForm c) = 0 := by
      simp [ProjectiveCoordinates.eval, ProjectiveCoordinates.linearForm, c,
        sub_mul, Finset.sum_sub_distrib, hai]
    have hzb := hlin c hza
    simpa [ProjectiveCoordinates.eval, ProjectiveCoordinates.linearForm, c,
      sub_mul, Finset.sum_sub_distrib, sub_eq_zero] using hzb
  have hbi : b i ≠ 0 := by
    intro hzero
    have h := hproportional l
    rw [hbl, hzero, mul_zero] at h
    exact one_ne_zero h
  have heval {p : MvPolynomial (Fin (n + 1)) k} {m : ℕ}
      (hp : p ∈ homogeneousSubmodule (Fin (n + 1)) k m) :
      ProjectiveCoordinates.eval b p = b i ^ m * ProjectiveCoordinates.eval a p := by
    have hfun : b = fun j => b i * a j := by
      funext j
      exact (hproportional j).trans (mul_comm _ _)
    conv_lhs => rw [hfun]
    exact ProjectiveCoordinates.eval_smul_of_isHomogeneous (b i) a hp
  have hbasic {p : MvPolynomial (Fin (n + 1)) k} {m : ℕ}
      (hm : 0 < m) (hp : p ∈ homogeneousSubmodule (Fin (n + 1)) k m) :
      z ∈ Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k) p ↔
        w ∈ Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k) p := by
    rw [ha p m hm hp, hb p m hm hp, heval hp, mul_ne_zero_iff]
    exact (and_iff_right (pow_ne_zero _ hbi)).symm
  have hzi : (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) k) ∉
      z.asHomogeneousIdeal.toIdeal := by
    have h := (ha (MvPolynomial.X i) 1 one_pos
      (ProjectiveCoordinates.X_mem_deg_one i)).mpr (by simp [hai])
    exact h
  have hwi : (MvPolynomial.X i : MvPolynomial (Fin (n + 1)) k) ∉
      w.asHomogeneousIdeal.toIdeal := by
    exact (hbasic one_pos (ProjectiveCoordinates.X_mem_deg_one i)).mp hzi
  apply ProjectiveSpectrum.ext
  apply HomogeneousIdeal.ext'
  intro m p hp
  have h := not_congr (hbasic (Nat.succ_pos m)
    (SetLike.mul_mem_graded hp (ProjectiveCoordinates.X_mem_deg_one i)))
  change ¬ p * MvPolynomial.X i ∉ z.asHomogeneousIdeal.toIdeal ↔
    ¬ p * MvPolynomial.X i ∉ w.asHomogeneousIdeal.toIdeal at h
  change p ∈ z.asHomogeneousIdeal.toIdeal ↔ p ∈ w.asHomogeneousIdeal.toIdeal
  simpa only [not_not, z.isPrime.mul_mem_iff_mem_or_mem,
    w.isPrime.mul_mem_iff_mem_or_mem, hzi, hwi, or_false] using h

private def selectedPointCoordinates
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (q : NonGenericPoint X) : Fin (n + 1) → k :=
  fun j => closedPointEvaluation q.2 (selectedCoordinates basis hD q).chart.U
    (selectedOpen_spec basis hD q).1 ((selectedRegularization basis hD q).regularized j)

private theorem selectedPointCoordinates_denominator
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (q : NonGenericPoint X) :
    selectedPointCoordinates basis hD q (selectedCoordinates basis hD q).denominator_index = 1 := by
  simp only [selectedPointCoordinates, LocalRatioRegularization.regularized_denominator_eq_one,
    map_one]

private theorem selectedPointCoordinates_basicOpen_iff
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (q : NonGenericPoint X)
    (p : MvPolynomial (Fin (n + 1)) k) (m : ℕ) (hm : 0 < m)
    (hp : p ∈ homogeneousSubmodule (Fin (n + 1)) k m) :
    gluedMap_of_smoothCurve basis hD q.1 ∈
        Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k) p ↔
      ProjectiveCoordinates.eval (selectedPointCoordinates basis hD q) p ≠ 0 := by
  let a := selectedCoordinates basis hD q
  let r := selectedRegularization basis hD q
  letI : Algebra k Γ(a.chart.U, ⊤) :=
    (a.chart.U.toScheme.overAlgebraMap k (⊤ : a.chart.U.toScheme.Opens)).toAlgebra
  have hqU : q.1 ∈ a.chart.U := (selectedOpen_spec basis hD q).1
  let x : a.chart.U := ⟨q.1, hqU⟩
  let e : MvPolynomial (Fin (n + 1)) k →+* Γ(X.left, a.chart.U) :=
    MvPolynomial.eval₂Hom (X.left.overAlgebraMap k a.chart.U) r.regularized
  have hscalar (c : k) : a.chart.U.topIso.inv.hom
      (X.left.overAlgebraMap k a.chart.U c) =
        a.chart.U.toScheme.overAlgebraMap k ⊤ c := by
    have hpi : a.chart.U.ι ≫ (X.left ↘ Spec (CommRingCat.of k)) =
        (a.chart.U.toScheme ↘ Spec (CommRingCat.of k)) :=
      (inferInstance : a.chart.U.ι.IsOver (Spec (CommRingCat.of k))).1
    have hiso : a.chart.U.topIso.inv.hom =
        (a.chart.U.ι.appLE a.chart.U (⊤ : a.chart.U.toScheme.Opens)
          a.chart.U.ι_preimage_self.ge).hom := by
      rw [Scheme.Opens.ι_appLE]
      simp only [Scheme.Opens.topIso_inv]
      congr 1
    rw [hiso]
    exact Scheme.Hom.appLE_overAlgebraMap a.chart.U.ι hpi
      a.chart.U.ι_preimage_self.ge c
  have he : a.chart.U.topIso.inv.hom.comp e = r.chartEval := by
    apply MvPolynomial.ringHom_ext
    · intro c
      simp only [RingHom.comp_apply, e, MvPolynomial.eval₂Hom_C]
      change _ = (MvPolynomial.aeval r.chartSection) (MvPolynomial.C c)
      rw [MvPolynomial.aeval_C]
      exact hscalar c
    · intro j
      simp [e, LocalRatioRegularization.chartSection]
  have hrestriction := chartOpenCover_ι_projectiveMapProducer_of_smoothCurve basis hD q
  have himage : r.chartMap x = gluedMap_of_smoothCurve basis hD q.1 :=
    (congrArg (fun f => f x) hrestriction).symm
  rw [← himage]
  change x ∈ r.chartMap ⁻¹ᵁ
    Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k) p ↔ _
  change x ∈ (Proj.fromOfGlobalSections _ r.chartEval r.chartEval_irrelevant_span) ⁻¹ᵁ _ ↔ _
  rw [Proj.fromOfGlobalSections_preimage_basicOpen _ _ _ hm hp]
  have hep : r.chartEval p = a.chart.U.topIso.inv.hom (e p) :=
    (congrArg (fun f : MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤) => f p) he).symm
  rw [hep]
  have hmem : x ∈ a.chart.U.toScheme.basicOpen (a.chart.U.topIso.inv.hom (e p)) ↔
      q.1 ∈ X.left.basicOpen (e p) := by
    rw [← Scheme.Opens.ι_image_basicOpen_topIso_inv (X := X.left) (U := a.chart.U)]
    exact (Function.Injective.mem_set_image a.chart.U.ι.isOpenEmbedding.injective).symm
  rw [hmem]
  rw [← closedPointEvaluation_ne_zero_iff q.2 a.chart.U hqU]
  have hev : (closedPointEvaluation q.2 a.chart.U hqU).comp e =
      ProjectiveCoordinates.eval (selectedPointCoordinates basis hD q) := by
    apply MvPolynomial.ringHom_ext
    · intro c
      simp only [RingHom.comp_apply, e, MvPolynomial.eval₂Hom_C,
        ProjectiveCoordinates.eval, MvPolynomial.eval₂Hom_C]
      exact closedPointEvaluation_overAlgebraMap q.2 a.chart.U hqU c
    · intro j
      simp [e, selectedPointCoordinates, a, r]
  exact Iff.of_eq (congrArg (fun f : MvPolynomial (Fin (n + 1)) k →+* k => f p ≠ 0) hev)

/-- Distinct images under the divisor-section map provide a section vanishing
at the first closed point and nonvanishing at the second. -/
theorem exists_section_devissage_x_not_devissage_y_of_gluedMap_ne
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x y : X.left)
    (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (himages : gluedMap_of_smoothCurve basis hD x ≠ gluedMap_of_smoothCurve basis hD y) :
    ∃ s : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤,
      (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ := by
  classical
  by_contra hnone
  push Not at hnone
  apply himages
  apply projectivePoint_eq_of_linearForm_vanishing _ _
    (selectedPointCoordinates basis hD ⟨x, hx⟩)
    (selectedPointCoordinates basis hD ⟨y, hy⟩)
    (selectedCoordinates basis hD ⟨x, hx⟩).denominator_index
    (selectedCoordinates basis hD ⟨y, hy⟩).denominator_index
    (selectedPointCoordinates_denominator basis hD ⟨x, hx⟩)
    (selectedPointCoordinates_denominator basis hD ⟨y, hy⟩)
    (selectedPointCoordinates_basicOpen_iff basis hD ⟨x, hx⟩)
    (selectedPointCoordinates_basicOpen_iff basis hD ⟨y, hy⟩)
  intro c hc
  let s : divisorSections D ⊤ := divisorSectionSpaceEquiv
    (basis.repr.symm (Finsupp.equivFunOnFinite.symm c))
  have hcoeff : (basis.repr ((divisorSectionSpaceEquiv (D := D)).symm s) :
      Fin (n + 1) → k) = c := by
    ext j
    simp [s]
  have hxs : (s : X.left.functionField) ∈
      divisorSections (CurveDivisor.devissageDivisor hx D) ⊤ := by
    apply (jumpProj_eq_zero_iff_mem_divisorSections_devissage hx D s).mp
    by_contra hne
    have hmem := (gluedMap_mem_linearForm_basicOpen_iff_jumpProj_ne_zero basis hD s x hx).mpr hne
    rw [hcoeff] at hmem
    exact ((selectedPointCoordinates_basicOpen_iff basis hD ⟨x, hx⟩ _ 1 one_pos
      (ProjectiveCoordinates.linearForm_mem_homogeneousSubmodule c)).mp hmem) hc
  have hys := hnone ⟨s, hxs⟩
  by_contra hne
  have hmem := (selectedPointCoordinates_basicOpen_iff basis hD ⟨y, hy⟩ _ 1 one_pos
    (ProjectiveCoordinates.linearForm_mem_homogeneousSubmodule c)).mpr hne
  rw [← hcoeff] at hmem
  have hjump := (gluedMap_mem_linearForm_basicOpen_iff_jumpProj_ne_zero basis hD s y hy).mp hmem
  exact ((jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hy D s).mp hjump) hys

/-- An injective divisor-section projective map separates every pair of
distinct closed points in the complete linear system. -/
theorem exists_section_devissage_x_not_devissage_y_of_gluedMap_injective
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (hinj : Function.Injective (gluedMap_of_smoothCurve basis hD))
    (x y : X.left) (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (hxy : x ≠ y) :
    ∃ s : divisorSections (CurveDivisor.devissageDivisor hx D) ⊤,
      (s : X.left.functionField) ∉
        divisorSections (CurveDivisor.devissageDivisor hy D) ⊤ :=
  exists_section_devissage_x_not_devissage_y_of_gluedMap_ne basis hD x y hx hy
    (fun h => hxy (hinj h))

/-- Injectivity of the projective morphism gives the two-dimensional section
drop at any pair of distinct closed points. -/
theorem h0_sub_h0_twoDevissage_eq_two_of_gluedMap_injective
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    (hinj : Function.Injective (gluedMap_of_smoothCurve basis hD))
    (x y : X.left) (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (hxy : x ≠ y) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
      CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor hy
        (CurveDivisor.devissageDivisor hx D))) = 2 := by
  obtain ⟨s, hs⟩ :=
    exists_section_devissage_x_not_devissage_y_of_gluedMap_injective basis hD hinj x y hx hy hxy
  have hsecond := (h0_sub_h0_devissage_eq_one_iff_exists_jumpProj_ne_zero hy
    (CurveDivisor.devissageDivisor hx D)).mpr
      ⟨s, (jumpProj_ne_zero_iff_not_mem_divisorSections_devissage hy
        (CurveDivisor.devissageDivisor hx D) s).mpr (fun h =>
          hs ((divisorSections_twoDevissage_le_inf x y hx hy h).2))⟩
  have hfirst := hD x hx
  omega

/-- The distinct-point half of the numerical very-ampleness criterion follows
from a closed immersion of the fixed-basis projective morphism. -/
theorem h0_sub_h0_twoDevissage_eq_two_of_gluedMap_isClosedImmersion
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D)
    [IsClosedImmersion (gluedMap_of_smoothCurve basis hD)]
    (x y : X.left) (hx : x ≠ genericPoint X.left) (hy : y ≠ genericPoint X.left)
    (hxy : x ≠ y) :
    (CategoryTheory.Sheaf.h0 (divisorSheaf D) : ℤ) -
      CategoryTheory.Sheaf.h0 (divisorSheaf (CurveDivisor.devissageDivisor hy
        (CurveDivisor.devissageDivisor hx D))) = 2 :=
  h0_sub_h0_twoDevissage_eq_two_of_gluedMap_injective basis hD
    (gluedMap_of_smoothCurve basis hD).isClosedEmbedding.injective x y hx hy hxy

end BasePointFreeLocalRatioCover

end
end Hartshorne
