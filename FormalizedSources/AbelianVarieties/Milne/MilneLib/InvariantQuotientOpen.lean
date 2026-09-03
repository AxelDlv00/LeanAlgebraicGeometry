/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotient
import MilneLib.InvariantLocalization
import Mathlib.AlgebraicGeometry.Restrict

/-!
# Opens in affine invariant quotients

Stable opens descend through the affine finite-group quotient topology.  For invariant basic
opens, the quotient-side open is identified with the spectrum of the fixed subring of the
corresponding localization.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- A basic open of the affine invariant quotient is the spectrum of the fixed localized
ring. -/
noncomputable def fixedSubalgebraBasicOpenIso [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    Scheme.Opens.toScheme
      (X := Spec (CommRingCat.of (FixedPoints.subalgebra k A G)))
      (PrimeSpectrum.basicOpen b) ≅
      Spec (CommRingCat.of (fixedAway (b : A) b.property)) :=
  AlgebraicGeometry.basicOpenIsoSpecAway
      (R := CommRingCat.of (FixedPoints.subalgebra k A G)) b ≪≫
    AlgebraicGeometry.Scheme.Spec.mapIso
      (localizationAwayFixedRingEquiv b).symm.toCommRingCatIso.op

/-- The affine quotient map on the localized chart, obtained from the inclusion of the fixed
subring into the full localization. -/
noncomputable def localizedInvariantQuotientMap
    (b : FixedPoints.subalgebra k A G) :
    Spec (CommRingCat.of
        (Localization.Away
          ((algebraMap (FixedPoints.subalgebra k A G) A) b))) ⟶
      Spec (CommRingCat.of (fixedAway (b : A) b.property)) :=
  Spec.map (CommRingCat.ofHom (fixedAway (b : A) b.property).subtype)

/-! ## Saturated opens -/

/-- The preimage of the image of a stable open under the affine invariant quotient is the
original open.  The proof uses the orbit description of quotient fibers, so this is the
topological descent input for quotient-side chart overlaps. -/
theorem preimage_image_eq_of_stable [Finite G]
    (U : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U) :
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹'
        ((affineInvariantQuotientMap (k := k) (A := A) (G := G)) '' (U : Set _)) =
      (U : Set _) := by
  apply Set.Subset.antisymm
  · rintro x ⟨y, hyU, hxy⟩
    have hq := (affineInvariantQuotientMap_eq_iff_exists_specAction
      (k := k) (A := A) (G := G) x y).mp hxy.symm
    obtain ⟨g, hact⟩ := hq
    have hxact : x ∈ (specAction G A g).hom ⁻¹ᵁ U := by
      change (specAction G A g).hom x ∈ U
      rw [hact]
      exact hyU
    rw [hU g] at hxact
    exact hxact
  · intro x hx
    exact ⟨x, hx, rfl⟩

/-- The quotient-side open descended from a stable open in the affine source. -/
noncomputable def quotientOpenOfStable [Finite G]
    (U : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U) :
    (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens :=
  ⟨(affineInvariantQuotientMap (k := k) (A := A) (G := G)) '' (U : Set _), by
    apply ((affineInvariantQuotientMap_isQuotientMap
      (k := k) (A := A) (G := G)).isCoinducing.isOpen_preimage).mp
    rw [preimage_image_eq_of_stable (k := k) (A := A) (G := G) U hU]
    exact U.2⟩

/-- Pulling the descended quotient open back along the affine quotient map recovers the stable
source open. -/
theorem quotientOpenOfStable_preimage [Finite G]
    (U : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U) :
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        quotientOpenOfStable (k := k) (A := A) (G := G) U hU = U := by
  apply TopologicalSpace.Opens.ext
  exact preimage_image_eq_of_stable (k := k) (A := A) (G := G) U hU

/-- Descending an invariant basic open gives the corresponding basic open of the fixed
subalgebra. -/
@[simp]
theorem quotientOpenOfStable_basicOpen_fixed [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    quotientOpenOfStable (k := k) (A := A) (G := G)
        (PrimeSpectrum.basicOpen (b : A) : (Spec (CommRingCat.of A)).Opens)
        (fun g => specAction_preimage_basicOpen_fixed b g) =
      (PrimeSpectrum.basicOpen b :
        (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) := by
  ext x
  constructor
  · rintro ⟨y, hy, rfl⟩
    have hy' : y ∈ (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        (PrimeSpectrum.basicOpen b :
          (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) := by
      rw [affineInvariantQuotientMap_preimage_basicOpen_fixed]
      exact hy
    exact hy'
  · intro hx
    obtain ⟨y, rfl⟩ :=
      affineInvariantQuotientMap_surjective (k := k) (A := A) (G := G) x
    refine ⟨y, ?_, rfl⟩
    have hy : y ∈ (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        (PrimeSpectrum.basicOpen b :
          (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) := hx
    rwa [affineInvariantQuotientMap_preimage_basicOpen_fixed] at hy

-- The two sides use definitionally equal presentations of the image of `b`.
set_option backward.defeqAttrib.useBackward true in
set_option backward.isDefEq.respectTransparency false in
/-- Restricting the affine invariant quotient map to `D(b)` agrees, up to the canonical
basic-open identifications, with the quotient map on the localized invariant ring. -/
noncomputable def affineInvariantQuotientMapRestrictBasicOpenIso [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    Arrow.mk
        (affineInvariantQuotientMap (k := k) (A := A) (G := G) ∣_
          (PrimeSpectrum.basicOpen b :
            (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens)) ≅
      Arrow.mk (localizedInvariantQuotientMap b) := by
  refine (SpecMapRestrictBasicOpenIso
    (CommRingCat.ofHom (algebraMap (FixedPoints.subalgebra k A G) A)) b).trans ?_
  refine Arrow.isoMk (Iso.refl _)
    (Scheme.Spec.mapIso
      (localizationAwayFixedRingEquiv b).symm.toCommRingCatIso.op) ?_
  rw [Iso.refl_hom, Category.id_comp]
  change localizedInvariantQuotientMap b = _
  rw [localizedInvariantQuotientMap]
  calc
    Spec.map (CommRingCat.ofHom (fixedAway (b : A) b.property).subtype) =
        Spec.map (CommRingCat.ofHom
          ((Localization.awayMap
              (algebraMap (FixedPoints.subalgebra k A G) A) b).comp
            (localizationAwayFixedRingEquiv b).symm.toRingHom)) := by
      exact congrArg (fun f => Spec.map (CommRingCat.ofHom f))
        (awayMap_comp_localizationAwayFixedRingEquiv_symm b).symm
    _ = Spec.map (CommRingCat.ofHom
          (Localization.awayMap
            (algebraMap (FixedPoints.subalgebra k A G) A) b)) ≫
        Spec.map (CommRingCat.ofHom
          (localizationAwayFixedRingEquiv b).symm.toRingHom) := by
      rw [CommRingCat.ofHom_comp, Spec.map_comp]
    _ = _ := rfl

end InvariantLocalization
end MilneLib
