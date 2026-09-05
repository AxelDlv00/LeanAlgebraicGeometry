/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4LocalRatioProjectiveChart

/-!
# Hartshorne IV.3.1: the canonical chart restriction

The local chart map is defined by `Proj.fromOfGlobalSections`.  This module
exposes its restriction to the standard open selected by the normalized
denominator, so later comparison with the explicit `ProjectiveCoordinates`
construction can be made on an affine target chart.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Limits Opposite TopologicalSpace
open AlgebraicGeometry
open MvPolynomial
open HomogeneousLocalization

namespace Hartshorne

noncomputable section

namespace ProjectiveCoordinates

variable {J : Type v} {k' : Type (max u v)} [CommRing k']

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The canonical global-sections map agrees with the normalized affine chart.

When one homogeneous coordinate evaluates to `1`, the corresponding member of
the canonical `Proj` cover is the whole source.  The glued canonical map is
therefore the `Spec` map attached to the normalized coordinates. -/
theorem fromOfGlobalSections_eq_fromSpec_normalized
    {Y : Scheme.{max u v}} [Algebra k' Γ(Y, ⊤)]
    (i : J) (c : J → Γ(Y, ⊤)) (hi : c i = 1) :
    Proj.fromOfGlobalSections (homogeneousSubmodule J k') (eval (k := k') c)
      (eval_irrelevant_span_of_normalized (k := k') i c hi) =
      Y.toSpecΓ ≫ fromSpec (k := k') i c hi := by
  let f := eval (k := k') c
  let hf := eval_irrelevant_span_of_normalized (k := k') i c hi
  let 𝒰 := Proj.openCoverOfMapIrrelevantEqTop (homogeneousSubmodule J k') f hf
  let I : 𝒰.I₀ :=
    ⟨1, (X i : MvPolynomial J k'), Nat.zero_lt_one, X_mem_deg_one (k := k') i⟩
  have hfi : f (X i) = (1 : Γ(Y, ⊤)) := by
    simp [f, eval, hi]
  let q : Localization.Away (X i : MvPolynomial J k') →+*
      Localization.Away (f (X i) : Γ(Y, ⊤)) :=
    IsLocalization.map
      (M := Submonoid.powers (X i : MvPolynomial J k'))
      (T := Submonoid.powers (f (X i) : Γ(Y, ⊤)))
      (Localization.Away (f (X i) : Γ(Y, ⊤))) f (by
        rw [← Submonoid.map_le_iff_le_comap, Submonoid.map_powers])
  have hq :
      q.comp (algebraMap (Away (homogeneousSubmodule J k') (X i))
        (Localization.Away (X i))) =
        (algebraMap (Γ(Y, ⊤)) (Localization.Away (f (X i)))).comp
          (chartHom (k := k') i c hi) := by
    apply RingHom.ext
    intro w
    obtain ⟨n, a, ha, rfl⟩ := Away.mk_surjective
      (homogeneousSubmodule J k') (X_mem_deg_one (k := k') i) w
    simp only [q, RingHom.comp_apply, HomogeneousLocalization.algebraMap_apply,
      HomogeneousLocalization.Away.val_mk]
    rw [Localization.mk_eq_mk'_apply, IsLocalization.map_mk']
    rw [ProjectiveCoordinates.chartHom_mk (k := k') i c hi
      (X_mem_deg_one (k := k') i) n a ha]
    change _ = algebraMap (Γ(Y, ⊤)) (Localization.Away (f (X i))) (f a)
    convert IsLocalization.mk'_one
      (M := Submonoid.powers (f (X i)))
      (S := Localization.Away (f (X i))) (f a) using 1 ;
      simp [map_pow, hfi]
    congr
  have hrange : (𝒰.f I).opensRange = (⊤ : Y.Opens) := by
    change ((Y.basicOpen (f (X i))).ι).opensRange = (⊤ : Y.Opens)
    rw [Scheme.Opens.opensRange_ι, hfi]
    exact Scheme.basicOpen_one Y
  letI : IsIso (𝒰.f I) :=
    isIso_of_isOpenImmersion_of_opensRange_eq_top _ hrange
  have hcomp :
      𝒰.f I ≫ Proj.fromOfGlobalSections (homogeneousSubmodule J k') f hf =
        𝒰.f I ≫ (Y.toSpecΓ ≫ fromSpec (k := k') i c hi) := by
    rw [show Proj.fromOfGlobalSections (homogeneousSubmodule J k') f hf =
        𝒰.glueMorphisms (fun ri =>
          Proj.toBasicOpenOfGlobalSections (homogeneousSubmodule J k') f rfl
              ri.2.2.1 ri.2.2.2 ≫ Scheme.Opens.ι _) _ by rfl]
    rw [𝒰.ι_glueMorphisms]
    change Proj.toBasicOpenOfGlobalSections (homogeneousSubmodule J k') f rfl
        Nat.zero_lt_one (X_mem_deg_one (k := k') i) ≫
          (Proj.basicOpen (homogeneousSubmodule J k') (X i)).ι =
      (Y.basicOpen (f (X i))).ι ≫ Y.toSpecΓ ≫ fromSpec (k := k') i c hi
    rw [fromSpec, ← Proj.basicOpenIsoSpec_inv_ι]
    simp only [← Category.assoc]
    rw [cancel_mono]
    refine (cancel_mono
      (Proj.basicOpenIsoSpec (homogeneousSubmodule J k') (X i)
        (X_mem_deg_one (k := k') i) Nat.zero_lt_one).hom).mp ?_
    rw [Proj.toBasicOpenOfGlobalSections]
    simp only [Category.assoc, Iso.inv_hom_id, Category.comp_id]
    change (Y.isoOfEq _).inv ≫
      Y.toSpecΓ ∣_ PrimeSpectrum.basicOpen (f (X i)) ≫
        (basicOpenIsoSpecAway (f (X i))).hom ≫
          Spec.map (CommRingCat.ofHom (q.comp
            (algebraMap (Away (homogeneousSubmodule J k') (X i))
              (Localization.Away (X i))))) =
      (Y.basicOpen (f (X i))).ι ≫ Y.toSpecΓ ≫
        Spec.map (CommRingCat.ofHom (chartHom (k := k') i c hi))
    rw [hq]
    rw [CommRingCat.ofHom_comp, Spec.map_comp]
    simp only [basicOpenIsoSpecAway]
    rw [IsOpenImmersion.isoOfRangeEq_hom_fac_assoc]
    simp only [← Category.assoc, morphismRestrict_ι, Scheme.isoOfEq_inv_ι]
  exact (cancel_epi (𝒰.f I)).mp hcomp

end ProjectiveCoordinates

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}
variable {n : ℕ}

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

attribute [local instance] MvPolynomial.gradedAlgebra

noncomputable local instance chartAlgebraBridge : Algebra k Γ(a.chart.U, ⊤) :=
  (a.chart.U.toScheme.overAlgebraMap k (⊤ : a.chart.U.toScheme.Opens)).toAlgebra

theorem chartMap_preimage_basicOpen_eval
    (r : LocalRatioRegularization a) (j : Fin (n + 1)) :
    r.chartMap ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      a.chart.U.toScheme.basicOpen
        (((MvPolynomial.aeval r.chartSection).toRingHom :
          MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤))
          (MvPolynomial.X j)) := by
  rw [r.chartMap_preimage_basicOpen]
  exact congrArg (fun z => a.chart.U.toScheme.basicOpen z) (r.chartEval_X j).symm

set_option maxHeartbeats 800000 in
-- The canonical Proj restriction expands through a large glued cover.
/-- Restricting the canonical chart map to its denominator standard open is
the affine map supplied by `toBasicOpenOfGlobalSections`. -/
theorem chartMap_morphismRestrict_denominator
    (r : LocalRatioRegularization a) :
    r.chartMap ∣_
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X a.denominator_index) =
      (Scheme.isoOfEq a.chart.U.toScheme (chartMap_preimage_basicOpen_eval
        (a := a) r
        a.denominator_index)).hom ≫
        Proj.toBasicOpenOfGlobalSections
          (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.aeval r.chartSection).toRingHom rfl
          Nat.zero_lt_one
          ((MvPolynomial.mem_homogeneousSubmodule _ _).mpr
            (MvPolynomial.isHomogeneous_X k a.denominator_index)) := by
  let f : MvPolynomial (Fin (n + 1)) k →+* Γ(a.chart.U, ⊤) :=
    (MvPolynomial.aeval r.chartSection).toRingHom
  have hf :
      (HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map f = ⊤ := by
    exact chartEval_irrelevant_span (a := a) r
  have hdeg : MvPolynomial.X a.denominator_index ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 1 :=
    (MvPolynomial.mem_homogeneousSubmodule _ _).mpr
      (MvPolynomial.isHomogeneous_X k a.denominator_index)
  change
    (Proj.fromOfGlobalSections
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf) ∣_
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X a.denominator_index) = _
  have hrestrict :=
    Proj.fromOfGlobalSections_morphismRestrict
      (𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (f := f) (hf := hf) (r := MvPolynomial.X a.denominator_index) (n := 1)
      Nat.zero_lt_one hdeg
  convert hrestrict using 1
  all_goals simp only [f]
  all_goals rfl

set_option maxHeartbeats 800000 in
-- The canonical-cover normalization and affine transport require extra elaboration.
/-- The canonical chart map is the normalized affine coordinate map attached
to the regularized sections. -/
theorem chartMap_eq_fromOpen
    (r : LocalRatioRegularization a) :
    r.chartMap =
      ProjectiveCoordinates.fromOpen (k := k) (J := Fin (n + 1))
        (Z := X.left) a.chart.U
        (X.left.overAlgebraMap k a.chart.U) a.denominator_index r.regularized
        r.regularized_denominator_eq_one := by
  change Proj.fromOfGlobalSections
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      r.chartEval r.chartEval_irrelevant_span = _
  letI : Algebra k Γ(X.left, a.chart.U) :=
    (X.left.overAlgebraMap k a.chart.U).toAlgebra
  let rtop : Γ(X.left, a.chart.U) →ₐ[k] Γ(a.chart.U.toScheme, ⊤) :=
    { toRingHom := a.chart.U.topIso.inv.hom
      commutes' := by
        intro z
        have hpi : a.chart.U.ι ≫ (X.left ↘ Spec (CommRingCat.of k)) =
            (a.chart.U.toScheme ↘ Spec (CommRingCat.of k)) := by
          exact (inferInstance : a.chart.U.ι.IsOver
            (Spec (CommRingCat.of k))).1
        have hiso : a.chart.U.topIso.inv.hom =
            (a.chart.U.ι.appLE a.chart.U (⊤ : a.chart.U.toScheme.Opens)
              a.chart.U.ι_preimage_self.ge).hom := by
          rw [Scheme.Opens.ι_appLE]
          simp only [Scheme.Opens.topIso_inv]
          congr 1
        rw [hiso]
        exact Scheme.Hom.appLE_overAlgebraMap a.chart.U.ι hpi
          a.chart.U.ι_preimage_self.ge z }
  have hgeneric :=
    ProjectiveCoordinates.fromOfGlobalSections_eq_fromSpec_normalized
      (J := Fin (n + 1)) (k' := k) (Y := a.chart.U.toScheme)
      a.denominator_index r.chartSection r.chartSection_denominator_eq_one
  have hfrom := ProjectiveCoordinates.SpecMap_fromSpec (k := k) rtop
      a.denominator_index r.regularized r.regularized_denominator_eq_one
  have hsection :
      (fun j => rtop (r.regularized j)) = r.chartSection := by
    funext j
    change a.chart.U.topIso.inv.hom (r.regularized j) =
      a.chart.U.topIso.inv.hom (r.regularized j)
    rfl
  have hfrom' :
      Spec.map a.chart.U.topIso.inv ≫
          ProjectiveCoordinates.fromSpec (k := k) a.denominator_index
            r.regularized r.regularized_denominator_eq_one =
        ProjectiveCoordinates.fromSpec (k := k) a.denominator_index
          r.chartSection r.chartSection_denominator_eq_one := by
    have hmap : Spec.map a.chart.U.topIso.inv =
        Spec.map (CommRingCat.ofHom rtop.toRingHom) := by
      rfl
    rw [hmap]
    simpa only [hsection] using hfrom
  change Proj.fromOfGlobalSections
      (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (ProjectiveCoordinates.eval (k := k) r.chartSection)
      (ProjectiveCoordinates.eval_irrelevant_span_of_normalized
        (k := k) a.denominator_index r.chartSection
        r.chartSection_denominator_eq_one) = _
  rw [hgeneric]
  unfold ProjectiveCoordinates.fromOpen
  rw [Scheme.Opens.toSpecΓ, Category.assoc, hfrom']

end LocalRatioRegularization

namespace GlobalSectionsProjectiveMapData

attribute [local instance] MvPolynomial.gradedAlgebra

noncomputable local instance globalSectionsAlgebra : Algebra k Γ(X.left, ⊤) :=
  (X.left.overAlgebraMap k (⊤ : X.left.Opens)).toAlgebra

omit [IsAlgClosed k] [IsIntegral X.left] [SmoothOfRelativeDimension 1 X.hom]
  [IsProper X.hom] in
/-- The canonical projective map sends the inverse image of a standard
projective open to the principal open defined by the corresponding section. -/
@[simp] theorem map_preimage_basicOpen
    {n : ℕ} (data : GlobalSectionsProjectiveMapData (k := k) (X := X) n)
    (j : Fin (n + 1)) :
    data.map ⁻¹ᵁ
        Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X j) =
      X.left.basicOpen (data.sections j) := by
  let f : MvPolynomial (Fin (n + 1)) k →+* Γ(X.left, ⊤) :=
    (MvPolynomial.aeval data.sections).toRingHom
  have hf :
      (HomogeneousIdeal.irrelevant
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)).toIdeal.map f = ⊤ := by
    exact data.irrelevant_span
  have hdeg : MvPolynomial.X j ∈
      MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k 1 :=
    (MvPolynomial.mem_homogeneousSubmodule _ _).mpr
      (MvPolynomial.isHomogeneous_X k j)
  change
    Proj.fromOfGlobalSections
        (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k) f hf ⁻¹ᵁ
      Proj.basicOpen (MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
        (MvPolynomial.X j) = _
  have hpre :=
    Proj.fromOfGlobalSections_preimage_basicOpen
      (𝒜 := MvPolynomial.homogeneousSubmodule (Fin (n + 1)) k)
      (f := f) (hf := hf) (r := MvPolynomial.X j) (n := 1)
      Nat.zero_lt_one hdeg
  simpa [f] using hpre

end GlobalSectionsProjectiveMapData

end
end Hartshorne
