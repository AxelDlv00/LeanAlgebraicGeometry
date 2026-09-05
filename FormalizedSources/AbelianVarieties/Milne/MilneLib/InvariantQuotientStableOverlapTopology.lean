/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientOpenEmbedding
import MilneLib.InvariantQuotientStableOverlap

/-!
# Topology of invariant quotients on stable affine overlaps

The fixed-ring spectrum of an affine chart intersection maps by an open embedding
to the invariant quotient of either chart. Its range is exactly the descended
overlap open. This is the topological part of the overlap comparison; no
scheme-level open-immersion or sheaf comparison is asserted here.
-/

set_option autoImplicit false

universe u

open CategoryTheory AlgebraicGeometry Topology

namespace MilneLib
namespace StableGroupAction
namespace StableAffineOpen

variable {k G : Type u} [CommRing k] [Group G] {X : Scheme.{u}}
  (act : G →* Aut X) [X.IsSeparated]

/-- The coordinate overlap is the preimage of the actual intersection under
the affine-chart presentation. -/
theorem overlapCoordinateOpen_eq_preimage (i j : StableAffineOpen act) :
    overlapCoordinateOpen act i j =
      i.affine.fromSpec ⁻¹ᵁ (i.U ⊓ j.U) := by
  unfold overlapCoordinateOpen
  rw [← Scheme.Hom.comp_preimage]
  rfl

/-- The spectrum map induced by restricting sections from \`i.U\` to
\`i.U ⊓ j.U\` has range equal to the coordinate overlap. -/
theorem range_specMap_sectionsRestriction_overlap
    (i j : StableAffineOpen act) :
    Set.range (Spec.map
      (X.presheaf.map
        (homOfLE (show i.U ⊓ j.U ≤ i.U from inf_le_left)).op)).base =
      (overlapCoordinateOpen act i j : Set _) := by
  let f := Spec.map
    (X.presheaf.map
      (homOfLE (show i.U ⊓ j.U ≤ i.U from inf_le_left)).op)
  have hcomp :
      f ≫ i.affine.fromSpec = (overlap_affine act i j).fromSpec :=
    i.affine.map_fromSpec (overlap_affine act i j)
      (homOfLE (show i.U ⊓ j.U ≤ i.U from inf_le_left)).op
  ext x
  constructor
  · rintro ⟨y, rfl⟩
    rw [overlapCoordinateOpen_eq_preimage]
    change i.affine.fromSpec.base (f.base y) ∈ (i.U ⊓ j.U)
    rw [← Scheme.Hom.comp_apply, hcomp]
    change ((overlap_affine act i j).isoSpec.inv.base y).1 ∈ (i.U ⊓ j.U)
    exact ((overlap_affine act i j).isoSpec.inv.base y).2
  · intro hx
    rw [overlapCoordinateOpen_eq_preimage] at hx
    change i.affine.fromSpec.base x ∈ (i.U ⊓ j.U) at hx
    let z : (i.U ⊓ j.U).toScheme := ⟨i.affine.fromSpec.base x, hx⟩
    let y := (overlap_affine act i j).isoSpec.hom.base z
    refine ⟨y, ?_⟩
    apply i.affine.fromSpec.isOpenEmbedding.injective
    rw [← Scheme.Hom.comp_apply, hcomp]
    change ((overlap_affine act i j).isoSpec.inv.base
      ((overlap_affine act i j).isoSpec.hom.base z)).1 =
        i.affine.fromSpec.base x
    have hz := congrArg (fun f => f.base z)
      (overlap_affine act i j).isoSpec.hom_inv_id
    change (overlap_affine act i j).isoSpec.inv.base
      ((overlap_affine act i j).isoSpec.hom.base z) = z at hz
    rw [hz]

/-- The map from the fixed ring of the actual overlap to the fixed ring of the
left chart. It is the underlying scheme map of the left quotient leg of the
canonical overlap cone. -/
noncomputable def overlapFixedRestrictionMap
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
      (FixedPoints.subalgebra k Γ(X, i.U ⊓ j.U) G)) ⟶
        Spec (CommRingCat.of
          (FixedPoints.subalgebra k Γ(X, i.U) G)) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  exact Spec.map (CommRingCat.ofHom
    (InvariantLocalization.equivariantFixedRingHom
      (k := k) (G := G) (sectionsRestrictionAlgHom p inf_le_left).toRingHom
      (sectionsRestrictionAlgHom_equivariant act p hact i.stable
        (overlap_stable act i j) inf_le_left)))

/-- The fixed restriction map is the left quotient leg of the canonical
overlap cone. -/
theorem overlapFixedRestrictionMap_eq_leftQuotientMap
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p j.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act j.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact j.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    overlapFixedRestrictionMap act p hact i j =
      (overlapCone act p hact i j).leftQuotientMap.left := by
  rfl

/-- The fixed-ring spectrum of the actual overlap embeds onto exactly the
descended overlap open in quotient chart \`i\`. -/
theorem overlapFixedRestrictionMap_isOpenEmbedding_range [Finite G]
    (p : X ⟶ Spec (CommRingCat.of k))
    (hact : ∀ g : G, (act g).hom ≫ p = p)
    (i j : StableAffineOpen act) :
    letI := sectionsAlgebra p i.U
    letI := sectionsAlgebra p (i.U ⊓ j.U)
    letI := sectionsMulSemiringAction act i.stable
    letI := sectionsMulSemiringAction act (overlap_stable act i j)
    letI := sectionsSMulCommClass act p hact i.stable
    letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
    IsOpenEmbedding (overlapFixedRestrictionMap act p hact i j).base ∧
      Set.range (overlapFixedRestrictionMap act p hact i j).base =
        (quotientOverlapOpen act p hact i j : Set _) := by
  letI := sectionsAlgebra p i.U
  letI := sectionsAlgebra p (i.U ⊓ j.U)
  letI := sectionsMulSemiringAction act i.stable
  letI := sectionsMulSemiringAction act (overlap_stable act i j)
  letI := sectionsSMulCommClass act p hact i.stable
  letI := sectionsSMulCommClass act p hact (overlap_stable act i j)
  let φ := (sectionsRestrictionAlgHom p
    (show i.U ⊓ j.U ≤ i.U from inf_le_left)).toRingHom
  have hφ : ∀ (g : G) (b : Γ(X, i.U)), g • φ b = φ (g • b) :=
    sectionsRestrictionAlgHom_equivariant act p hact i.stable
      (overlap_stable act i j) inf_le_left
  have hSpec : IsOpenEmbedding
      (Spec.map (CommRingCat.ofHom φ)).base := by
    change IsOpenEmbedding
      (Spec.map (X.presheaf.map (homOfLE
        (show i.U ⊓ j.U ≤ i.U from inf_le_left)).op)).base
    exact (isOpenImmersion_specMap_sectionsRestriction
      i.affine (overlap_affine act i j) inf_le_left).base_open
  have hRange :
      (overlapCoordinateOpen act i j : Set _) =
        Set.range (Spec.map (CommRingCat.ofHom φ)).base := by
    exact (range_specMap_sectionsRestriction_overlap act i j).symm
  have h := InvariantLocalization.equivariantFixedSpecMap_isOpenEmbedding
    (k := k) (G := G) φ hφ hSpec
      (overlapCoordinateOpen act i j) hRange
      (overlapCoordinateOpen_stable act i j)
  simpa only [overlapFixedRestrictionMap, φ, hφ, quotientOverlapOpen] using h

end StableAffineOpen
end StableGroupAction
end MilneLib
