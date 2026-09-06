/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import MilneLib.Quotient.InvariantQuotientOpen
import Mathlib.AlgebraicGeometry.Restrict
import Mathlib.Topology.Constructions

/-!
# Quotient topology on descended stable opens

The affine invariant quotient is a quotient map globally.  A stable open and
its descended image are related by an exact preimage identity, so the
restricted projection is again a quotient map.  This is the topological
effectivity statement needed when these restricted affine charts are used in
a finite gluing diagram.
-/

set_option autoImplicit false

universe u v

open CategoryTheory AlgebraicGeometry Topology TopologicalSpace

namespace MilneLib
namespace InvariantLocalization

variable {k : Type u} {A : Type v} {G : Type*}
  [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- The map from a stable source open to its descended quotient open is a
topological quotient map.  The proof transports the standard restriction of
the global quotient map across the equality of the source open with the
preimage of its descended target open. -/
theorem affineInvariantQuotientMapRestrictStable_isQuotientMap [Finite G]
    (U : (Spec (CommRingCat.of A)).Opens)
    (hU : ∀ g : G, (specAction G A g).hom ⁻¹ᵁ U = U) :
    Topology.IsQuotientMap
      (affineInvariantQuotientMapRestrictStable
        (k := k) (A := A) (G := G) U hU).base := by
  let q := affineInvariantQuotientMap (k := k) (A := A) (G := G)
  let W := quotientOpenOfStable (k := k) (A := A) (G := G) U hU
  have hq : Topology.IsQuotientMap q.base :=
    affineInvariantQuotientMap_isQuotientMap (k := k) (A := A) (G := G)
  have hW :
      IsOpen (W : Set (Spec (CommRingCat.of (FixedPoints.subalgebra k A G)))) :=
    W.is_open'
  have hrestricted :
      Topology.IsQuotientMap (W.1.restrictPreimage q.base) :=
    hq.restrictPreimage_isOpen hW
  have hpre : q ⁻¹ᵁ W = U :=
    quotientOpenOfStable_preimage (k := k) (A := A) (G := G) U hU
  have hset :
      (U.carrier : Set (Spec (CommRingCat.of A))) =
        q.base ⁻¹' (W.carrier : Set
          (Spec (CommRingCat.of (FixedPoints.subalgebra k A G)))) := by
    simpa [q, W] using congrArg
      (fun O : (Spec (CommRingCat.of A)).Opens =>
        (O.carrier : Set (Spec (CommRingCat.of A)))) hpre.symm
  let e : (U.carrier : Set (Spec (CommRingCat.of A))) ≃ₜ
      (q.base ⁻¹' (W.carrier : Set
        (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))))) :=
    Homeomorph.setCongr hset
  have he : Topology.IsQuotientMap e := e.isQuotientMap
  have hcomp :
      Topology.IsQuotientMap ((W.1.restrictPreimage q.base) ∘ e) :=
    hrestricted.comp he
  have hmap :
      ⇑(affineInvariantQuotientMapRestrictStable
        (k := k) (A := A) (G := G) U hU).base =
        (W.1.restrictPreimage q.base) ∘ e := by
    funext x
    apply Subtype.ext
    change ((affineInvariantQuotientMapRestrictStable
        (k := k) (A := A) (G := G) U hU).base x).1 =
      ((W.1.restrictPreimage q.base) (e x)).1
    simp only [Set.restrictPreimage]
    have hfac := affineInvariantQuotientMapRestrictStable_fac
      (k := k) (A := A) (G := G) U hU
    have hx := congrArg (fun f => f.base x) hfac
    exact hx
  rw [hmap]
  exact hcomp

end InvariantLocalization
end MilneLib
