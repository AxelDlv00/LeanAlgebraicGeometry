/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientFiniteAtlasMap

/-!
# Canonical finite-cover compatibility

The finite subcover selected from compactness is definitionally a finite
subfamily of the stable affine source cover.  After unfolding that subfamily,
the generic stable-chart overlap calculation supplies the exact pullback
compatibility required by `SourceChartMaps`.  This module consequently removes
the conditional compatibility argument from the finite-cover projection.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] [Finite G]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated] [CompactSpace X]

section FiniteCover

variable (p : X ⟶ Spec (CommRingCat.of k))
variable (hact : ∀ g : G, (act g).hom ≫ p = p)
variable (h : OrbitsInAffineOpen act)

/-- The canonical local quotient projections satisfy the finite-cover overlap
equation. -/
theorem finiteStableProjection_compat
    (i j : (finiteStableAffineCover act h).I₀) :
    let D := finiteStableQuotientCrossChartDatum act p hact h
    pullback.fst ((finiteStableAffineCover act h).f i)
        ((finiteStableAffineCover act h).f j) ≫
      (finiteStableQuotientChartMap act p hact h i ≫ D.toGlueData.ι i) =
    pullback.snd ((finiteStableAffineCover act h).f i)
        ((finiteStableAffineCover act h).f j) ≫
      (finiteStableQuotientChartMap act p hact h j ≫ D.toGlueData.ι j) := by
  dsimp
  let Ci := finiteStableAffineChart act h i
  let Cj := finiteStableAffineChart act h j
  letI := sectionsAlgebra p Ci.U
  letI := sectionsAlgebra p Cj.U
  letI := sectionsAlgebra p (Ci.U ⊓ Cj.U)
  letI := sectionsMulSemiringAction act Ci.stable
  letI := sectionsMulSemiringAction act Cj.stable
  letI := sectionsMulSemiringAction act (overlap_stable act Ci Cj)
  letI := sectionsSMulCommClass act p hact Ci.stable
  letI := sectionsSMulCommClass act p hact Cj.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act Ci Cj)
  dsimp [finiteStableAffineCover, finiteStableAffineChart,
    finiteStableQuotientChartMap]
  change pullback.fst Ci.U.ι Cj.U.ι ≫
      (stableAffineQuotientMap act p hact Ci ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) =
    pullback.snd Ci.U.ι Cj.U.ι ≫
      (stableAffineQuotientMap act p hact Cj ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j)
  rw [← cancel_epi (isPullback_opens_inf Ci.U Cj.U).isoPullback.hom]
  simp only [IsPullback.isoPullback_hom_fst_assoc,
    IsPullback.isoPullback_hom_snd_assoc]
  have hglue :=
    (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.glue_condition i j
  dsimp [finiteStableQuotientCrossChartDatum,
    stableQuotientCrossChartDatum] at hglue
  have hglue' :
      (quotientOverlapSwapIso act p hact Ci Cj).hom ≫
          quotientOverlapι act p hact Cj Ci ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j =
        quotientOverlapι act p hact Ci Cj ≫
          (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i := by
    dsimp [finiteStableQuotientCrossChartDatum,
      stableQuotientCrossChartDatum]
    simpa only [Category.assoc] using hglue
  have hswap :
      (Scheme.isoOfEq X (inf_comm Ci.U Cj.U)).hom ≫
          X.homOfLE (show Cj.U ⊓ Ci.U ≤ Cj.U from inf_le_left) =
        X.homOfLE (show Ci.U ⊓ Cj.U ≤ Cj.U from inf_le_right) := by
    rw [← cancel_mono Cj.U.ι]
    simp
  calc
    X.homOfLE inf_le_left ≫
        (stableAffineQuotientMap act p hact Ci ≫
          (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) =
      (X.homOfLE inf_le_left ≫ stableAffineQuotientMap act p hact Ci) ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i :=
      (Category.assoc _ _ _).symm
    _ = (overlapQuotientMap act p hact Ci Cj ≫
          quotientOverlapι act p hact Ci Cj) ≫
          (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i := by
      rw [stableAffineQuotientMap_restrict]
    _ = overlapQuotientMap act p hact Ci Cj ≫
          (quotientOverlapι act p hact Ci Cj ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) :=
      Category.assoc _ _ _
    _ = overlapQuotientMap act p hact Ci Cj ≫
          ((quotientOverlapSwapIso act p hact Ci Cj).hom ≫
            quotientOverlapι act p hact Cj Ci ≫
              (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j) := by
      rw [hglue'.symm]
    _ = (overlapQuotientMap act p hact Ci Cj ≫
          (quotientOverlapSwapIso act p hact Ci Cj).hom) ≫
            quotientOverlapι act p hact Cj Ci ≫
              (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j := by
      simp only [Category.assoc]
    _ = ((Scheme.isoOfEq X (inf_comm Ci.U Cj.U)).hom ≫
          overlapQuotientMap act p hact Cj Ci) ≫
            quotientOverlapι act p hact Cj Ci ≫
              (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j := by
      rw [overlapQuotientMap_comp_swap]
    _ = ((Scheme.isoOfEq X (inf_comm Ci.U Cj.U)).hom ≫
          (overlapQuotientMap act p hact Cj Ci ≫
            quotientOverlapι act p hact Cj Ci)) ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j := by
      simp only [Category.assoc]
    _ = ((Scheme.isoOfEq X (inf_comm Ci.U Cj.U)).hom ≫
          (X.homOfLE inf_le_left ≫
            stableAffineQuotientMap act p hact Cj)) ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j := by
      rw [← stableAffineQuotientMap_restrict]
    _ = (X.homOfLE inf_le_right ≫
          stableAffineQuotientMap act p hact Cj) ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j := by
      rw [← Category.assoc, hswap]
    _ = X.homOfLE inf_le_right ≫
        (stableAffineQuotientMap act p hact Cj ≫
          (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j) :=
      Category.assoc _ _ _

/-- The canonical source-chart package for the compact finite stable cover. -/
noncomputable def finiteStableCanonicalSourceChartMaps :
    InvariantLocalization.SourceChartMaps
      (finiteStableAffineCover act h)
      (finiteStableQuotientCrossChartDatum act p hact h) :=
  finiteStableSourceChartMaps act p hact h (fun i j =>
    finiteStableProjection_compat act p hact h i j)

/-- The global quotient-atlas candidate obtained from the canonical finite
stable-cover projections. -/
noncomputable def finiteStableCanonicalQuotientProjection :
    X ⟶ (finiteStableQuotientGlueData act p hact h).glued :=
  finiteStableQuotientProjection act p hact h (fun i j =>
    finiteStableProjection_compat act p hact h i j)

@[reassoc (attr := simp)]
theorem finiteStableCover_f_finiteStableCanonicalQuotientProjection
    (i : (finiteStableAffineCover act h).I₀) :
    (finiteStableAffineCover act h).f i ≫
        finiteStableCanonicalQuotientProjection act p hact h =
      finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i := by
  exact finiteStableCover_f_finiteStableQuotientProjection act p hact h
    (fun i j => finiteStableProjection_compat act p hact h i j) i

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
