/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotient
import MilneLib.InvariantLocalization
import Mathlib.AlgebraicGeometry.Restrict

/-!
# Invariant affine quotient basic opens

This file identifies a basic open in the spectrum of an invariant subalgebra with the
spectrum of the fixed subring of the corresponding localization.  It is the geometric form
of invariants commuting with localization at an invariant element.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry

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
