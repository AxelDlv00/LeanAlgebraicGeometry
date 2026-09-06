/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientStableOverlapCompat

/-!
# Descended open subschemes of invariant quotient overlaps

The spectrum of the invariant section ring of a stable affine overlap maps by
an open immersion onto the descended overlap open.  This file packages that
identification as an isomorphism of schemes.  These isomorphisms are the local
geometric input for the overlap objects in the eventual quotient gluing datum.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Topology

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-- The fixed-section overlap map and the inclusion of its descended open have
the same range in the left invariant quotient chart. -/
theorem overlapFixedRestrictionMap_range_quotientOverlapι [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    Set.range (overlapFixedRestrictionMap act p hact i j).base =
      Set.range (quotientOverlapι act p hact i j).base := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  rw [show Set.range (quotientOverlapι act p hact i j).base =
      (quotientOverlapOpen act p hact i j : Set _) by
    exact Scheme.Opens.range_ι _]
  exact (overlapFixedRestrictionMap_isOpenEmbedding_range
    act p hact i j).2

/-- The fixed-section spectrum of an actual overlap is canonically isomorphic
to the descended overlap open in the left invariant quotient chart. -/
noncomputable def fixedOverlapQuotientIso [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    Spec (CommRingCat.of
      (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)) ≅
        quotientOverlap act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  let f := overlapFixedRestrictionMap act p hact i j
  let qι := quotientOverlapι act p hact i j
  letI : IsOpenImmersion f :=
    overlapFixedRestrictionMap_isOpenImmersion act p hact i j
  letI : IsOpenImmersion qι := by
    dsimp only [qι]
    infer_instance
  exact IsOpenImmersion.isoOfRangeEq f qι
    (overlapFixedRestrictionMap_range_quotientOverlapι act p hact i j)

/-- The overlap isomorphism followed by the descended-open inclusion is the
fixed-section restriction map. -/
@[reassoc (attr := simp)]
theorem fixedOverlapQuotientIso_hom_comp_ι [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (fixedOverlapQuotientIso act p hact i j).hom ≫
        quotientOverlapι act p hact i j =
      overlapFixedRestrictionMap act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  let f := overlapFixedRestrictionMap act p hact i j
  let qι := quotientOverlapι act p hact i j
  letI : IsOpenImmersion f :=
    overlapFixedRestrictionMap_isOpenImmersion act p hact i j
  letI : IsOpenImmersion qι := by
    dsimp only [qι]
    infer_instance
  exact IsOpenImmersion.isoOfRangeEq_hom_fac f qι
    (overlapFixedRestrictionMap_range_quotientOverlapι act p hact i j)

/-- The fixed-section spectrum of an overlap is also canonically isomorphic to
the descended overlap open in the right invariant quotient chart. -/
noncomputable def fixedOverlapQuotientIsoRight [Finite G]
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
    Spec (CommRingCat.of
      (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)) ≅
        quotientOverlap act p hact j i := by
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
  exact (fixedOverlapIso act p hact i j).trans
    (fixedOverlapQuotientIso act p hact j i)

/-- The right overlap isomorphism followed by its descended-open inclusion is
the right fixed-section restriction map. -/
@[reassoc (attr := simp)]
theorem fixedOverlapQuotientIsoRight_hom_comp_ι [Finite G]
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
    (fixedOverlapQuotientIsoRight act p hact i j).hom ≫
        quotientOverlapι act p hact j i =
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
  simp only [fixedOverlapQuotientIsoRight, Iso.trans_hom, Category.assoc,
    fixedOverlapQuotientIso_hom_comp_ι,
    fixedOverlapIso_hom_comp_leftFixedRestrictionMap]

/-- Reversing an ordered overlap gives a canonical isomorphism between the two
descended quotient-open subschemes. -/
noncomputable def quotientOverlapSwapIso [Finite G]
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
    quotientOverlap act p hact i j ≅ quotientOverlap act p hact j i := by
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
  exact (fixedOverlapQuotientIso act p hact i j).symm.trans
    (fixedOverlapQuotientIsoRight act p hact i j)

/-- The overlap-swap isomorphism is characterized by the two fixed-section
presentations of the descended opens. -/
@[reassoc (attr := simp)]
theorem fixedOverlapQuotientIso_hom_comp_swap [Finite G]
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
    (fixedOverlapQuotientIso act p hact i j).hom ≫
        (quotientOverlapSwapIso act p hact i j).hom =
      (fixedOverlapQuotientIsoRight act p hact i j).hom := by
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
  simp [quotientOverlapSwapIso]

end StableAffineOpen
end StableGroupAction
end MilneLib
