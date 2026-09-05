/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientStableOverlapOpenIso

/-!
# Transition equations for stable-affine quotient overlaps

The canonical overlap reversal is constructed by comparing two fixed-section
presentations of the same descended open.  This file exposes the resulting
equation in the form used by `Scheme.GlueData`: after reversing an overlap, its
open immersion into the opposite quotient chart is the right fixed-section
restriction map.  The statement is conditional only on the displayed affine
chart and base data; it does not assert existence of a non-affine quotient.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-! ## The gluing-oriented transition equation -/

/-- The canonical quotient-overlap reversal, followed by the opposite
descended-open inclusion, is the right fixed-section restriction map after
transporting back along the fixed-section presentation of the original
overlap.  This is the orientation required for the transition leg in a
`Scheme.GlueData` datum. -/
@[reassoc (attr := simp)]
theorem quotientOverlapSwapIso_hom_comp_ι [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    (quotientOverlapSwapIso act p hact i j).hom ≫
        quotientOverlapι act p hact j i =
      (fixedOverlapQuotientIso act p hact i j).inv ≫
        overlapFixedRestrictionMapRight act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  apply (cancel_epi (fixedOverlapQuotientIso act p hact i j).hom).1
  calc
    _ = ((fixedOverlapQuotientIso act p hact i j).hom ≫
        (quotientOverlapSwapIso act p hact i j).hom) ≫
        quotientOverlapι act p hact j i := by
      rfl
    _ = (fixedOverlapQuotientIsoRight act p hact i j).hom ≫
        quotientOverlapι act p hact j i := by
      rw [fixedOverlapQuotientIso_hom_comp_swap]
    _ = overlapFixedRestrictionMapRight act p hact i j :=
      fixedOverlapQuotientIsoRight_hom_comp_ι act p hact i j
    _ = (fixedOverlapQuotientIso act p hact i j).hom ≫
        (fixedOverlapQuotientIso act p hact i j).inv ≫
          overlapFixedRestrictionMapRight act p hact i j := by
      simp only [Iso.hom_inv_id_assoc]

/- The same transition equation expressed with the canonical quotient leg of
the equivariant affine overlap cone.  This is the form consumed when the
overlap is fed into the cross-chart gluing datum. -/
@[reassoc]
theorem quotientOverlapSwapIso_hom_comp_ι_eq_rightQuotientMap [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    (quotientOverlapSwapIso act p hact i j).hom ≫
        quotientOverlapι act p hact j i =
      (fixedOverlapQuotientIso act p hact i j).inv ≫
        (overlapCone act p hact i j).rightQuotientMap.left := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  rw [quotientOverlapSwapIso_hom_comp_ι,
    overlapFixedRestrictionMapRight_eq_rightQuotientMap]
  rfl

/-! ## The diagonal overlap -/

/-- The descended self-overlap is the whole quotient chart.  Consequently its
open inclusion is an isomorphism, supplying the diagonal `f_id` input for a
cross-chart gluing datum. -/
instance quotientOverlapι_self_isIso [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    IsIso (quotientOverlapι act p hact i i) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  letI : IsOpenImmersion (quotientOverlapι act p hact i i) :=
    quotientOverlapι_isOpenImmersion act p hact i i
  apply isIso_of_isOpenImmersion_of_opensRange_eq_top
  apply TopologicalSpace.Opens.ext
  ext y
  constructor
  · intro _
    trivial
  · intro _
    apply Scheme.Hom.mem_opensRange.mpr
    refine ⟨⟨y, ?_⟩, ?_⟩
    · have hopen : quotientOverlapOpen act p hact i i = ⊤ := by
        unfold quotientOverlapOpen
        simp only [overlapCoordinateOpen]
        simpa using (InvariantLocalization.quotientOpenOfStable_top
          (k := k) (A := Γ(X, i.U)) (G := G))
      rw [hopen]
      trivial
    · rfl

end StableAffineOpen
end StableGroupAction
end MilneLib
