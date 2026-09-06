/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientCrossChartMap

/-!
# Gluing local quotient projections from a source cover

The quotient-chart atlas carries its own gluing datum, while a source scheme is
usually presented by an open cover.  This module glues compatible local maps
from that source cover into the atlas and records the resulting map over an
affine base.  All chart, overlap, and compatibility data remain explicit; the
construction therefore supplies a genuine global consumer without asserting
the missing non-affine quotient-existence theorem.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace InvariantLocalization

variable {X : Scheme.{u}} (𝒰 : X.OpenCover)
variable [Finite 𝒰.I₀]
variable (D : InvariantQuotientCrossChartDatum (J := 𝒰.I₀))

/-! ## Source-cover maps into the quotient atlas -/

/-- Local maps from a source open into the corresponding quotient chart, with
the equality required on every source pullback overlap. -/
structure SourceChartMaps where
  chartMap : ∀ i : 𝒰.I₀, 𝒰.X i ⟶ D.U i
  compatibility : ∀ i j,
    pullback.fst (𝒰.f i) (𝒰.f j) ≫
        (chartMap i ≫ D.toGlueData.ι i) =
      pullback.snd (𝒰.f i) (𝒰.f j) ≫
        (chartMap j ≫ D.toGlueData.ι j)

namespace SourceChartMaps

/-- Glue the compatible local quotient-chart maps along the source cover. -/
noncomputable def globalMap (M : SourceChartMaps 𝒰 D) :
    X ⟶ D.toGlueData.glued :=
  𝒰.glueMorphisms
    (fun i => M.chartMap i ≫ D.toGlueData.ι i)
    M.compatibility

@[reassoc (attr := simp)]
theorem f_globalMap (M : SourceChartMaps 𝒰 D) (i : 𝒰.I₀) :
    𝒰.f i ≫ M.globalMap 𝒰 D =
      M.chartMap i ≫ D.toGlueData.ι i := by
  exact Scheme.Cover.ι_glueMorphisms 𝒰
    (fun j => M.chartMap j ≫ D.toGlueData.ι j)
    M.compatibility i

/-- The global map is uniquely determined by its restrictions to the source
cover. -/
theorem globalMap_unique (M : SourceChartMaps 𝒰 D)
    (g : X ⟶ D.toGlueData.glued)
    (hg : ∀ i, 𝒰.f i ≫ g = M.chartMap i ≫ D.toGlueData.ι i) :
    g = M.globalMap 𝒰 D := by
  apply Scheme.Cover.hom_ext 𝒰 g (M.globalMap 𝒰 D)
  intro i
  rw [hg, f_globalMap]

end SourceChartMaps

/-! ## The over-base consumer -/

variable {k : Type u} [CommRing k]

namespace BaseCompatibleChartMaps

/-- A base-compatible source-cover family for a selected quotient base datum. -/
structure For (B : InvariantQuotientCrossChartDatum.BaseMapData D (k := k)) where
  chartMap : ∀ i : 𝒰.I₀, 𝒰.X i ⟶ D.U i
  compatibility : ∀ i j,
    pullback.fst (𝒰.f i) (𝒰.f j) ≫
        (chartMap i ≫ D.toGlueData.ι i) =
      pullback.snd (𝒰.f i) (𝒰.f j) ≫
        (chartMap j ≫ D.toGlueData.ι j)
  sourceBase : X ⟶ Spec (CommRingCat.of k)
  baseCompatibility : ∀ i,
    (chartMap i ≫ D.toGlueData.ι i) ≫ B.map D =
      𝒰.f i ≫ sourceBase

def For.toSource
    (B : InvariantQuotientCrossChartDatum.BaseMapData D (k := k))
    (M : For 𝒰 D B) :
    SourceChartMaps 𝒰 D where
  chartMap := M.chartMap
  compatibility := M.compatibility

/-- The global quotient projection obtained by gluing the local projections. -/
noncomputable def globalMap
    (B : InvariantQuotientCrossChartDatum.BaseMapData D (k := k))
    (M : For 𝒰 D B) :
    X ⟶ D.toGlueData.glued :=
  SourceChartMaps.globalMap 𝒰 D (For.toSource 𝒰 D B M)

@[reassoc (attr := simp)]
theorem f_globalMap
    (B : InvariantQuotientCrossChartDatum.BaseMapData D (k := k))
    (M : For 𝒰 D B) (i : 𝒰.I₀) :
    𝒰.f i ≫ globalMap 𝒰 D B M =
      M.chartMap i ≫ D.toGlueData.ι i := by
  exact SourceChartMaps.f_globalMap 𝒰 D (For.toSource 𝒰 D B M) i

/-! The central load-bearing statement: the glued map is over the selected
affine base, proved by source-cover extensionality. -/
@[reassoc]
theorem globalMap_comp_base
    (B : InvariantQuotientCrossChartDatum.BaseMapData D (k := k))
    (M : For 𝒰 D B) :
    globalMap 𝒰 D B M ≫ B.map D = M.sourceBase := by
  apply Scheme.Cover.hom_ext 𝒰
    (globalMap 𝒰 D B M ≫ B.map D) M.sourceBase
  intro i
  calc
    𝒰.f i ≫ (globalMap 𝒰 D B M ≫ B.map D) =
        (𝒰.f i ≫ globalMap 𝒰 D B M) ≫ B.map D :=
      (Category.assoc _ _ _).symm
    _ = (M.chartMap i ≫ D.toGlueData.ι i) ≫ B.map D := by
      rw [f_globalMap 𝒰 D B M i]
    _ = 𝒰.f i ≫ M.sourceBase := M.baseCompatibility i

end BaseCompatibleChartMaps

end InvariantLocalization
end MilneLib
