/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.RingTheory.Invariant.Basic
import Mathlib.RingTheory.Adjoin.Tower
import Mathlib.AlgebraicGeometry.Morphisms.Finite
import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.Topology.Maps.Basic

/-!
# Affine finite-group quotients

For an affine scheme, the quotient by a finite group action is obtained from
the invariant subalgebra.  This file records the algebraic and affine-scheme
part of that construction.  It deliberately does not claim the non-affine
gluing theorem: an orbit-in-an-affine hypothesis and compatible overlap data
are still required there.
-/

set_option autoImplicit false

universe u v

open CategoryTheory
open AlgebraicGeometry
open scoped Pointwise

namespace MilneLib

section Invariants

variable {k A G : Type*} [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- The invariant subalgebra is an invariant extension of the original ring.
The witness is the defining fixed-point subtype, so no effectiveness claim is
hidden in this declaration. -/
theorem fixedSubalgebra_isInvariant :
    Algebra.IsInvariant (FixedPoints.subalgebra k A G) A G := by
  constructor
  intro a ha
  exact ⟨⟨a, ha⟩, rfl⟩

/-- A finite group makes the original affine algebra integral over its invariant
subalgebra. -/
theorem fixedSubalgebra_isIntegral [Finite G] :
    Algebra.IsIntegral (FixedPoints.subalgebra k A G) A := by
  letI : Algebra.IsInvariant (FixedPoints.subalgebra k A G) A G :=
    fixedSubalgebra_isInvariant
  exact Algebra.IsInvariant.isIntegral (FixedPoints.subalgebra k A G) A G

/-- If the original algebra is of finite type over the base, it is of finite
type over the invariant subalgebra.  This is the scalar-restriction step in
the affine quotient construction. -/
theorem fixedSubalgebra_finiteType [Algebra.FiniteType k A] :
    Algebra.FiniteType (FixedPoints.subalgebra k A G) A := by
  exact Algebra.FiniteType.of_restrictScalars_finiteType
    (R := k) (S := FixedPoints.subalgebra k A G) (A := A)

/-- The inclusion of the invariant subalgebra into a finite-type affine algebra
is a finite ring homomorphism. -/
theorem fixedSubalgebra_finite [Finite G] [Algebra.FiniteType k A] :
    (algebraMap (FixedPoints.subalgebra k A G) A).Finite := by
  letI : Algebra.IsIntegral (FixedPoints.subalgebra k A G) A :=
    fixedSubalgebra_isIntegral
  letI : Algebra.FiniteType (FixedPoints.subalgebra k A G) A :=
    fixedSubalgebra_finiteType
  exact RingHom.finite_algebraMap.mpr Algebra.IsIntegral.finite

/-- Artin--Tate shows that the invariant subalgebra is itself finite type over
the noetherian base.  Thus the affine quotient remains in the finite-type
category when the source does. -/
theorem fixedSubalgebra_finiteType_over_base [Finite G] [IsNoetherianRing k]
    [Algebra.FiniteType k A] :
    Algebra.FiniteType k (FixedPoints.subalgebra k A G) := by
  letI : Module.Finite (FixedPoints.subalgebra k A G) A :=
    RingHom.finite_algebraMap.mp fixedSubalgebra_finite
  constructor
  exact fg_of_fg_of_fg k (FixedPoints.subalgebra k A G) A
    Algebra.FiniteType.out Module.Finite.fg_top Subtype.val_injective

end Invariants

section AffineQuotient

variable {k A G : Type*} [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- The affine quotient map associated with a finite group action. -/
noncomputable def affineInvariantQuotientMap :
    Spec (CommRingCat.of A) ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k A G)) :=
  Spec.map (CommRingCat.ofHom (algebraMap (FixedPoints.subalgebra k A G) A))

/-- The affine quotient map is integral without any finite-type hypothesis on
the source algebra. -/
theorem affineInvariantQuotientMap_isIntegral [Finite G] :
    IsIntegralHom (affineInvariantQuotientMap (k := k) (A := A) (G := G)) := by
  unfold affineInvariantQuotientMap
  rw [IsIntegralHom.SpecMap_iff]
  exact algebraMap_isIntegral_iff.mpr fixedSubalgebra_isIntegral

/-- The affine quotient map is finite when the source algebra is finite type over
the base. -/
theorem affineInvariantQuotientMap_isFinite [Finite G] [Algebra.FiniteType k A] :
    IsFinite (affineInvariantQuotientMap (k := k) (A := A) (G := G)) := by
  unfold affineInvariantQuotientMap
  exact (IsFinite.SpecMap_iff _).2 fixedSubalgebra_finite

/-- The affine quotient map is surjective on points. -/
theorem affineInvariantQuotientMap_surjective [Finite G] :
    Function.Surjective
      (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base := by
  change Function.Surjective
    (PrimeSpectrum.comap (algebraMap (FixedPoints.subalgebra k A G) A))
  letI : Algebra.IsIntegral (FixedPoints.subalgebra k A G) A :=
    fixedSubalgebra_isIntegral
  exact Algebra.IsIntegral.comap_surjective _ _

/-- The topology on the affine invariant quotient is the quotient topology. -/
theorem affineInvariantQuotientMap_isQuotientMap [Finite G] :
    Topology.IsQuotientMap
      (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base := by
  letI : IsIntegralHom (affineInvariantQuotientMap (k := k) (A := A) (G := G)) :=
    affineInvariantQuotientMap_isIntegral
  exact (affineInvariantQuotientMap (k := k) (A := A) (G := G)).isClosedMap.isQuotientMap
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)).continuous
    affineInvariantQuotientMap_surjective

/-- Two points of the affine source have the same image precisely when their
prime ideals lie in the same finite-group orbit. -/
theorem affineInvariantQuotientMap_eq_iff_exists_smul [Finite G]
    (x y : PrimeSpectrum A) :
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base x =
        (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base y ↔
      ∃ g : G, y.asIdeal = g • x.asIdeal := by
  change PrimeSpectrum.comap (algebraMap (FixedPoints.subalgebra k A G) A) x =
      PrimeSpectrum.comap (algebraMap (FixedPoints.subalgebra k A G) A) y ↔ _
  letI : Algebra.IsInvariant (FixedPoints.subalgebra k A G) A G :=
    fixedSubalgebra_isInvariant
  constructor
  · intro h
    apply Algebra.IsInvariant.exists_smul_of_under_eq
      (FixedPoints.subalgebra k A G) A G x.asIdeal y.asIdeal
    simpa [Ideal.under_def] using congrArg PrimeSpectrum.asIdeal h
  · rintro ⟨g, hg⟩
    apply PrimeSpectrum.ext
    change x.asIdeal.under (FixedPoints.subalgebra k A G) =
      y.asIdeal.under (FixedPoints.subalgebra k A G)
    rw [hg, Ideal.under_smul]

end AffineQuotient

end MilneLib
