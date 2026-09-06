/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientCrossChart

/-!
# Maps out of a supplied invariant-quotient atlas

`InvariantQuotientCrossChartDatum` records the overlap schemes and their
cocycle, but a global quotient map still has to be constructed from compatible
chart maps.  This file performs that construction with the actual
multicoequalizer defining the glued scheme.  The result is deliberately
conditional on the supplied chart maps and overlap equations: it is a consumer
of an atlas, not an existence theorem for the non-affine quotient.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace InvariantLocalization

namespace InvariantQuotientCrossChartDatum

variable {J : Type u} [Finite J]
variable (D : InvariantQuotientCrossChartDatum (J := J))

/-! ## The multicoequalizer map -/

/-- A family of morphisms from the quotient charts which agrees on every
supplied overlap.  The equation is stated with the transition isomorphism,
matching the orientation of `Scheme.GlueData.glue_condition`. -/
structure CompatibleChartMaps (Y : Scheme.{u}) where
  chartMap : ∀ i : J, D.U i ⟶ Y
  compatibility : ∀ i j,
    D.f i j ≫ chartMap i =
      ((D.t i j).hom ≫ D.f j i) ≫ chartMap j

namespace CompatibleChartMaps

variable {Y : Scheme.{u}}

/-- The morphism obtained by descending compatible chart maps through the
multicoequalizer which defines `D.toGlueData.glued`. -/
noncomputable def map (M : D.CompatibleChartMaps Y) :
    D.toGlueData.glued ⟶ Y := by
  let h : ∀ a : (J × J),
      D.toGlueData.diagram.fst a ≫ M.chartMap a.1 =
        D.toGlueData.diagram.snd a ≫ M.chartMap a.2 := by
    rintro ⟨i, j⟩
    change D.f i j ≫ M.chartMap i =
      ((D.t i j).hom ≫ D.f j i) ≫ M.chartMap j
    exact M.compatibility i j
  exact Multicoequalizer.desc D.toGlueData.diagram Y M.chartMap h

@[reassoc (attr := simp)]
theorem ι_map (M : D.CompatibleChartMaps Y) (i : J) :
    D.toGlueData.ι i ≫ M.map = M.chartMap i := by
  let h : ∀ a : (J × J),
      D.toGlueData.diagram.fst a ≫ M.chartMap a.1 =
        D.toGlueData.diagram.snd a ≫ M.chartMap a.2 := by
    rintro ⟨j, k⟩
    change D.f j k ≫ M.chartMap j =
      ((D.t j k).hom ≫ D.f k j) ≫ M.chartMap k
    exact M.compatibility j k
  exact Multicoequalizer.π_desc D.toGlueData.diagram Y M.chartMap h i

/-- Compatible chart maps determine at most one morphism out of the glued
scheme.  This is the extensionality statement used by later quotient
presentations when comparing two global structure maps. -/
theorem map_unique (M : D.CompatibleChartMaps Y)
    (g : D.toGlueData.glued ⟶ Y)
    (hg : ∀ i, D.toGlueData.ι i ≫ g = M.chartMap i) :
    g = M.map := by
  apply D.toGlueData.openCover.hom_ext
  intro i
  change D.toGlueData.ι i ≫ g = D.toGlueData.ι i ≫ M.map
  rw [hg, CompatibleChartMaps.ι_map D M]

end CompatibleChartMaps

/-! ## Structure maps over an affine base -/

variable {k : Type u} [CommRing k]

/-- Compatible maps from the quotient charts to `Spec k`.  Keeping this as a
named datum makes the base map a reusable input for finite-quotient consumers. -/
structure BaseMapData where
  chartMap : ∀ i : J, D.U i ⟶ Spec (CommRingCat.of k)
  compatibility : ∀ i j,
    D.f i j ≫ chartMap i =
      ((D.t i j).hom ≫ D.f j i) ≫ chartMap j

namespace BaseMapData

/-- View a base-map family as the generic compatible-chart package. -/
def toCompatible (M : D.BaseMapData (k := k)) :
    D.CompatibleChartMaps (Spec (CommRingCat.of k)) where
  chartMap := M.chartMap
  compatibility := M.compatibility

/-- The global structure morphism on the glued quotient atlas. -/
noncomputable def map (M : D.BaseMapData (k := k)) :
    D.toGlueData.glued ⟶ Spec (CommRingCat.of k) :=
  (M.toCompatible D).map

@[reassoc (attr := simp)]
theorem ι_map (M : D.BaseMapData (k := k)) (i : J) :
    D.toGlueData.ι i ≫ M.map D = M.chartMap i := by
  exact CompatibleChartMaps.ι_map D (M.toCompatible D) i

/-- The glued quotient atlas as an object over `Spec k`. -/
noncomputable def over (M : D.BaseMapData (k := k)) :
    Over (Spec (CommRingCat.of k)) :=
  Over.mk (M.map D)

@[simp]
theorem over_hom (M : D.BaseMapData (k := k)) :
    (M.over D).hom = M.map D :=
  rfl

theorem map_unique (M : D.BaseMapData (k := k))
    (g : D.toGlueData.glued ⟶ Spec (CommRingCat.of k))
    (hg : ∀ i, D.toGlueData.ι i ≫ g = M.chartMap i) :
    g = M.map D := by
  exact CompatibleChartMaps.map_unique D (M.toCompatible D) g hg

end BaseMapData

end InvariantQuotientCrossChartDatum

end InvariantLocalization
end MilneLib
