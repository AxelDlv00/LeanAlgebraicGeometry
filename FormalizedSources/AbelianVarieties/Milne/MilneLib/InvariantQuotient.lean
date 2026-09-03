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

section SpectrumAction

variable (G : Type*) [Group G] (A : Type u) [CommRing A]
  [MulSemiringAction G A]

lemma specAction_toRingHom_comp (g h : G) :
    (MulSemiringAction.toRingHom G A g).comp
        (MulSemiringAction.toRingHom G A h) =
      MulSemiringAction.toRingHom G A (g * h) :=
  RingHom.ext fun x => (mul_smul g h x).symm

lemma specAction_toRingHom_one :
    MulSemiringAction.toRingHom G A (1 : G) = RingHom.id A :=
  RingHom.ext fun x => one_smul G x

/-- A ring action induces an action on its spectrum.  The inverse compensates
for the contravariance of `Spec`, making this a group homomorphism. -/
noncomputable def specAction : G →* Aut (Spec (CommRingCat.of A)) :=
  MonoidHom.mk'
    (fun g =>
      { hom := Spec.map
          (CommRingCat.ofHom (MulSemiringAction.toRingHom G A g⁻¹))
        inv := Spec.map
          (CommRingCat.ofHom (MulSemiringAction.toRingHom G A g))
        hom_inv_id := by
          rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, specAction_toRingHom_comp,
            inv_mul_cancel, specAction_toRingHom_one, CommRingCat.ofHom_id, Spec.map_id]
        inv_hom_id := by
          rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, specAction_toRingHom_comp,
            mul_inv_cancel, specAction_toRingHom_one, CommRingCat.ofHom_id, Spec.map_id] })
    (fun g h => by
      refine Iso.ext ?_
      change Spec.map
          (CommRingCat.ofHom
            (MulSemiringAction.toRingHom G A (g * h)⁻¹)) =
        Spec.map
            (CommRingCat.ofHom
              (MulSemiringAction.toRingHom G A h⁻¹)) ≫
          Spec.map
            (CommRingCat.ofHom
              (MulSemiringAction.toRingHom G A g⁻¹))
      rw [← Spec.map_comp, ← CommRingCat.ofHom_comp, specAction_toRingHom_comp,
        ← mul_inv_rev])

lemma specAction_hom (g : G) :
    (specAction G A g).hom =
      Spec.map
        (CommRingCat.ofHom (MulSemiringAction.toRingHom G A g⁻¹)) :=
  rfl

/-- On prime ideals, the induced spectrum action agrees with pointwise
transport by the group action. -/
theorem specAction_hom_base_asIdeal (g : G) (x : PrimeSpectrum A) :
    ((specAction G A g).hom.base x).asIdeal = g • x.asIdeal := by
  rw [specAction_hom]
  change (PrimeSpectrum.comap (MulSemiringAction.toRingHom G A g⁻¹) x).asIdeal = _
  rw [PrimeSpectrum.comap_asIdeal, Ideal.pointwise_smul_eq_comap]
  rfl

end SpectrumAction

section AffineMap

variable {k A G : Type*} [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A]

/-- The affine quotient map associated with a finite group action. -/
noncomputable def affineInvariantQuotientMap :
    Spec (CommRingCat.of A) ⟶
      Spec (CommRingCat.of (FixedPoints.subalgebra k A G)) :=
  Spec.map (CommRingCat.ofHom (algebraMap (FixedPoints.subalgebra k A G) A))

end AffineMap

section AffineUniversal

variable {k A G B : Type u} [CommRing k] [CommRing A] [Algebra k A]
  [Group G] [MulSemiringAction G A] [SMulCommClass G k A] [CommRing B]

/-- The ring map induced by an invariant map factors through the fixed
subalgebra. -/
def invariantRingHomLift (phi : B →+* A)
    (hphi : ∀ (g : G) (b : B), g • phi b = phi b) :
    B →+* FixedPoints.subalgebra k A G :=
  let hmem : ∀ b : B, phi b ∈ FixedPoints.subalgebra k A G := fun b => by
    change ∀ g : G, g • phi b = phi b
    exact fun g => hphi g b
  phi.codRestrict (FixedPoints.subalgebra k A G) hmem

@[simp]
theorem invariantRingHomLift_coe (phi : B →+* A)
    (hphi : ∀ (g : G) (b : B), g • phi b = phi b) (b : B) :
    (invariantRingHomLift (k := k) (G := G) phi hphi b : A) = phi b := by
  unfold invariantRingHomLift
  exact RingHom.codRestrict_apply phi (FixedPoints.subalgebra k A G) _ b

/-- The affine invariant quotient has the universal factorization property for
invariant maps from affine schemes. -/
theorem affineInvariantQuotientMap_existsUnique_factor
    (phi : B →+* A)
    (hphi : ∀ (g : G) (b : B), g • phi b = phi b) :
  ∃! u : Spec (CommRingCat.of (FixedPoints.subalgebra k A G)) ⟶
        Spec (CommRingCat.of B),
      affineInvariantQuotientMap (k := k) (A := A) (G := G) ≫ u =
        Spec.map (CommRingCat.ofHom phi) := by
  let ψ := invariantRingHomLift (k := k) (G := G) phi hphi
  refine ⟨Spec.map (CommRingCat.ofHom ψ), ?_, ?_⟩
  · change Spec.map (CommRingCat.ofHom (algebraMap (FixedPoints.subalgebra k A G) A)) ≫
      Spec.map (CommRingCat.ofHom ψ) = Spec.map (CommRingCat.ofHom phi)
    rw [← Spec.map_comp, ← CommRingCat.ofHom_comp]
    rw [Spec.map_inj (φ := CommRingCat.ofHom
      ((algebraMap (FixedPoints.subalgebra k A G) A).comp ψ))
      (ψ := CommRingCat.ofHom phi)]
    ext b
    change (invariantRingHomLift (k := k) (G := G) phi hphi b : A) = phi b
    exact invariantRingHomLift_coe (k := k) (G := G) phi hphi b
  · intro u hu
    obtain ⟨χ, rfl⟩ := Spec.map_surjective u
    rw [Spec.map_inj]
    apply CommRingCat.hom_ext
    ext b
    change ((χ.hom b : FixedPoints.subalgebra k A G) : A) = phi b
    unfold affineInvariantQuotientMap at hu
    rw [← Spec.map_comp, Spec.map_inj] at hu
    have hcomp := congrArg CommRingCat.Hom.hom hu
    exact DFunLike.congr_fun hcomp b

end AffineUniversal

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

/-- The action on the affine source is constant along the invariant-ring
projection. -/
@[reassoc]
theorem specAction_hom_affineInvariantQuotientMap (g : G) :
    (specAction G A g).hom ≫
        affineInvariantQuotientMap (k := k) (A := A) (G := G) =
      affineInvariantQuotientMap (k := k) (A := A) (G := G) := by
  unfold affineInvariantQuotientMap
  rw [specAction_hom, ← Spec.map_comp, ← CommRingCat.ofHom_comp]
  congr 2
  ext x
  exact x.property g⁻¹

/-- Basic opens cut out by invariant elements are stable under the spectrum
action.  This is the localization identity used when comparing affine
quotient charts on overlaps. -/
theorem specAction_preimage_basicOpen_fixed (a : FixedPoints.subalgebra k A G) (g : G) :
    (specAction G A g).hom ⁻¹ᵁ
        (PrimeSpectrum.basicOpen (a : A) :
          (Spec (CommRingCat.of A)).Opens) =
      PrimeSpectrum.basicOpen (a : A) := by
  rw [specAction_hom, AlgebraicGeometry.SpecMap_preimage_basicOpen]
  change PrimeSpectrum.basicOpen (g⁻¹ • (a : A)) =
    PrimeSpectrum.basicOpen (a : A)
  rw [show g⁻¹ • (a : A) = (a : A) from a.property g⁻¹]

/-- The affine invariant quotient map pulls a basic open of an invariant
element back to the corresponding basic open on the source. -/
theorem affineInvariantQuotientMap_preimage_basicOpen_fixed
    (a : FixedPoints.subalgebra k A G) :
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)) ⁻¹ᵁ
        (PrimeSpectrum.basicOpen a :
          (Spec (CommRingCat.of (FixedPoints.subalgebra k A G))).Opens) =
      PrimeSpectrum.basicOpen (a : A) := by
  rw [affineInvariantQuotientMap, AlgebraicGeometry.SpecMap_preimage_basicOpen]
  rfl

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

/-- The fibers of the affine invariant quotient are exactly the orbits of the
induced action on `Spec A`. -/
theorem affineInvariantQuotientMap_eq_iff_exists_specAction [Finite G]
    (x y : PrimeSpectrum A) :
    (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base x =
        (affineInvariantQuotientMap (k := k) (A := A) (G := G)).base y ↔
      ∃ g : G, (specAction G A g).hom.base x = y := by
  rw [affineInvariantQuotientMap_eq_iff_exists_smul]
  constructor
  · rintro ⟨g, hg⟩
    refine ⟨g, PrimeSpectrum.ext ?_⟩
    rw [specAction_hom_base_asIdeal]
    exact hg.symm
  · rintro ⟨g, hg⟩
    refine ⟨g, ?_⟩
    have := congrArg PrimeSpectrum.asIdeal hg
    rw [specAction_hom_base_asIdeal] at this
    exact this.symm

end AffineQuotient

end MilneLib
