/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepAwaySpanGlueAff
import AlgebraicJacobian.Picard.DivRepGlobalClassifyAff
import AlgebraicJacobian.Picard.DivSchemeAtlasFactor

/-!
# Surjectivity of the widened divisor classifier from universal chart classes

A widened class on every `DivScheme` carve chart, classified by that chart's canonical map,
pulls to every affine point of `DivScheme`.  The chart atlas factors the point over a finite
away cover; classifier naturality and injectivity give compatibility on the canonical overlap
localizations; and `DivFamZarAff.exists_glue_of_awaySpan` glues the local classes.

This is the only affine construction needed by `DivRepAffinePullbackAff`: once classifier
surjectivity is known, `ofClassifierSurjective` derives the pullback clause and naturality,
and `representableBy` performs the affine-to-general lift.

## Main declarations

* `AlgebraicGeometry.DivRepChartFamilyAff.IsChartClause` -- each supplied chart class is
  classified by the canonical chart map.
* `AlgebraicGeometry.divRepClassifyZarAff_surjective_of_chartClause` -- affine classifier
  surjectivity from those chart classes.
* `AlgebraicGeometry.divFunctorAff_representableBy_of_chartClause` -- the widened divisor
  representability endpoint.
-/

set_option autoImplicit false
set_option quotPrecheck false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory

namespace AlgebraicGeometry

open Grassmannian Scheme

section Curve

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable {pi : C.left ⟶ P1 k} [IsFinite pi]

noncomputable local instance instOverCleftDivRepClassifyZarAffSurj :
    C.left.Over (Spec (CommRingCat.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
  [IsDominant pi]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g : ℕ)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
variable (hchi : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
variable (r1 r2 : ℕ)
variable (b1 : Module.Basis (Fin r1) k
  ↥(divisorSections k (windowM_choice pi hpi g • fiberWeilDivisor pi) ⊤))
variable (b2 : Module.Basis (Fin r2) k
  ↥(divisorSections k
    ((windowM_choice pi hpi g + windowS_choice pi hpi g) • fiberWeilDivisor pi) ⊤))

local notation "DivOver" =>
  divSchemeOver k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm)

local notation "ChartRing" => fun i j =>
  DivCarveChartRing k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm) i j

local notation "ChartMap" => fun i j =>
  divCarveChartToDivScheme k (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm) i j

namespace DivRepChartFamilyAff

/-- Every supplied widened chart class is classified by its canonical chart map. -/
def IsChartClause
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g) : Prop :=
  ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
    IsDivRepClassifyAff hpi g r1 r2 b1 b2 (U i j) (ChartMap i j)

end DivRepChartFamilyAff

include hO hchi in
/-- The canonical classifier of a supplied chart class is the canonical chart map. -/
theorem divRepClassifyZarAff_left_eq_chartMap
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : DivRepChartFamilyAff.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U)
    (i : (glueData k g r1).J) (j : (glueData k g r2).J) :
    (divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 (ChartRing i j) (U i j)).left
      = ChartMap i j :=
  isDivRepClassifyAff_unique hpi g hO hchi r1 r2 b1 b2 (U i j)
    (divRepClassifyZarAff_isDivRepClassifyAff hpi g hO hchi r1 r2 b1 b2 (U i j))
    (hU i j)

set_option maxHeartbeats 800000 in
-- The classifier naturality rewrite unfolds both chart-ring algebra structures.
include hO hchi in
/-- A pulled chart class classifies to the corresponding restriction of the affine point. -/
theorem divRepClassifyZarAff_map_chart_eq
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : DivRepChartFamilyAff.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U)
    {S : Type u} [CommRing S] [Algebra k S] (v : overSpec k S ⟶ DivOver)
    {m : ℕ} (f : Fin m → S)
    (ci : Fin m → (glueData k g r1).J) (cj : Fin m → (glueData k g r2).J)
    (cw : ∀ t : Fin m, ChartRing (ci t) (cj t) →ₐ[k] Localization.Away (f t))
    (hcw : ∀ t : Fin m,
      Spec.map (CommRingCat.ofHom (cw t).toRingHom) ≫ ChartMap (ci t) (cj t)
        = Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away (f t)))) ≫ v.left)
    (t : Fin m) :
    divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 (Localization.Away (f t))
        (DivFamZarAff.mapAlgHom (cw t) (U (ci t) (cj t)))
      = Over.overSpecMap (IsScalarTower.toAlgHom k S (Localization.Away (f t))) ≫ v := by
  calc
    _ = Over.overSpecMap (cw t) ≫
        divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2
          (ChartRing (ci t) (cj t)) (U (ci t) (cj t)) :=
      (overSpecMap_comp_divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2
        (cw t) (U (ci t) (cj t))).symm
    _ = Over.overSpecMap (IsScalarTower.toAlgHom k S (Localization.Away (f t))) ≫ v := by
      apply Over.OverMorphism.ext
      rw [Over.comp_left, Over.comp_left, Over.overSpecMap_left, Over.overSpecMap_left,
        divRepClassifyZarAff_left_eq_chartMap hpi g hO hchi r1 r2 b1 b2 U hU]
      exact hcw t

set_option maxHeartbeats 1600000 in
include hO hchi in
/-- Pulled chart classes agree on every canonical overlap localization. -/
theorem divRepClassifyZarAff_chart_away_compat
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : DivRepChartFamilyAff.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U)
    {S : Type u} [CommRing S] [Algebra k S] (v : overSpec k S ⟶ DivOver)
    {m : ℕ} (f : Fin m → S)
    (ci : Fin m → (glueData k g r1).J) (cj : Fin m → (glueData k g r2).J)
    (cw : ∀ t : Fin m, ChartRing (ci t) (cj t) →ₐ[k] Localization.Away (f t))
    (hcw : ∀ t : Fin m,
      Spec.map (CommRingCat.ofHom (cw t).toRingHom) ≫ ChartMap (ci t) (cj t)
        = Spec.map (CommRingCat.ofHom (algebraMap S (Localization.Away (f t)))) ≫ v.left)
    (p q : Fin m) :
    DivFamZarAff.mapAlgHom (DivFamZar.awayMulLeft (k := k) f p q)
        (DivFamZarAff.mapAlgHom (cw p) (U (ci p) (cj p)))
      = DivFamZarAff.mapAlgHom (DivFamZar.awayMulRight (k := k) f p q)
        (DivFamZarAff.mapAlgHom (cw q) (U (ci q) (cj q))) := by
  apply divRepClassifyZarAff_injective (C := C) (π := pi)
    (S := Localization.Away (f p * f q)) hpi g hO hchi r1 r2 b1 b2
  have hL : (DivFamZar.awayMulLeft (k := k) f p q).comp
        (IsScalarTower.toAlgHom k S (Localization.Away (f p)))
      = IsScalarTower.toAlgHom k S (Localization.Away (f p * f q)) := by
    ext x
    exact DivFamZar.awayMulOfDvd_toAlgHom (k := k)
      (f p * f q) (f p) (f q) rfl x
  have hR : (DivFamZar.awayMulRight (k := k) f p q).comp
        (IsScalarTower.toAlgHom k S (Localization.Away (f q)))
      = IsScalarTower.toAlgHom k S (Localization.Away (f p * f q)) := by
    ext x
    exact DivFamZar.awayMulOfDvd_toAlgHom (k := k)
      (f p * f q) (f q) (f p) (mul_comm _ _) x
  calc
    _ = Over.overSpecMap (DivFamZar.awayMulLeft (k := k) f p q) ≫
        divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 (Localization.Away (f p))
          (DivFamZarAff.mapAlgHom (cw p) (U (ci p) (cj p))) :=
      (overSpecMap_comp_divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2
        (DivFamZar.awayMulLeft (k := k) f p q) _).symm
    _ = Over.overSpecMap (DivFamZar.awayMulLeft (k := k) f p q) ≫
        (Over.overSpecMap (IsScalarTower.toAlgHom k S (Localization.Away (f p))) ≫ v) :=
      congrArg (fun z => Over.overSpecMap (DivFamZar.awayMulLeft (k := k) f p q) ≫ z)
        (divRepClassifyZarAff_map_chart_eq hpi g hO hchi r1 r2 b1 b2
          U hU v f ci cj cw hcw p)
    _ = Over.overSpecMap (DivFamZar.awayMulRight (k := k) f p q) ≫
        (Over.overSpecMap (IsScalarTower.toAlgHom k S (Localization.Away (f q))) ≫ v) := by
      rw [← Category.assoc, ← Category.assoc, ← Over.overSpecMap_comp,
        ← Over.overSpecMap_comp, hL, hR]
    _ = Over.overSpecMap (DivFamZar.awayMulRight (k := k) f p q) ≫
        divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 (Localization.Away (f q))
          (DivFamZarAff.mapAlgHom (cw q) (U (ci q) (cj q))) :=
      congrArg (fun z => Over.overSpecMap (DivFamZar.awayMulRight (k := k) f p q) ≫ z)
        (divRepClassifyZarAff_map_chart_eq hpi g hO hchi r1 r2 b1 b2
          U hU v f ci cj cw hcw q).symm
    _ = _ := overSpecMap_comp_divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2
      (DivFamZar.awayMulRight (k := k) f p q) _

set_option maxHeartbeats 1600000 in
include hO hchi in
/-- The widened affine classifier is surjective once the universal chart classes exist. -/
theorem divRepClassifyZarAff_surjective_of_chartClause
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : DivRepChartFamilyAff.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U)
    (S : Type u) [CommRing S] [Algebra k S] :
    Function.Surjective
      (divRepClassifyZarAff (C := C) (pi := pi) hpi g hO hchi r1 r2 b1 b2 S) := by
  intro v
  obtain ⟨m, f, hspan, hdata⟩ := divScheme_exists_chartFactor k
    (windowS_choice pi hpi g • fiberWeilDivisor pi)
    (windowM_choice pi hpi g • fiberWeilDivisor pi) g r1 r2 b1
    (b2.map (windowShiftEquiv hpi g).symm) S v
  choose ci cj cw hcw using hdata
  let F : ∀ t : Fin m, DivFamZarAff C (Localization.Away (f t)) g := fun t =>
    DivFamZarAff.mapAlgHom (cw t) (U (ci t) (cj t))
  obtain ⟨F0, hF0⟩ := DivFamZarAff.exists_glue_of_awaySpan f hspan F
    (divRepClassifyZarAff_chart_away_compat hpi g hO hchi r1 r2 b1 b2
      U hU v f ci cj cw hcw)
  refine ⟨F0, ?_⟩
  apply Over.OverMorphism.ext
  refine Scheme.Cover.hom_ext
    (Scheme.affineOpenCoverOfSpanRangeEqTop
      (R := CommRingCat.of S) f hspan).openCover _ _ fun t => ?_
  have ht : Over.overSpecMap (IsScalarTower.toAlgHom k S (Localization.Away (f t))) ≫
        divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2 S F0
      = Over.overSpecMap (IsScalarTower.toAlgHom k S (Localization.Away (f t))) ≫ v := by
    rw [overSpecMap_comp_divRepClassifyZarAff hpi g hO hchi r1 r2 b1 b2, hF0 t]
    exact divRepClassifyZarAff_map_chart_eq hpi g hO hchi r1 r2 b1 b2
      U hU v f ci cj cw hcw t
  exact congrArg CategoryTheory.Over.Hom.left ht

include hO hchi in
/-- Universal widened chart classes satisfying their identity classification represent the
widened divisor functor by `DivScheme`. -/
noncomputable def divFunctorAff_representableBy_of_chartClause
    (U : ∀ (i : (glueData k g r1).J) (j : (glueData k g r2).J),
      DivFamZarAff C (ChartRing i j) g)
    (hU : DivRepChartFamilyAff.IsChartClause (hpi := hpi) g r1 r2 b1 b2 U) :
    (divFunctorAff C g).RepresentableBy DivOver :=
  DivRepAffinePullbackAff.representableBy hpi g hO hchi r1 r2 b1 b2
    (DivRepAffinePullbackAff.ofClassifierSurjective hpi g hO hchi r1 r2 b1 b2
      (fun S _ _ => divRepClassifyZarAff_surjective_of_chartClause
        hpi g hO hchi r1 r2 b1 b2 U hU S))

end Curve

end AlgebraicGeometry
