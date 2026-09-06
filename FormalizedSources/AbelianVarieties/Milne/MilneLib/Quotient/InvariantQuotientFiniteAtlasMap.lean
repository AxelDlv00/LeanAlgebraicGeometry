/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientStableAtlasMap

/-!
# The finite stable-cover quotient projection

The compact finite subcover supplies the source cover used by the generic
`SourceChartMaps` consumer.  Its chart-overlap compatibility is kept as an
explicit argument: transporting the propositionally identified finite-subcover
opens through dependent pullbacks is a separate interface boundary.  Thus this
module constructs the global glued map without claiming that compatibility (or
the non-affine quotient theorem) for free.
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

/-- The canonical local quotient projection on one chart of the compact finite
stable-affine cover. -/
noncomputable def finiteStableQuotientChartMap
    (i : (finiteStableAffineCover act h).I₀) :
      (finiteStableAffineCover act h).X i ⟶
        (finiteStableQuotientCrossChartDatum act p hact h).U i := by
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  dsimp [finiteStableAffineCover, finiteStableAffineChart]
  change C.U.toScheme ⟶
    (finiteStableQuotientCrossChartDatum act p hact h).U i
  exact stableAffineQuotientMap act p hact C

/-- A finite-cover source-map package, conditional on the displayed overlap
equation.  The equation is exactly the one consumed by `SourceChartMaps`. -/
noncomputable def finiteStableSourceChartMaps
    (hcompat : ∀ i j,
      pullback.fst ((finiteStableAffineCover act h).f i)
          ((finiteStableAffineCover act h).f j) ≫
          (finiteStableQuotientChartMap act p hact h i ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) =
        pullback.snd ((finiteStableAffineCover act h).f i)
            ((finiteStableAffineCover act h).f j) ≫
          (finiteStableQuotientChartMap act p hact h j ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j)) :
    InvariantLocalization.SourceChartMaps
      (finiteStableAffineCover act h)
      (finiteStableQuotientCrossChartDatum act p hact h) where
  chartMap := finiteStableQuotientChartMap act p hact h
  compatibility := hcompat

/-- The global map obtained by gluing the conditional finite-cover chart maps.
No quotient universal property is asserted here. -/
noncomputable def finiteStableQuotientProjection
    (hcompat : ∀ i j,
      pullback.fst ((finiteStableAffineCover act h).f i)
          ((finiteStableAffineCover act h).f j) ≫
          (finiteStableQuotientChartMap act p hact h i ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) =
        pullback.snd ((finiteStableAffineCover act h).f i)
            ((finiteStableAffineCover act h).f j) ≫
          (finiteStableQuotientChartMap act p hact h j ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j)) :
    X ⟶ (finiteStableQuotientGlueData act p hact h).glued :=
  InvariantLocalization.SourceChartMaps.globalMap
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableSourceChartMaps act p hact h hcompat)

@[reassoc (attr := simp)]
theorem finiteStableCover_f_finiteStableQuotientProjection
    (hcompat : ∀ i j,
      pullback.fst ((finiteStableAffineCover act h).f i)
          ((finiteStableAffineCover act h).f j) ≫
          (finiteStableQuotientChartMap act p hact h i ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) =
        pullback.snd ((finiteStableAffineCover act h).f i)
            ((finiteStableAffineCover act h).f j) ≫
          (finiteStableQuotientChartMap act p hact h j ≫
            (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι j))
    (i : (finiteStableAffineCover act h).I₀) :
    (finiteStableAffineCover act h).f i ≫
        finiteStableQuotientProjection act p hact h hcompat =
      finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i := by
  exact InvariantLocalization.SourceChartMaps.f_globalMap
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableSourceChartMaps act p hact h hcompat) i

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
