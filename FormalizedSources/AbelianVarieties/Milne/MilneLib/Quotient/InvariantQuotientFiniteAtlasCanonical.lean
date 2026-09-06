/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientFiniteAtlasMap
import Mathlib.AlgebraicGeometry.Morphisms.Etale

/-!
# Canonical finite-cover compatibility

The finite subcover selected from compactness is definitionally a finite
subfamily of the stable affine source cover.  After unfolding that subfamily,
the generic stable-chart overlap calculation supplies the exact pullback
compatibility required by `SourceChartMaps`.  This module consequently removes
the conditional compatibility argument from the finite-cover projection and
proves that the resulting global projection is surjective and carries the
quotient topology.  It also identifies each source chart as the exact inverse
image, and hence the pullback, of its corresponding glued quotient chart.
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

/-- The canonical projection to the glued invariant quotient atlas is
surjective on points. -/
theorem finiteStableCanonicalQuotientProjection_surjective :
    Function.Surjective
      (finiteStableCanonicalQuotientProjection act p hact h).base := by
  intro y
  obtain ⟨i, z, hz⟩ :=
    (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι_jointly_surjective y
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  obtain ⟨x, hx⟩ := stableAffineQuotientMap_surjective act p hact C z
  refine ⟨(finiteStableAffineCover act h).f i x, ?_⟩
  rw [← hz, ← hx]
  have hmap :=
    finiteStableCover_f_finiteStableCanonicalQuotientProjection act p hact h i
  exact congrArg (fun f => f x) hmap

/-- The topology on the glued invariant quotient atlas is the quotient topology
for the canonical projection. -/
theorem finiteStableCanonicalQuotientProjection_isQuotientMap :
    Topology.IsQuotientMap
      (finiteStableCanonicalQuotientProjection act p hact h).base := by
  refine ⟨Topology.IsCoinducing.of_isOpen_preimage_iff_isOpen ?_,
    finiteStableCanonicalQuotientProjection_surjective act p hact h⟩
  intro U
  constructor
  · intro hU
    rw [(finiteStableQuotientCrossChartDatum act p hact h).toGlueData.isOpen_iff]
    intro i
    let C := finiteStableAffineChart act h i
    letI := sectionsAlgebra p C.U
    letI := sectionsMulSemiringAction act C.stable
    letI := sectionsSMulCommClass act p hact C.stable
    have hq := stableAffineQuotientMap_isQuotientMap act p hact C
    apply hq.isCoinducing.isOpen_preimage.mp
    change IsOpen (((finiteStableQuotientChartMap act p hact h i ≫
      (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i).base) ⁻¹' U)
    rw [← finiteStableCover_f_finiteStableCanonicalQuotientProjection
      act p hact h i]
    exact ((finiteStableAffineCover act h).f i).continuous.isOpen_preimage _ hU
  · intro hU
    exact (finiteStableCanonicalQuotientProjection act p hact h).continuous.isOpen_preimage U hU

/-! Étaleness is local on the source.  The theorem below isolates the exact
chart-level input still needed for the free-action clause of Milne's quotient
theorem: once every affine quotient chart is étale, the glued projection is
étale as well. -/

theorem finiteStableCanonicalQuotientProjection_etale_of_chart_maps
    (hétale : ∀ i : (finiteStableAffineCover act h).I₀,
      Etale (finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i)) :
    Etale (finiteStableCanonicalQuotientProjection act p hact h) := by
  apply IsZariskiLocalAtSource.of_openCover (P := @Etale)
    (finiteStableAffineCover act h)
  intro i
  rw [finiteStableCover_f_finiteStableCanonicalQuotientProjection
    act p hact h i]
  exact hétale i

/-- On a selected source chart, the canonical projection pulls a glued target
chart back to the actual intersection of the two stable affine charts. -/
theorem finiteStableQuotientChartProjection_preimage_opensRange
    (i j : (finiteStableAffineCover act h).I₀) :
    (finiteStableQuotientChartMap act p hact h j ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j) ⁻¹ᵁ
      ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i).opensRange =
      (finiteStableAffineChart act h j).U.ι ⁻¹ᵁ
        (finiteStableAffineChart act h i).U := by
  letI := sectionsAlgebra p (finiteStableAffineChart act h j).U
  letI := sectionsMulSemiringAction act
    (finiteStableAffineChart act h j).stable
  letI := sectionsSMulCommClass act p hact
    (finiteStableAffineChart act h j).stable
  rw [Scheme.Hom.comp_preimage]
  change stableAffineQuotientMap act p hact
      (finiteStableAffineChart act h j) ⁻¹ᵁ
      ((stableQuotientGlueData act p hact
          (finiteStableAffineChart act h)).ι j ⁻¹ᵁ
        ((stableQuotientGlueData act p hact
          (finiteStableAffineChart act h)).ι i).opensRange) = _
  calc
    _ = stableAffineQuotientMap act p hact
          (finiteStableAffineChart act h j) ⁻¹ᵁ
        quotientOverlapOpen act p hact
          (finiteStableAffineChart act h j)
          (finiteStableAffineChart act h i) :=
      congrArg
        (fun U => stableAffineQuotientMap act p hact
          (finiteStableAffineChart act h j) ⁻¹ᵁ U)
        (stableQuotientGlueData_chart_preimage_opensRange act p hact
          (finiteStableAffineChart act h) i j)
    _ = (finiteStableAffineChart act h j).U.ι ⁻¹ᵁ
          ((finiteStableAffineChart act h j).U ⊓
            (finiteStableAffineChart act h i).U) :=
      stableAffineQuotientMap_preimage_quotientOverlapOpen act p hact
        (finiteStableAffineChart act h j) (finiteStableAffineChart act h i)
    _ = (finiteStableAffineChart act h j).U.ι ⁻¹ᵁ
          (finiteStableAffineChart act h i).U := by
      have htop :
          (finiteStableAffineChart act h j).U.ι ⁻¹ᵁ
              (finiteStableAffineChart act h j).U = ⊤ := by
        calc
          _ = (finiteStableAffineChart act h j).U.ι ⁻¹ᵁ
                (finiteStableAffineChart act h j).U.ι.opensRange :=
            congrArg
              (fun U => (finiteStableAffineChart act h j).U.ι ⁻¹ᵁ U)
              (Scheme.Opens.opensRange_ι
                (finiteStableAffineChart act h j).U).symm
          _ = ⊤ := Scheme.Hom.preimage_opensRange _
      rw [Scheme.Hom.preimage_inf, htop, top_inf_eq]

/-- The inverse image of a glued quotient chart under the global canonical
projection is exactly the stable affine source chart from which it was built. -/
theorem finiteStableCanonicalQuotientProjection_preimage_opensRange
    (i : (finiteStableAffineCover act h).I₀) :
    finiteStableCanonicalQuotientProjection act p hact h ⁻¹ᵁ
        ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i).opensRange =
      (finiteStableAffineChart act h i).U := by
  ext x
  obtain ⟨j, y, rfl⟩ := (finiteStableAffineCover act h).exists_eq x
  change finiteStableCanonicalQuotientProjection act p hact h
        ((finiteStableAffineCover act h).f j y) ∈
          ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i).opensRange ↔
      (finiteStableAffineCover act h).f j y ∈
        (finiteStableAffineChart act h i).U
  rw [← Scheme.Hom.comp_apply,
    finiteStableCover_f_finiteStableCanonicalQuotientProjection,
    finiteStableAffineCover_f]
  change y ∈
        (finiteStableQuotientChartMap act p hact h j ≫
          (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j) ⁻¹ᵁ
            ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i).opensRange ↔
      y ∈ (finiteStableAffineChart act h j).U.ι ⁻¹ᵁ
        (finiteStableAffineChart act h i).U
  rw [finiteStableQuotientChartProjection_preimage_opensRange]
  rfl

set_option backward.isDefEq.respectTransparency false in
/-- Each stable source chart is the pullback of its glued quotient chart along
the global canonical projection. -/
theorem finiteStableQuotientChart_isPullback
    (i : (finiteStableAffineCover act h).I₀) :
    IsPullback
      (finiteStableQuotientChartMap act p hact h i)
      ((finiteStableAffineCover act h).f i)
      ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i)
      (finiteStableCanonicalQuotientProjection act p hact h) := by
  let D := finiteStableQuotientGlueData act p hact h
  change IsPullback
    (finiteStableQuotientChartMap act p hact h i)
    ((finiteStableAffineCover act h).f i) (D.ι i)
    (finiteStableCanonicalQuotientProjection act p hact h)
  letI := Scheme.GlueData.ι_isOpenImmersion D i
  apply IsOpenImmersion.isPullback
  · exact finiteStableCover_f_finiteStableCanonicalQuotientProjection
      act p hact h i
  · rw [finiteStableCanonicalQuotientProjection_preimage_opensRange]
    simp only [finiteStableAffineCover_f, Scheme.Opens.opensRange_ι]

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
