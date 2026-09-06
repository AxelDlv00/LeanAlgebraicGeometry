/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.QuotientGlueData
import Mathlib.AlgebraicGeometry.Cover.Open

/-!
# Stable-affine quotient atlas prerequisites

The diagonal overlap of a stable affine chart is the whole invariant quotient
chart.  We also expose the finite subcover selected by compactness, while
keeping the orbit-in-affine hypothesis explicit.  These are the diagonal and
finite-index inputs for a later cross-chart `Scheme.GlueData` construction.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-! ## Diagonal overlap -/

theorem quotientOverlapOpen_self_eq_top [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientOverlapOpen act p hact i i = ⊤ := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  have hcoord : overlapCoordinateOpen act i i = ⊤ := by
    unfold overlapCoordinateOpen
    simp
  simpa only [quotientOverlapOpen, hcoord] using
    (InvariantLocalization.quotientOpenOfStable_top
      (k := k) (A := Γ(X, i.U)) (G := G))

/-! ## Compact finite subcover -/

noncomputable def finiteStableAffineCover [Finite G] [CompactSpace X]
    (h : OrbitsInAffineOpen act) : Scheme.OpenCover X :=
  (sourceOpenCover act h).finiteSubcover

/-- The stable affine chart selected at an index of the compact finite
subcover.  This retains the affineness and stability data that the underlying
`Scheme.OpenCover` forgets. -/
noncomputable def finiteStableAffineChart [Finite G] [CompactSpace X]
    (h : OrbitsInAffineOpen act)
    (i : (finiteStableAffineCover act h).I₀) : StableAffineOpen act :=
  Scheme.Cover.idx (sourceOpenCover act h) (i.1 : X)

noncomputable instance finiteStableAffineCover_fintype [Finite G] [CompactSpace X]
    (h : OrbitsInAffineOpen act) :
    Fintype (finiteStableAffineCover act h).I₀ := by
  dsimp [finiteStableAffineCover]
  infer_instance

@[simp]
theorem finiteStableAffineCover_X [Finite G] [CompactSpace X]
    (h : OrbitsInAffineOpen act) (i : (finiteStableAffineCover act h).I₀) :
    (finiteStableAffineCover act h).X i =
      (finiteStableAffineChart act h i).U.toScheme := by
  change ((sourceOpenCover act h).finiteSubcover).X i =
    (Scheme.Cover.idx (sourceOpenCover act h) (i.1 : X)).U.toScheme
  rw [Scheme.OpenCover.finiteSubcover_X]
  rfl

@[simp]
theorem finiteStableAffineCover_f [Finite G] [CompactSpace X]
    (h : OrbitsInAffineOpen act) (i : (finiteStableAffineCover act h).I₀) :
    (finiteStableAffineCover act h).f i =
      (finiteStableAffineChart act h i).U.ι := by
  change ((sourceOpenCover act h).finiteSubcover).f i =
    (Scheme.Cover.idx (sourceOpenCover act h) (i.1 : X)).U.ι
  rw [Scheme.OpenCover.finiteSubcover_f]
  rfl

end StableAffineOpen
end StableGroupAction
end MilneLib
