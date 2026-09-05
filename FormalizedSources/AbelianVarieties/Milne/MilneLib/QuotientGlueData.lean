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

/-- Reversing a self-overlap is the identity isomorphism.  This is the
diagonal transition required by `Scheme.GlueData`. -/
theorem quotientOverlapSwapIso_self [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsSMulCommClass act p hact i.stable
    quotientOverlapSwapIso act p hact i i = Iso.refl _ := by
  letI := sectionsAlgebra p i.U
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsSMulCommClass act p hact i.stable
  apply Iso.ext
  apply (cancel_mono (quotientOverlapι act p hact i i)).1
  rw [quotientOverlapSwapIso_hom_comp_ι]
  have hAlg : overlapFixedSectionsAlgEquiv act p hact i i =
      (AlgEquiv.refl : _ ≃ₐ[k] _) := by
    ext x
    rfl
  rw [← fixedOverlapQuotientIsoRight_hom_comp_ι act p hact i i]
  have hfixed : fixedOverlapIso act p hact i i = Iso.refl _ := by
    apply Iso.ext
    rw [fixedOverlapIso_hom, hAlg]
    simp
  rw [fixedOverlapQuotientIsoRight, hfixed]
  simp only [Iso.trans_hom, Iso.refl_hom, Category.id_comp,
    Iso.inv_hom_id_assoc]

/-- The two overlap reversals compose to the identity.  This is the
off-diagonal involution coherence for the eventual gluing transitions. -/
theorem quotientOverlapSwapIso_trans_swapIso [Finite G]
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
    quotientOverlapSwapIso act p hact i j ≪≫
      quotientOverlapSwapIso act p hact j i = Iso.refl _ := by
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
  apply Iso.ext
  apply (cancel_mono (quotientOverlapι act p hact i j)).1
  simp only [Iso.trans_hom, Iso.refl_hom]
  rw [Category.assoc, quotientOverlapSwapIso_hom_comp_ι]
  rw [quotientOverlapSwapIso, Iso.trans_hom, Iso.symm_hom,
    fixedOverlapQuotientIsoRight, Iso.trans_hom]
  simp only [Category.assoc, Iso.hom_inv_id_assoc]
  rw [fixedOverlapIso_hom_comp_rightFixedRestrictionMap]
  rw [← fixedOverlapQuotientIso_hom_comp_ι act p hact i j]
  simp only [Iso.inv_hom_id_assoc, Category.id_comp]

/-- The reversal attached to an ordered overlap is the inverse of the
reversal attached to the opposite order. -/
theorem quotientOverlapSwapIso_symm [Finite G]
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
    quotientOverlapSwapIso act p hact i j =
      (quotientOverlapSwapIso act p hact j i).symm := by
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
  apply Iso.ext
  dsimp [quotientOverlapSwapIso, fixedOverlapQuotientIsoRight]
  rw [← fixedOverlapIso_symm act p hact i j]
  simp only [Iso.trans_hom, Category.assoc]

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
