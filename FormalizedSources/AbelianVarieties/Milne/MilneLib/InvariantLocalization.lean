/-
Copyright (c) 2026 The Milne Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Milne Contributors
-/

import Mathlib.RingTheory.Invariant.Basic
import Mathlib.RingTheory.Localization.Away.Basic

/-!
# Invariants and localization at an invariant element

For a finite group action on a commutative ring, a localization at an invariant
element is again acted on by the group.  The fixed elements of that localization
have representatives with invariant numerators.  This is the ring-level input
needed when affine finite-group quotient charts are compared on overlaps.

The action and the fixed subring are kept in this namespace rather than made
global instances: the action depends on the proof that the denominator is
invariant.  The comparison is first stated elementwise, then packaged as a
localization through an explicit, locally installed algebra structure.
-/

set_option autoImplicit false

namespace MilneLib
namespace InvariantLocalization

universe u v

variable {G : Type u} {A : Type v} [Group G] [CommRing A]
  [MulSemiringAction G A]

/-! ## The transported action -/

/-- Powers of an invariant denominator are preserved by the ring action. -/
theorem powers_le_comap (b : A) (hb : forall g : G, g • b = b) (g : G) :
    Submonoid.powers b ≤
      Submonoid.comap (MulSemiringAction.toRingHom G A g) (Submonoid.powers b) := by
  intro x hx
  obtain ⟨n, rfl⟩ := hx
  refine ⟨n, ?_⟩
  change b ^ n = g • (b ^ n)
  rw [smul_pow', hb g]

/-- The ring endomorphism induced on `A[1/b]` by an element of the group. -/
noncomputable def awayMap (b : A) (hb : forall g : G, g • b = b) (g : G) :
    Localization.Away b →+* Localization.Away b :=
  IsLocalization.map (M := Submonoid.powers b) (T := Submonoid.powers b)
    (Localization.Away b) (MulSemiringAction.toRingHom G A g) (powers_le_comap b hb g)

/-- `awayMap` acts on the image of the original ring by the given action. -/
@[simp]
theorem awayMap_algebraMap (b : A) (hb : forall g : G, g • b = b) (g : G) (a : A) :
    awayMap b hb g (algebraMap A (Localization.Away b) a) =
      algebraMap A (Localization.Away b) (g • a) :=
  IsLocalization.map_eq (powers_le_comap b hb g) a

/-- Composition of the transported maps agrees with multiplication in `G`. -/
theorem awayMap_comp_awayMap (b : A) (hb : forall g : G, g • b = b) (g h : G) :
    (awayMap b hb g).comp (awayMap b hb h) = awayMap b hb (g * h) := by
  refine IsLocalization.ringHom_ext (Submonoid.powers b) ?_
  ext a
  simp only [RingHom.comp_apply, awayMap_algebraMap]
  rw [mul_smul]

/-- The transported map at the identity is the identity map. -/
theorem awayMap_one (b : A) (hb : forall g : G, g • b = b) :
    awayMap b hb (1 : G) = RingHom.id (Localization.Away b) := by
  refine IsLocalization.ringHom_ext (Submonoid.powers b) ?_
  ext a
  simp only [RingHom.comp_apply, RingHom.id_apply, awayMap_algebraMap]
  rw [one_smul]

/-- The group action transported to `Localization.Away b`. -/
@[implicit_reducible]
noncomputable def awayMapMulSemiringAction (b : A) (hb : forall g : G, g • b = b) :
    MulSemiringAction G (Localization.Away b) where
  smul g x := awayMap b hb g x
  one_smul x := by
    change awayMap b hb (1 : G) x = x
    rw [awayMap_one b hb]
    rfl
  mul_smul g h x := by
    change awayMap b hb (g * h) x = awayMap b hb g (awayMap b hb h x)
    rw [← awayMap_comp_awayMap b hb g h]
    rfl
  smul_zero g := map_zero (awayMap b hb g)
  smul_add g x y := map_add (awayMap b hb g) x y
  smul_one g := map_one (awayMap b hb g)
  smul_mul g x y := map_mul (awayMap b hb g) x y

/-- The fixed subring of the localized action. -/
noncomputable def fixedAway (b : A) (hb : forall g : G, g • b = b) :
    Subring (Localization.Away b) := by
  letI := awayMapMulSemiringAction b hb
  exact FixedPoints.subring (Localization.Away b) G

/-- Membership in `fixedAway` means being fixed by every transported map. -/
theorem mem_fixedAway {b : A} {hb : forall g : G, g • b = b}
    {x : Localization.Away b} :
    x ∈ fixedAway b hb ↔ forall g : G, awayMap b hb g x = x :=
  Iff.rfl

/-! ## Invariant numerators and denominators -/

/-- The image of an invariant numerator is fixed in the localization. -/
theorem algebraMap_mem_fixedAway (b : A) (hb : forall g : G, g • b = b) {a : A}
    (ha : forall g : G, g • a = a) :
    algebraMap A (Localization.Away b) a ∈ fixedAway b hb := by
  refine mem_fixedAway.mpr fun g => ?_
  rw [awayMap_algebraMap b hb, ha g]

/-- A two-sided inverse of the image of an invariant denominator is fixed. -/
theorem inv_mem_fixedAway (b : A) (hb : forall g : G, g • b = b)
    (y : Localization.Away b)
    (hy : algebraMap A (Localization.Away b) b * y = 1) :
    y ∈ fixedAway b hb := by
  refine mem_fixedAway.mpr fun g => ?_
  have hbg : awayMap b hb g (algebraMap A (Localization.Away b) b) =
      algebraMap A (Localization.Away b) b := by
    rw [awayMap_algebraMap b hb, hb g]
  have hmul : algebraMap A (Localization.Away b) b * awayMap b hb g y = 1 := by
    rw [← hbg, ← map_mul, hy, map_one]
  calc
    awayMap b hb g y =
        (y * algebraMap A (Localization.Away b) b) * awayMap b hb g y := by
          rw [mul_comm y, hy, one_mul]
    _ = y * (algebraMap A (Localization.Away b) b * awayMap b hb g y) := by
          rw [mul_assoc]
    _ = y := by rw [hmul, mul_one]

/-- The image of the denominator is a unit of the fixed subring. -/
theorem isUnit_algebraMap_fixedAway (b : A) (hb : forall g : G, g • b = b) :
    IsUnit (⟨algebraMap A (Localization.Away b) b,
      algebraMap_mem_fixedAway b hb hb⟩ : fixedAway b hb) := by
  obtain ⟨v, hv⟩ := IsLocalization.Away.algebraMap_isUnit (S := Localization.Away b) b
  have hy : algebraMap A (Localization.Away b) b *
      ((v⁻¹ : (Localization.Away b)ˣ) : Localization.Away b) = 1 := by
    rw [← hv]
    exact v.mul_inv
  have hy' : ((v⁻¹ : (Localization.Away b)ˣ) : Localization.Away b) *
      algebraMap A (Localization.Away b) b = 1 := by
    rw [mul_comm]
    exact hy
  refine isUnit_iff_exists.mpr ⟨⟨_, inv_mem_fixedAway b hb _ hy⟩, ?_, ?_⟩
  · exact Subtype.ext hy
  · exact Subtype.ext hy'

/-! ## Clearing denominators -/

/-- A single equality in the localization can be cleared by a power of `b`. -/
theorem exists_pow_smul_eq (b a : A) (g : G)
    (h : algebraMap A (Localization.Away b) (g • a) =
      algebraMap A (Localization.Away b) a) :
    exists m : Nat, b ^ m * (g • a) = b ^ m * a := by
  obtain ⟨c, hc⟩ := IsLocalization.exists_of_eq (M := Submonoid.powers b) h
  obtain ⟨m, hm⟩ := c.2
  refine ⟨m, ?_⟩
  have hbc : (b ^ m : A) = (c : A) := hm
  rw [hbc]
  exact hc

/-- Finiteness of `G` gives one exponent clearing all group elements. -/
theorem exists_uniform_pow_smul_eq [Finite G] (b a : A)
    (h : forall g : G, exists m : Nat, b ^ m * (g • a) = b ^ m * a) :
    exists m : Nat, forall g : G, b ^ m * (g • a) = b ^ m * a := by
  classical
  cases nonempty_fintype G
  choose m hm using h
  refine ⟨Finset.univ.sup m, fun g => ?_⟩
  obtain ⟨k, hk⟩ : exists k, Finset.univ.sup m = m g + k :=
    ⟨Finset.univ.sup m - m g, by
      have hle : m g ≤ Finset.univ.sup m := Finset.le_sup (Finset.mem_univ g)
      omega⟩
  rw [hk, pow_add]
  calc
    b ^ m g * b ^ k * (g • a) = b ^ k * (b ^ m g * (g • a)) := by ring
    _ = b ^ k * (b ^ m g * a) := by rw [hm g]
    _ = b ^ m g * b ^ k * a := by ring

/-- Once all differences are cleared, the new numerator is genuinely invariant. -/
theorem smul_pow_mul_eq (b a : A) (m : Nat) (hb : forall g : G, g • b = b)
    (h : forall g : G, b ^ m * (g • a) = b ^ m * a) (g : G) :
    g • (b ^ m * a) = b ^ m * a := by
  rw [smul_mul', smul_pow', hb g, h g]

/-! ## The comparison theorem -/

/-- A fixed localized element has an invariant numerator after multiplying by a
power of the invariant denominator. -/
theorem exists_invariant_numerator [Finite G] (b : A) (hb : forall g : G, g • b = b)
    (x : Localization.Away b) (hx : forall g : G, awayMap b hb g x = x) :
    exists (a : A) (n : Nat), (forall g : G, g • a = a) ∧
      x * algebraMap A (Localization.Away b) (b ^ n) =
        algebraMap A (Localization.Away b) a := by
  classical
  obtain ⟨⟨a, d⟩, hxa⟩ := IsLocalization.surj (Submonoid.powers b) x
  obtain ⟨n, hn⟩ := d.2
  have hd : (d : A) = b ^ n := hn.symm
  have key : forall g : G, algebraMap A (Localization.Away b) (g • a) =
      algebraMap A (Localization.Away b) a := by
    intro g
    have h1 := congrArg (awayMap b hb g) hxa
    rw [map_mul, hx g, awayMap_algebraMap, awayMap_algebraMap] at h1
    rw [hd, smul_pow', hb g, ← hd] at h1
    rw [← h1, hxa]
  obtain ⟨m, hm⟩ := exists_uniform_pow_smul_eq b a
    (fun g => exists_pow_smul_eq b a g (key g))
  refine ⟨b ^ m * a, m + n, smul_pow_mul_eq b a m hb hm, ?_⟩
  have hx' : x * algebraMap A (Localization.Away b) (b ^ n) =
      algebraMap A (Localization.Away b) a := by
    rw [← hd]
    exact hxa
  rw [pow_add, map_mul, map_mul]
  calc
    x * (algebraMap A (Localization.Away b) (b ^ m) *
        algebraMap A (Localization.Away b) (b ^ n))
      = (x * algebraMap A (Localization.Away b) (b ^ n)) *
          algebraMap A (Localization.Away b) (b ^ m) := by ring
    _ = algebraMap A (Localization.Away b) a *
          algebraMap A (Localization.Away b) (b ^ m) := by rw [hx']
    _ = algebraMap A (Localization.Away b) (b ^ m) *
          algebraMap A (Localization.Away b) a := by ring

/-- The numerator theorem phrased using membership in the fixed subring. -/
theorem exists_invariant_num_den [Finite G] (b : A) (hb : forall g : G, g • b = b)
    (x : Localization.Away b) (hx : x ∈ fixedAway b hb) :
    exists (a : A) (n : Nat), (forall g : G, g • a = a) ∧
      x * algebraMap A (Localization.Away b) (b ^ n) =
        algebraMap A (Localization.Away b) a :=
  exists_invariant_numerator b hb x (mem_fixedAway.mp hx)

/-- Elementwise form of `(A[1/b])^G = (A^G)[1/b]`. -/
theorem mem_fixedAway_iff_exists_invariant_num [Finite G]
    (b : A) (hb : forall g : G, g • b = b) (x : Localization.Away b) :
    x ∈ fixedAway b hb ↔
      exists (a : A) (n : Nat), (forall g : G, g • a = a) ∧
        x * algebraMap A (Localization.Away b) (b ^ n) =
          algebraMap A (Localization.Away b) a := by
  refine ⟨exists_invariant_num_den b hb x, ?_⟩
  rintro ⟨a, n, ha, hxa⟩
  refine mem_fixedAway.mpr fun g => ?_
  have hunit : IsUnit (algebraMap A (Localization.Away b) (b ^ n)) := by
    rw [map_pow]
    exact IsLocalization.Away.algebraMap_pow_isUnit (S := Localization.Away b) b n
  refine hunit.mul_left_inj.mp ?_
  have hg := congrArg (awayMap b hb g) hxa
  rw [map_mul, awayMap_algebraMap, awayMap_algebraMap, smul_pow', hb g, ha g] at hg
  rw [hg, hxa]

/-! ## Localization of the invariant subalgebra -/

section FixedSubalgebra

variable {k : Type*} [CommRing k] [Algebra k A] [SMulCommClass G k A]

/-- The invariant subalgebra maps to the fixed subring after localization. -/
noncomputable def invariantToFixedAway (b : FixedPoints.subalgebra k A G) :
    FixedPoints.subalgebra k A G →+* fixedAway (b : A) b.property :=
  ((algebraMap A (Localization.Away (b : A))).comp
    (algebraMap (FixedPoints.subalgebra k A G) A)).codRestrict _
      (fun x => algebraMap_mem_fixedAway (b : A) b.property x.property)

/-- The algebra structure on the fixed localized ring induced by invariant numerators.
It is explicit because the target depends on the proof that `b` is invariant. -/
@[implicit_reducible]
noncomputable def fixedAwayAlgebra (b : FixedPoints.subalgebra k A G) :
    Algebra (FixedPoints.subalgebra k A G) (fixedAway (b : A) b.property) :=
  RingHom.toAlgebra (invariantToFixedAway b)

/-- The fixed subring of `A[1/b]` is a localization of the invariant subalgebra away from
`b`. -/
theorem fixedAway_isLocalization [Finite G] (b : FixedPoints.subalgebra k A G) :
    letI := fixedAwayAlgebra b
    IsLocalization.Away b (fixedAway (b : A) b.property) := by
  letI := fixedAwayAlgebra b
  apply IsLocalization.Away.mk b
  · change IsUnit (invariantToFixedAway b b)
    exact isUnit_algebraMap_fixedAway (b : A) b.property
  · intro x
    obtain ⟨a, n, ha, hx⟩ := exists_invariant_num_den
      (G := G) (b : A) b.property x.1 x.2
    refine ⟨n, ⟨a, ha⟩, ?_⟩
    apply Subtype.ext
    change x.1 * (algebraMap A (Localization.Away (b : A)) (b : A)) ^ n =
      algebraMap A (Localization.Away (b : A)) a
    simpa only [map_pow] using hx
  · intro a c h
    change invariantToFixedAway b a = invariantToFixedAway b c at h
    have h' : algebraMap A (Localization.Away (b : A)) (a : A) =
        algebraMap A (Localization.Away (b : A)) (c : A) :=
      congrArg Subtype.val h
    obtain ⟨n, hn⟩ := IsLocalization.Away.exists_of_eq
      (S := Localization.Away (b : A)) (x := (b : A)) h'
    exact ⟨n, Subtype.ext hn⟩

/-- The canonical ring equivalence `(A^G)[1/b] ≃ (A[1/b])^G`. -/
noncomputable def localizationAwayFixedRingEquiv [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    Localization.Away b ≃+* fixedAway (b : A) b.property := by
  letI := fixedAwayAlgebra b
  letI : IsLocalization.Away b (fixedAway (b : A) b.property) :=
    fixedAway_isLocalization b
  exact (IsLocalization.algEquiv (Submonoid.powers b) (Localization.Away b)
    (fixedAway (b : A) b.property)).toRingEquiv

/-- The localization equivalence sends invariant numerators to their images in the fixed
localized ring. -/
@[simp]
theorem localizationAwayFixedRingEquiv_algebraMap [Finite G]
    (b a : FixedPoints.subalgebra k A G) :
    localizationAwayFixedRingEquiv b
        (algebraMap (FixedPoints.subalgebra k A G) (Localization.Away b) a) =
      invariantToFixedAway b a := by
  letI := fixedAwayAlgebra b
  letI : IsLocalization.Away b (fixedAway (b : A) b.property) :=
    fixedAway_isLocalization b
  exact (IsLocalization.algEquiv (Submonoid.powers b) (Localization.Away b)
    (fixedAway (b : A) b.property)).commutes a

/-- Including the fixed localized ring into `A[1/b]` after the canonical equivalence is the
usual localization of the invariant-ring inclusion. -/
theorem fixedAway_subtype_comp_localizationAwayFixedRingEquiv [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    (fixedAway (b : A) b.property).subtype.comp
        (localizationAwayFixedRingEquiv b).toRingHom =
      Localization.awayMap
        (algebraMap (FixedPoints.subalgebra k A G) A) b := by
  refine IsLocalization.ringHom_ext (Submonoid.powers b) ?_
  ext a
  simp only [RingHom.comp_apply]
  change ((localizationAwayFixedRingEquiv b)
      (algebraMap (FixedPoints.subalgebra k A G) (Localization.Away b) a)).1 =
    Localization.awayMap (algebraMap (FixedPoints.subalgebra k A G) A) b
      (algebraMap (FixedPoints.subalgebra k A G) (Localization.Away b) a)
  rw [localizationAwayFixedRingEquiv_algebraMap]
  change algebraMap A (Localization.Away (b : A)) (a : A) = _
  rw [Localization.awayMap, IsLocalization.Away.map, IsLocalization.map_eq]
  rfl

/-- The localized invariant-ring inclusion followed by the inverse comparison is the
inclusion of the fixed subring into `A[1/b]`. -/
theorem awayMap_comp_localizationAwayFixedRingEquiv_symm [Finite G]
    (b : FixedPoints.subalgebra k A G) :
    (Localization.awayMap
        (algebraMap (FixedPoints.subalgebra k A G) A) b).comp
        (localizationAwayFixedRingEquiv b).symm.toRingHom =
      (fixedAway (b : A) b.property).subtype := by
  rw [← fixedAway_subtype_comp_localizationAwayFixedRingEquiv]
  ext x
  change ((localizationAwayFixedRingEquiv b)
    ((localizationAwayFixedRingEquiv b).symm x)).1 = x.1
  rw [RingEquiv.apply_symm_apply]

end FixedSubalgebra

end InvariantLocalization
end MilneLib
