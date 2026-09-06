/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientFiniteAtlasCanonical
import MilneLib.InvariantQuotientStableBaseMap

/-!
# The finite quotient atlas over its affine base

The canonical finite-cover chart projections and the canonical affine-base
datum assemble into the existing over-base chart-map consumer.  This produces
the glued atlas projection together with its base square, while leaving the
global invariant-sheaf and quotient-universality assertions conditional.
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

/-- The canonical finite-cover source maps, now equipped with their affine
base compatibility. -/
noncomputable def finiteStableCanonicalBaseCompatibleChartMaps :
    InvariantLocalization.BaseCompatibleChartMaps.For
      (finiteStableAffineCover act h)
      (finiteStableQuotientCrossChartDatum act p hact h)
      (finiteStableQuotientBaseMapData act p hact h) := by
  refine
    { chartMap := finiteStableQuotientChartMap act p hact h
      compatibility := fun i j => finiteStableProjection_compat act p hact h i j
      sourceBase := p
      baseCompatibility := ?_ }
  intro i
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  have hJ : (finiteStableAffineCover act h).I₀ =
      (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.J := rfl
  have hι :=
    InvariantLocalization.InvariantQuotientCrossChartDatum.BaseMapData.ι_map
      (finiteStableQuotientCrossChartDatum act p hact h)
      (finiteStableQuotientBaseMapData act p hact h) (hJ ▸ i)
  have hι' :
      (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i ≫
          (finiteStableQuotientBaseMapData act p hact h).map
            (finiteStableQuotientCrossChartDatum act p hact h) =
        (finiteStableQuotientBaseMapData act p hact h).chartMap i := by
    simpa using hι
  calc
    (finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i) ≫
        (finiteStableQuotientBaseMapData act p hact h).map
          (finiteStableQuotientCrossChartDatum act p hact h) =
      finiteStableQuotientChartMap act p hact h i ≫
        ((finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i ≫
          (finiteStableQuotientBaseMapData act p hact h).map
            (finiteStableQuotientCrossChartDatum act p hact h)) :=
      Category.assoc _ _ _
    _ = finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientBaseMapData act p hact h).chartMap i :=
      congrArg (fun z => finiteStableQuotientChartMap act p hact h i ≫ z) hι'
    _ = (finiteStableAffineCover act h).f i ≫ p := by
      dsimp [finiteStableQuotientChartMap, finiteStableAffineCover,
        finiteStableAffineChart]
      change stableAffineQuotientMap act p hact C ≫
          affineInvariantQuotientBaseMap
            (k := k) (A := Γ(X, C.U)) (G := G) = C.U.ι ≫ p
      exact stableAffineQuotientMap_comp_base act p hact C

/-- The global projection obtained from the canonical finite atlas, viewed over
the selected affine base. -/
noncomputable def finiteStableCanonicalQuotientProjectionOver :
    X ⟶ (finiteStableQuotientGlueData act p hact h).glued :=
  InvariantLocalization.BaseCompatibleChartMaps.globalMap
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableQuotientBaseMapData act p hact h)
    (finiteStableCanonicalBaseCompatibleChartMaps act p hact h)

@[reassoc (attr := simp)]
theorem finiteStableCanonicalQuotientProjectionOver_comp_base :
    finiteStableCanonicalQuotientProjectionOver act p hact h ≫
        (finiteStableQuotientBaseMapData act p hact h).map
          (finiteStableQuotientCrossChartDatum act p hact h) = p := by
  exact InvariantLocalization.BaseCompatibleChartMaps.globalMap_comp_base
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableQuotientBaseMapData act p hact h)
    (finiteStableCanonicalBaseCompatibleChartMaps act p hact h)

@[reassoc (attr := simp)]
theorem finiteStableAffineCover_f_finiteStableCanonicalQuotientProjectionOver
    (i : (finiteStableAffineCover act h).I₀) :
    (finiteStableAffineCover act h).f i ≫
        finiteStableCanonicalQuotientProjectionOver act p hact h =
      finiteStableQuotientChartMap act p hact h i ≫
        (finiteStableQuotientCrossChartDatum act p hact h).toGlueData.ι i := by
  exact InvariantLocalization.BaseCompatibleChartMaps.f_globalMap
    (finiteStableAffineCover act h)
    (finiteStableQuotientCrossChartDatum act p hact h)
    (finiteStableQuotientBaseMapData act p hact h)
    (finiteStableCanonicalBaseCompatibleChartMaps act p hact h) i

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
