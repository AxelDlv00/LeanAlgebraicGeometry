/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectiveChartImmersion
import HartshorneLib.Chapter4LocalRatioCanonicalBridge
import HartshorneLib.Chapter4ProjectiveTwistTransition
import HartshorneLib.Chapter4BasePointFreeLocalRatioCoverUnconditional

/-!
# Pullback of projective coordinate sections

The normalized affine chart map pulls the section `X_j / X_i` back to its
specified coordinate. These identities concern sections and the actual
scheme morphisms, and supply the coordinate compatibility for the twisting
sheaf pullback.
-/

set_option autoImplicit false

universe u v

open CategoryTheory Opposite TopologicalSpace AlgebraicGeometry MvPolynomial

namespace Hartshorne
namespace ProjectiveCoordinates

noncomputable section

variable {J : Type v} {k B : Type (max u v)} [Field k] [CommRing B] [Algebra k B]

attribute [local instance] MvPolynomial.gradedAlgebra

/-- The affine chart map acts on the entire homogeneous localization by its
defining chart ring homomorphism. -/
theorem toBasicOpen_appTop_awayToSection (i : J) (c : J → B) (hi : c i = 1) :
    Proj.awayToSection (homogeneousSubmodule J k) (X i) ≫
        (Proj.basicOpen (homogeneousSubmodule J k) (X i)).topIso.inv ≫
        (toBasicOpen (k := k) i c hi).appTop ≫
        (Scheme.ΓSpecIso (CommRingCat.of B)).hom =
      CommRingCat.ofHom (chartHom (k := k) i c hi) := by
  let e := Proj.basicOpenIsoSpec (homogeneousSubmodule J k) (X i)
    (X_mem_deg_one (k := k) i) Nat.zero_lt_one
  have he :
      Proj.awayToSection (homogeneousSubmodule J k) (X i) ≫
          (Proj.basicOpen (homogeneousSubmodule J k) (X i)).topIso.inv =
        (Scheme.ΓSpecIso _).inv ≫ e.hom.appTop := by
    rw [show e.hom.appTop =
      (Scheme.ΓSpecIso _).hom ≫ Proj.awayToSection (homogeneousSubmodule J k) (X i) ≫
        (Proj.basicOpen (homogeneousSubmodule J k) (X i)).topIso.inv from
      Proj.basicOpenToSpec_app_top _ _]
    simp
  rw [← Category.assoc, ← Category.assoc, he]
  change ((Scheme.ΓSpecIso _).inv ≫ e.hom.appTop) ≫
      (Spec.map (CommRingCat.ofHom (chartHom (k := k) i c hi)) ≫ e.inv).appTop ≫
      (Scheme.ΓSpecIso (CommRingCat.of B)).hom = _
  rw [Scheme.Hom.comp_appTop]
  simp only [Category.assoc]
  rw [← Category.assoc e.hom.appTop e.inv.appTop,
    ← Scheme.Hom.comp_appTop e.inv e.hom, e.inv_hom_id]
  simp only [Scheme.Hom.id_appTop, Category.id_comp,
    Scheme.ΓSpecIso_naturality, Iso.inv_hom_id_assoc]

/-- The normalized coordinate `X_j / X_i` pulls back to the supplied `j`-th
coordinate on the source affine scheme. -/
theorem toBasicOpen_appTop_chartCoord (i j : J) (c : J → B) (hi : c i = 1) :
    (toBasicOpen (k := k) i c hi).appTop
        ((Proj.basicOpen (homogeneousSubmodule J k) (X i)).topIso.inv
          (Proj.awayToSection (homogeneousSubmodule J k) (X i)
            (chartCoord (k := k) i j))) =
      (Scheme.ΓSpecIso (CommRingCat.of B)).inv (c j) := by
  apply (ConcreteCategory.bijective_of_isIso (Scheme.ΓSpecIso (CommRingCat.of B)).hom).1
  have h := congrArg (fun f : CommRingCat.of
      (HomogeneousLocalization.Away (homogeneousSubmodule J k) (X i)) ⟶
        CommRingCat.of B => f.hom (chartCoord (k := k) i j))
    (toBasicOpen_appTop_awayToSection (k := k) i c hi)
  change (Scheme.ΓSpecIso (CommRingCat.of B)).hom
      ((toBasicOpen (k := k) i c hi).appTop
        ((Proj.basicOpen (homogeneousSubmodule J k) (X i)).topIso.inv
          (Proj.awayToSection (homogeneousSubmodule J k) (X i)
            (chartCoord (k := k) i j)))) =
      chartHom (k := k) i c hi (chartCoord (k := k) i j) at h
  simpa only [chartHom_chartCoord, Iso.inv_hom_id_apply] using h

end
end ProjectiveCoordinates

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X} {n : ℕ}

attribute [local instance] MvPolynomial.gradedAlgebra Scheme.overModule

namespace LocalRatioRegularization

variable {a : LocalRatioCoordinateData D n}

noncomputable local instance coordinatePullbackAlgebra : Algebra k Γ(X.left, a.chart.U) :=
  (X.left.overAlgebraMap k a.chart.U).toAlgebra

/-- The explicit standard-chart factor belongs to the actual local-ratio
projective morphism. -/
theorem toBasicOpen_factor_chartMap (r : LocalRatioRegularization a) :
    (a.chart.U.toSpecΓ ≫ ProjectiveCoordinates.toBasicOpen (k := k)
        a.denominator_index r.regularized r.regularized_denominator_eq_one) ≫
        (Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X a.denominator_index)).ι = r.chartMap := by
  rw [Category.assoc, ProjectiveCoordinates.toBasicOpen_ι, r.chartMap_eq_fromOpen]
  rfl

/-- The standard projective coordinate pulls back to the regularized divisor
coordinate under the actual standard-chart factor of the curve morphism. -/
theorem toBasicOpen_appTop_chartCoord (r : LocalRatioRegularization a)
    (j : Fin (n + 1)) :
    (a.chart.U.toSpecΓ ≫ ProjectiveCoordinates.toBasicOpen (k := k)
        a.denominator_index r.regularized r.regularized_denominator_eq_one).appTop
      ((Proj.basicOpen (homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X a.denominator_index)).topIso.inv
        (Proj.awayToSection (homogeneousSubmodule (Fin (n + 1)) k)
          (MvPolynomial.X a.denominator_index)
          (ProjectiveCoordinates.chartCoord (k := k) a.denominator_index j))) =
      a.chart.U.topIso.inv (r.regularized j) := by
  rw [Scheme.Hom.comp_appTop, CommRingCat.comp_apply,
    ProjectiveCoordinates.toBasicOpen_appTop_chartCoord,
    Scheme.Opens.toSpecΓ_appTop, CommRingCat.comp_apply, Iso.inv_hom_id_apply]

/-- A morphism agreeing with the regularized chart map sends the whole
source chart into its denominator's projective chart. -/
theorem chart_le_preimage_of_restrict_eq (r : LocalRatioRegularization a)
    (f : X.left ⟶ projectiveSpace k n)
    (hf : a.chart.U.ι ≫ f = r.chartMap) :
    a.chart.U ≤ f ⁻¹ᵁ ProjectiveTwist.chart a.denominator_index := by
  have hpre : (a.chart.U.ι ≫ f) ⁻¹ᵁ
      ProjectiveTwist.chart a.denominator_index = ⊤ := by
    rw [hf, ProjectiveTwist.chart, r.chartMap_preimage_basicOpen_ambient,
      r.regularized_denominator_eq_one, Scheme.basicOpen_one, Scheme.Opens.ι_preimage_self]
  intro x hx
  have hmem : (⟨x, hx⟩ : a.chart.U) ∈
      (a.chart.U.ι ≫ f) ⁻¹ᵁ ProjectiveTwist.chart a.denominator_index := by
    rw [hpre]
    trivial
  exact hmem

/-- The actual morphism's section pullback is the regularized coordinate,
provided its restriction is the local-ratio map. -/
theorem appLE_coordinate_of_restrict_eq (r : LocalRatioRegularization a)
    (f : X.left ⟶ projectiveSpace k n)
    (hf : a.chart.U.ι ≫ f = r.chartMap) (j : Fin (n + 1)) :
    (f.appLE (ProjectiveTwist.chart a.denominator_index) a.chart.U
        (r.chart_le_preimage_of_restrict_eq f hf)).hom
      (ProjectiveTwist.coordinate a.denominator_index j) = r.regularized j := by
  let h := r.chart_le_preimage_of_restrict_eq f hf
  have hres : f.resLE (ProjectiveTwist.chart a.denominator_index) a.chart.U h =
      a.chart.U.toSpecΓ ≫ ProjectiveCoordinates.toBasicOpen (k := k)
        a.denominator_index r.regularized r.regularized_denominator_eq_one := by
    apply (cancel_mono (ProjectiveTwist.chart (k := k) a.denominator_index).ι).1
    exact (Scheme.Hom.resLE_comp_ι f h).trans (hf.trans r.toBasicOpen_factor_chartMap.symm)
  have hp := r.toBasicOpen_appTop_chartCoord j
  rw [← hres] at hp
  have htop : (f.resLE (ProjectiveTwist.chart a.denominator_index) a.chart.U h).appTop =
      (ProjectiveTwist.chart a.denominator_index).topIso.hom ≫
        f.appLE (ProjectiveTwist.chart a.denominator_index) a.chart.U h ≫
        a.chart.U.topIso.inv := Scheme.Hom.resLE_app_top f h
  erw [htop] at hp
  apply (ConcreteCategory.bijective_of_isIso a.chart.U.topIso.inv).1
  simp only [CommRingCat.comp_apply, Iso.inv_hom_id_apply] at hp
  convert hp using 1
  rfl

end LocalRatioRegularization

namespace BasePointFreeLocalRatioCover

/-- Each selected denominator chart maps into the corresponding standard
projective chart under the glued smooth-curve morphism. -/
theorem selectedChart_le_preimage_chart
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) :
    (selectedCoordinates basis hD x).chart.U ≤
      gluedMap_of_smoothCurve basis hD ⁻¹ᵁ
        ProjectiveTwist.chart (selectedCoordinates basis hD x).denominator_index :=
  (selectedRegularization basis hD x).chart_le_preimage_of_restrict_eq
    (gluedMap_of_smoothCurve basis hD)
    (chartOpenCover_ι_projectiveMapProducer_of_smoothCurve basis hD x)

/-- The glued map pulls `X_j / X_d` back to the selected normalized divisor
section on the chart with denominator `d`. -/
theorem gluedMap_of_smoothCurve_appLE_coordinate
    (basis : Module.Basis (Fin (n + 1)) k (CurveDivisorSectionSpace D))
    (hD : BasePointFreeLinearSystem D) (x : NonGenericPoint X) (j : Fin (n + 1)) :
    ((gluedMap_of_smoothCurve basis hD).appLE
        (ProjectiveTwist.chart (selectedCoordinates basis hD x).denominator_index)
        (selectedCoordinates basis hD x).chart.U
        (selectedChart_le_preimage_chart basis hD x)).hom
      (ProjectiveTwist.coordinate (selectedCoordinates basis hD x).denominator_index j) =
      (selectedRegularization basis hD x).regularized j :=
  (selectedRegularization basis hD x).appLE_coordinate_of_restrict_eq
    (gluedMap_of_smoothCurve basis hD)
    (chartOpenCover_ι_projectiveMapProducer_of_smoothCurve basis hD x) j

end BasePointFreeLocalRatioCover
end
end Hartshorne
