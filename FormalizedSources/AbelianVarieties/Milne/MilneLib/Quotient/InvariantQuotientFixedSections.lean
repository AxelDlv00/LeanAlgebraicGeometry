/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientStableOverlapOpenIso

/-!
# Fixed sections on descended stable overlaps

The descended overlap open is presented by the spectrum of the fixed section
ring.  This file transports the presentation to top sections of the open
subscheme and records the restriction square with the ambient quotient chart.
The latter is the section-level input needed when assembling the quotient
charts by `Scheme.GlueData`.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Topology

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-! ## Sections transported across a scheme isomorphism -/

/-- The top-section ring equivalence induced contravariantly by a scheme
isomorphism `e : S ≅ T`.  We spell out the inverse maps so that this remains
usable for `Scheme.Hom.appTop`, whose top-open casts do not expose an
automatic `IsIso` instance. -/
noncomputable def topSectionsRingEquiv {S T : Scheme.{u}} (e : S ≅ T) :
    Γ(T, ⊤) ≃+* Γ(S, ⊤) := by
  refine RingEquiv.ofRingHom e.hom.appTop.hom e.inv.appTop.hom ?_ ?_
  · ext x
    change (e.hom.appTop.hom (e.inv.appTop.hom x)) = x
    rw [← CommRingCat.comp_apply, ← Scheme.Hom.comp_appTop, e.hom_inv_id]
    simp
  · ext x
    change (e.inv.appTop.hom (e.hom.appTop.hom x)) = x
    rw [← CommRingCat.comp_apply, ← Scheme.Hom.comp_appTop, e.inv_hom_id]
    simp

/-! ## Left quotient chart -/

/-- Top sections of the descended overlap, identified with the fixed section
ring of the actual overlap. -/
noncomputable def fixedOverlapSectionsEquiv [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    Γ(quotientOverlap act p hact i j, ⊤) ≃+*
      FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  let e := fixedOverlapQuotientIso act p hact i j
  exact (topSectionsRingEquiv e).trans
    (Scheme.ΓSpecIso
      (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G))).commRingCatIsoToRingEquiv

/-- The top-section presentation of a descended overlap carries the ambient
chart restriction to the fixed restriction map on section rings. -/
theorem fixedOverlapSectionsEquiv_comp_ι_appTop [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (fixedOverlapSectionsEquiv act p hact i j).toRingHom.comp
      (quotientOverlapι act p hact i j).appTop.hom =
      (Scheme.ΓSpecIso
        (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G))).hom.hom.comp
        (overlapFixedRestrictionMap act p hact i j).appTop.hom := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  let e := fixedOverlapQuotientIso act p hact i j
  have hcomp := congrArg (fun f :
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)) ⟶
        Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G)) => f.appTop)
    (fixedOverlapQuotientIso_hom_comp_ι act p hact i j)
  rw [Scheme.Hom.comp_appTop] at hcomp
  have hcomp' := congrArg (fun f :
      Γ(Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U) G)), ⊤) ⟶
        Γ(Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)), ⊤) =>
      f ≫ (Scheme.ΓSpecIso
        (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G))).hom) hcomp
  ext s
  simp only [fixedOverlapSectionsEquiv, topSectionsRingEquiv,
    RingEquiv.toRingHom_eq_coe, RingHom.coe_comp, RingHom.coe_coe,
    Function.comp_apply, SetLike.coe_eq_coe]
  exact congrArg (fun f => f.hom s) hcomp'

/-! ## Right quotient chart -/

/-- The right-chart presentation uses the same fixed overlap ring, after the
canonical reversal of the ordered intersection. -/
noncomputable def fixedOverlapSectionsEquivRight [Finite G]
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
    Γ(quotientOverlap act p hact j i, ⊤) ≃+*
      FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G := by
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
  let e := fixedOverlapQuotientIsoRight act p hact i j
  exact (topSectionsRingEquiv e).trans
    (Scheme.ΓSpecIso
      (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G))).commRingCatIsoToRingEquiv

/-- The right-chart top-section presentation carries restriction to the right
fixed restriction map. -/
theorem fixedOverlapSectionsEquivRight_comp_ι_appTop [Finite G]
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
    (fixedOverlapSectionsEquivRight act p hact i j).toRingHom.comp
      (quotientOverlapι act p hact j i).appTop.hom =
      (Scheme.ΓSpecIso
        (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G))).hom.hom.comp
        (overlapFixedRestrictionMapRight act p hact i j).appTop.hom := by
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
  let e := fixedOverlapQuotientIsoRight act p hact i j
  have hcomp := congrArg (fun f :
      Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)) ⟶
        Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, j.U) G)) => f.appTop)
    (fixedOverlapQuotientIsoRight_hom_comp_ι act p hact i j)
  rw [Scheme.Hom.comp_appTop] at hcomp
  have hcomp' := congrArg (fun f :
      Γ(Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, j.U) G)), ⊤) ⟶
        Γ(Spec (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)), ⊤) =>
      f ≫ (Scheme.ΓSpecIso
        (CommRingCat.of (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G))).hom) hcomp
  ext s
  simp only [fixedOverlapSectionsEquivRight, topSectionsRingEquiv,
    RingEquiv.toRingHom_eq_coe, RingHom.coe_comp, RingHom.coe_coe,
    Function.comp_apply, SetLike.coe_eq_coe]
  exact congrArg (fun f => f.hom s) hcomp'

end StableAffineOpen
end StableGroupAction
end MilneLib
