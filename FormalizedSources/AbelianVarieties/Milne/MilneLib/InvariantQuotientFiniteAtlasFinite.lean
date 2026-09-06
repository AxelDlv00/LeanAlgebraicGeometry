/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientFiniteAtlasCanonical
import Mathlib.AlgebraicGeometry.Morphisms.FiniteType

/-!
# Finiteness of the finite stable-cover quotient projection

If the structure morphism of the source is locally of finite type, the ring of
sections on each stable affine chart is a finite-type algebra over the base.
The finite-group invariant-ring theorem therefore makes every quotient chart
projection finite.  Finiteness is local on the target, so the pullback squares
for the canonical glued projection promote these chartwise results to the
global projection.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction

variable {k : Type u} [CommRing k] {X : Scheme.{u}}

/-- Sections on an affine open are finite type over the base when the ambient
structure morphism is locally of finite type. -/
theorem sectionsAlgebra_finiteType_of_locallyOfFiniteType
    (p : X ⟶ Spec (CommRingCat.of k)) [LocallyOfFiniteType p]
    (U : X.Opens) (hU : IsAffineOpen U) :
    letI := sectionsAlgebra p U
    Algebra.FiniteType k Γ(X, U) := by
  letI := sectionsAlgebra p U
  have hbase :
      ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom).FiniteType := by
    apply RingHom.FiniteType.of_surjective
    intro x
    exact ⟨(Scheme.ΓSpecIso (CommRingCat.of k)).hom.hom x, by simp⟩
  have hsections :
      (sectionsAlgebraMapHom p U).hom.FiniteType :=
    (p.finiteType_appLE (isAffineOpen_top _) hU le_top).comp hbase
  rw [← RingHom.finiteType_algebraMap]
  change (sectionsAlgebraMapHom p U).hom.FiniteType
  exact hsections

namespace StableAffineOpen

variable {G : Type u} [Group G] [Finite G]
  (act : G →* Aut X) [X.IsSeparated] [CompactSpace X]

section FiniteCover

variable (p : X ⟶ Spec (CommRingCat.of k))
variable (hact : ∀ g : G, (act g).hom ≫ p = p)
variable (h : OrbitsInAffineOpen act)

/-- Each canonical quotient map in the finite stable affine atlas is finite
when the source is locally of finite type over the affine base. -/
theorem finiteStableQuotientChartMap_isFinite [LocallyOfFiniteType p]
    (i : (finiteStableAffineCover act h).I₀) :
    IsFinite (finiteStableQuotientChartMap act p hact h i) := by
  let C := finiteStableAffineChart act h i
  letI := sectionsAlgebra p C.U
  letI : Algebra.FiniteType k Γ(X, C.U) :=
    sectionsAlgebra_finiteType_of_locallyOfFiniteType p C.U C.affine
  letI := sectionsMulSemiringAction act C.stable
  letI := sectionsSMulCommClass act p hact C.stable
  change IsFinite (C.affine.isoSpec.hom ≫
    affineInvariantQuotientMap (k := k) (A := Γ(X, C.U)) (G := G))
  exact MorphismProperty.comp_mem @IsFinite C.affine.isoSpec.hom
    (affineInvariantQuotientMap (k := k) (A := Γ(X, C.U)) (G := G))
    (by infer_instance) affineInvariantQuotientMap_isFinite

set_option backward.isDefEq.respectTransparency false in
/-- The canonical projection to the quotient glued from a finite stable affine
atlas is finite when the source is locally of finite type over the base. -/
theorem finiteStableCanonicalQuotientProjection_isFinite
    [LocallyOfFiniteType p] :
    IsFinite (finiteStableCanonicalQuotientProjection act p hact h) := by
  let D := finiteStableQuotientGlueData act p hact h
  apply IsZariskiLocalAtTarget.of_openCover (P := @IsFinite) D.openCover
  intro i
  change D.J at i
  change IsFinite
    (pullback.snd (finiteStableCanonicalQuotientProjection act p hact h) (D.ι i))
  rw [← (finiteStableQuotientChart_isPullback act p hact h i).flip.isoPullback_inv_snd,
    MorphismProperty.cancel_left_of_respectsIso @IsFinite]
  exact finiteStableQuotientChartMap_isFinite act p hact h i

set_option backward.isDefEq.respectTransparency false in
/-- The finite canonical quotient projection is universally closed.

This exports the integral consequence of the chartwise finite construction so
descent arguments can use universal closedness directly, without rebuilding
the finite-to-integral instance at each call site.
-/
theorem finiteStableCanonicalQuotientProjection_isUniversallyClosed
    [LocallyOfFiniteType p] :
    UniversallyClosed (finiteStableCanonicalQuotientProjection act p hact h) := by
  letI : IsFinite (finiteStableCanonicalQuotientProjection act p hact h) :=
    finiteStableCanonicalQuotientProjection_isFinite act p hact h
  infer_instance

end FiniteCover

end StableAffineOpen
end StableGroupAction
end MilneLib
