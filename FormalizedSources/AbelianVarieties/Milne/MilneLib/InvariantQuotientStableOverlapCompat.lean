/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientStableOverlapTopology

/-!
# Reversing stable affine overlaps

The two presentations `i.U ⊓ j.U` and `j.U ⊓ i.U` of a stable affine
intersection have canonically equivalent section algebras.  This module first
records that equivalence and its compatibility with the restricted group
actions.  It will then descend the equivalence to fixed subalgebras and their
spectra.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-! ## Equality transport on sections -/

/-- Equality of opens gives an equivalence of their section algebras over the
base.  Naming this transport makes the overlap reversal independent of the
particular proof of commutativity used below. -/
noncomputable def sectionsAlgEquivOfEq
    (p : X ⟶ Spec (CommRingCat.of k)) {U V : X.Opens} (e : U = V) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    Γ(X, U) ≃ₐ[k] Γ(X, V) := by
  subst V
  letI := sectionsAlgebra p U
  exact AlgEquiv.refl

omit [X.IsSeparated] in
/-- Equality transport on sections intertwines the actions restricted to the
two equal stable opens. -/
theorem sectionsAlgEquivOfEq_equivariant
    (p : X ⟶ Spec (CommRingCat.of k)) {U V : X.Opens}
    (hU : IsStableOpen act U) (hV : IsStableOpen act V) (e : U = V) :
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    letI := sectionsMulSemiringAction act hU
    letI := sectionsMulSemiringAction act hV
    ∀ (g : G) (s : Γ(X, U)),
      g • sectionsAlgEquivOfEq p e s = sectionsAlgEquivOfEq p e (g • s) := by
  subst V
  intro g s
  rfl

omit [X.IsSeparated] in
/-- Equality transport after restriction is restriction to the transported
open. -/
theorem sectionsAlgEquivOfEq_comp_restriction
    (p : X ⟶ Spec (CommRingCat.of k)) {U V W : X.Opens} (e : U = V)
    (hUW : U ≤ W) (hVW : V ≤ W) :
    letI := sectionsAlgebra p W
    letI := sectionsAlgebra p U
    letI := sectionsAlgebra p V
    (sectionsAlgEquivOfEq p e).toAlgHom.comp
        (sectionsRestrictionAlgHom p hUW) =
      sectionsRestrictionAlgHom p hVW := by
  subst V
  rfl

/-! ## Reversal of a pairwise overlap -/

/-- Commutativity of intersection, viewed on section algebras over the base. -/
noncomputable def overlapSectionsAlgEquiv
    (p : X ⟶ Spec (CommRingCat.of k)) (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    Γ(X, j.U ⊓ i.U) ≃ₐ[k] Γ(X, i.U ⊓ j.U) :=
  sectionsAlgEquivOfEq p (inf_comm j.U i.U)

/-- The section-algebra overlap reversal is equivariant. -/
theorem overlapSectionsAlgEquiv_equivariant
    (p : X ⟶ Spec (CommRingCat.of k)) (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    ∀ (g : G) (s : Γ(X, j.U ⊓ i.U)),
      g • overlapSectionsAlgEquiv act p i j s =
        overlapSectionsAlgEquiv act p i j (g • s) :=
  sectionsAlgEquivOfEq_equivariant act p
    (overlap_stable act j i) (overlap_stable act i j) (inf_comm j.U i.U)

/-- Swapping an overlap carries restriction from chart `j` to the reversed
left restriction. -/
theorem overlapSectionsAlgEquiv_comp_leftRestriction
    (p : X ⟶ Spec (CommRingCat.of k)) (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    (overlapSectionsAlgEquiv act p i j).toAlgHom.comp
        (sectionsRestrictionAlgHom p
          (show j.U ⊓ i.U ≤ j.U from inf_le_left)) =
      sectionsRestrictionAlgHom p
        (show i.U ⊓ j.U ≤ j.U from inf_le_right) :=
  sectionsAlgEquivOfEq_comp_restriction p (inf_comm j.U i.U)
    inf_le_left inf_le_right

/-- Swapping an overlap carries restriction from chart `i` to the reversed
right restriction. -/
theorem overlapSectionsAlgEquiv_comp_rightRestriction
    (p : X ⟶ Spec (CommRingCat.of k)) (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    (overlapSectionsAlgEquiv act p i j).toAlgHom.comp
        (sectionsRestrictionAlgHom p
          (show j.U ⊓ i.U ≤ i.U from inf_le_right)) =
      sectionsRestrictionAlgHom p
        (show i.U ⊓ j.U ≤ i.U from inf_le_left) :=
  sectionsAlgEquivOfEq_comp_restriction p (inf_comm j.U i.U)
    inf_le_right inf_le_left

/-! ## Reversal on invariant sections and spectra -/

/-- The section-algebra reversal restricts to an equivalence of invariant
section algebras. -/
noncomputable def overlapFixedSectionsAlgEquiv
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    FixedPoints.subalgebra k Γ(X, j.U ⊓ i.U) G ≃ₐ[k]
      FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G := by
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  exact InvariantLocalization.equivariantFixedAlgEquiv
    (overlapSectionsAlgEquiv act p i j)
    (overlapSectionsAlgEquiv_equivariant act p i j)

@[simp]
theorem overlapFixedSectionsAlgEquiv_coe
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act)
    (s : letI := sectionsAlgebra p (j.U ⊓ i.U)
      letI := sectionsMulSemiringAction act (overlap_stable act j i)
      letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
      FixedPoints.subalgebra k Γ(X, j.U ⊓ i.U) G) :
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    ((overlapFixedSectionsAlgEquiv act p hact i j s :
        FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G) : Γ(X, i.U ⊓ j.U)) =
      overlapSectionsAlgEquiv act p i j (s : Γ(X, j.U ⊓ i.U)) := by
  rfl

/-- On invariant sections, overlap reversal carries the reversed left
restriction from chart `j` to the original right restriction. -/
theorem overlapFixedSectionsAlgEquiv_comp_leftRestriction
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (overlapFixedSectionsAlgEquiv act p hact i j).toAlgHom.comp
        (InvariantLocalization.equivariantFixedAlgHom
          (sectionsRestrictionAlgHom p
            (show j.U ⊓ i.U ≤ j.U from inf_le_left))
          (sectionsRestrictionAlgHom_equivariant act p hact j.stable
            (overlap_stable act j i) inf_le_left)) =
      InvariantLocalization.equivariantFixedAlgHom
        (sectionsRestrictionAlgHom p
          (show i.U ⊓ j.U ≤ j.U from inf_le_right))
        (sectionsRestrictionAlgHom_equivariant act p hact j.stable
          (overlap_stable act i j) inf_le_right) := by
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  apply DFunLike.ext _ _
  intro s
  apply Subtype.ext
  exact DFunLike.congr_fun
    (overlapSectionsAlgEquiv_comp_leftRestriction act p i j) (s : Γ(X, j.U))

/-- On invariant sections, overlap reversal carries the reversed right
restriction from chart `i` to the original left restriction. -/
theorem overlapFixedSectionsAlgEquiv_comp_rightRestriction
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (overlapFixedSectionsAlgEquiv act p hact i j).toAlgHom.comp
        (InvariantLocalization.equivariantFixedAlgHom
          (sectionsRestrictionAlgHom p
            (show j.U ⊓ i.U ≤ i.U from inf_le_right))
          (sectionsRestrictionAlgHom_equivariant act p hact i.stable
            (overlap_stable act j i) inf_le_right)) =
      InvariantLocalization.equivariantFixedAlgHom
        (sectionsRestrictionAlgHom p
          (show i.U ⊓ j.U ≤ i.U from inf_le_left))
        (sectionsRestrictionAlgHom_equivariant act p hact i.stable
          (overlap_stable act i j) inf_le_left) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  apply DFunLike.ext _ _
  intro s
  apply Subtype.ext
  exact DFunLike.congr_fun
    (overlapSectionsAlgEquiv_comp_rightRestriction act p i j) (s : Γ(X, i.U))

/-- The fixed-ring spectra attached to the two orders of an intersection are
canonically isomorphic.  The orientation is reversed by `Spec`. -/
noncomputable def fixedOverlapIso
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    Spec (CommRingCat.of
      (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)) ≅
        Spec (CommRingCat.of
          (FixedPoints.subalgebra k Γ(X, j.U ⊓ i.U) G)) := by
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  exact Scheme.Spec.mapIso
    (overlapFixedSectionsAlgEquiv act p hact i j).toRingEquiv.toCommRingCatIso.op

@[simp]
theorem fixedOverlapIso_hom
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (fixedOverlapIso act p hact i j).hom =
      Spec.map (CommRingCat.ofHom
        (overlapFixedSectionsAlgEquiv act p hact i j).toRingEquiv.toRingHom) := by
  rfl

/-- The fixed-overlap reversal followed by the left leg of the reversed cone is
the right leg of the original cone. -/
@[reassoc]
theorem fixedOverlapIso_hom_comp_leftFixedRestrictionMap
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (fixedOverlapIso act p hact i j).hom ≫
        overlapFixedRestrictionMap act p hact j i =
      overlapFixedRestrictionMapRight act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  rw [fixedOverlapIso_hom]
  unfold overlapFixedRestrictionMap overlapFixedRestrictionMapRight
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  apply congrArg Spec.map
  apply CommRingCat.hom_ext
  exact congrArg AlgHom.toRingHom
    (overlapFixedSectionsAlgEquiv_comp_leftRestriction act p hact i j)

/-- The fixed-overlap reversal followed by the right leg of the reversed cone
is the left leg of the original cone. -/
@[reassoc]
theorem fixedOverlapIso_hom_comp_rightFixedRestrictionMap
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (j.U ⊓ i.U)
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act j i)
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    (fixedOverlapIso act p hact i j).hom ≫
        overlapFixedRestrictionMapRight act p hact j i =
      overlapFixedRestrictionMap act p hact i j := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p j.U
  letI := sectionsAlgebra p (j.U ⊓ i.U)
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act j.stable
  letI := sectionsMulSemiringAction act (overlap_stable act j i)
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact j.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act j i)
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  rw [fixedOverlapIso_hom]
  unfold overlapFixedRestrictionMapRight overlapFixedRestrictionMap
  rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
  apply congrArg Spec.map
  apply CommRingCat.hom_ext
  exact congrArg AlgHom.toRingHom
    (overlapFixedSectionsAlgEquiv_comp_rightRestriction act p hact i j)

end StableAffineOpen
end StableGroupAction
end MilneLib
