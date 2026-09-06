/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientCrossChart
import MilneLib.InvariantQuotientGlueRestriction
import MilneLib.InvariantQuotientStableAtlas

/-!
# Gluing data for a finite stable-affine quotient atlas

The invariant quotients of a finite family of stable affine charts carry the
canonical overlap reversals and triple transitions required by
`Scheme.GlueData`.  This module assembles those producers into the existing
cross-chart interface and specializes the construction to the finite stable
cover selected from a compact source.

The glued scheme constructed here is an atlas candidate.  Identifying it as a
categorical or geometric quotient still requires a global quotient map and its
universal and orbit-fibre properties.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G J : Type u} [CommRing k] [Group G] [Finite G] [Finite J]
  {X : Scheme.{u}} (act : G →* Aut X) [X.IsSeparated]

/-- The quotient charts of a finite stable-affine family, equipped with their
canonical overlap reversals and triple transition cocycle. -/
noncomputable def stableQuotientCrossChartDatum
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (C : J → StableAffineOpen act) :
    InvariantLocalization.InvariantQuotientCrossChartDatum (J := J) := by
  letI (i : J) : Algebra k Γ(X, (C i).U) := sectionsAlgebra p (C i).U
  letI (i : J) : MulSemiringAction G Γ(X, (C i).U) :=
    sectionsMulSemiringAction act (C i).stable
  letI (i : J) : SMulCommClass G k Γ(X, (C i).U) :=
    sectionsSMulCommClass act p hact (C i).stable
  exact
    { U := fun i => Spec (CommRingCat.of
        (FixedPoints.subalgebra k Γ(X, (C i).U) G))
      V := fun i j => quotientOverlap act p hact (C i) (C j)
      f := fun i j => quotientOverlapι act p hact (C i) (C j)
      f_id := fun i => quotientOverlapι_self_isIso act p hact (C i)
      f_open := fun i j =>
        quotientOverlapι_isOpenImmersion act p hact (C i) (C j)
      t := fun i j => quotientOverlapSwapIso act p hact (C i) (C j)
      t_id := fun i => quotientOverlapSwapIso_self act p hact (C i)
      t' := fun i j l =>
        quotientTripleTransition act p hact (C i) (C j) (C l)
      t_fac := fun i j l =>
        quotientTripleTransition_t_fac act p hact (C i) (C j) (C l)
      cocycle := fun i j l =>
        quotientTripleTransition_cocycle act p hact (C i) (C j) (C l) }

/-- The `Scheme.GlueData` assembled from a finite family of stable affine
quotient charts. -/
noncomputable abbrev stableQuotientGlueData
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (C : J → StableAffineOpen act) : Scheme.GlueData :=
  (stableQuotientCrossChartDatum act p hact C).toGlueData

section FiniteCover

variable [CompactSpace X]

/-- The cross-chart quotient datum on the finite stable-affine cover selected
from the orbit-in-affine hypothesis. -/
noncomputable def finiteStableQuotientCrossChartDatum
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (h : OrbitsInAffineOpen act) :
    InvariantLocalization.InvariantQuotientCrossChartDatum
      (J := (finiteStableAffineCover act h).I₀) :=
  stableQuotientCrossChartDatum act p hact
    (finiteStableAffineChart act h)

/-- The gluing datum for the invariant quotients of the selected finite stable
affine cover. -/
noncomputable abbrev finiteStableQuotientGlueData
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (h : OrbitsInAffineOpen act) : Scheme.GlueData :=
  (finiteStableQuotientCrossChartDatum act p hact h).toGlueData

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
