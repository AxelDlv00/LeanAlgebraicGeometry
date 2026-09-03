/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.InvariantQuotientOpen

/-!
# Order reflection for descended stable opens

The affine invariant quotient identifies stable opens by their pullback.  The
surjective quotient map therefore makes the descended-open operation an order
embedding on stable opens.  These lemmas are the bookkeeping interface used by
overlap and finite-cover constructions; they do not assert existence of a
non-affine quotient.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- Pullback along the affine invariant quotient reflects inclusion of stable opens. -/
theorem quotientOpenOfStable_le_iff [Finite G]
    {U V : (Spec (CommRingCat.of A)).Opens}
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ V = V) :
    quotientOpenOfStable (k := k) (A := A) (G := G) U hU ≤
      quotientOpenOfStable (k := k) (A := A) (G := G) V hV ↔ U ≤ V := by
  constructor
  · intro h
    rw [← quotientOpenOfStable_preimage (k := k) (A := A) (G := G) U hU,
      ← quotientOpenOfStable_preimage (k := k) (A := A) (G := G) V hV]
    exact (affineInvariantQuotientMap (k := k) (A := A) (G := G)).preimage_mono h
  · intro h
    exact quotientOpenOfStable_mono (k := k) (A := A) (G := G) hU hV h

/-- Equality of descended opens is equivalent to equality of the stable source opens. -/
theorem quotientOpenOfStable_eq_iff [Finite G]
    {U V : (Spec (CommRingCat.of A)).Opens}
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U)
    (hV : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ V = V) :
    quotientOpenOfStable (k := k) (A := A) (G := G) U hU =
      quotientOpenOfStable (k := k) (A := A) (G := G) V hV ↔ U = V := by
  constructor
  · intro h
    apply le_antisymm
    · exact (quotientOpenOfStable_le_iff (k := k) (A := A) (G := G) hU hV).mp
        (by simp [h])
    · exact (quotientOpenOfStable_le_iff (k := k) (A := A) (G := G) hV hU).mp
        (by simp [h])
  · rintro rfl
    rfl

end InvariantLocalization
end MilneLib
