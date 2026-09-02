/-
Copyright (c) 2026 The StacksPart01Lib authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The StacksPart01Lib Contributors
-/

import StacksPart01Lib.Integral
import Mathlib.Algebra.Polynomial.Lifts
import Mathlib.Algebra.Ring.Prod

/-!
# Integral elements in finite products

The source allows the component maps to have different base rings.  The
surjective-base helper below supplies the coefficient-lifting step needed to
reduce that statement to Mathlib's product-algebra theorem.
-/

namespace StacksPart01

open Polynomial

/-! A monic witness can be lifted across a surjective base map. -/

theorem integralElem_comp_surjective_iff
    {R R' S : Type*} [CommRing R] [CommRing R'] [Ring S]
    (g : R →+* R') (hg : Function.Surjective g) (f : R' →+* S) {x : S} :
    (f.comp g).IsIntegralElem x ↔ f.IsIntegralElem x := by
  constructor
  · exact RingHom.IsIntegralElem.of_comp
  · rintro ⟨p, hp, hx⟩
    obtain ⟨q, hq, _, hqm⟩ :=
      Polynomial.lifts_and_natDegree_eq_and_monic
        (Polynomial.mem_lifts_of_surjective hg p) hp
    refine ⟨q, hqm, ?_⟩
    rw [← Polynomial.eval₂_map g f x, hq]
    exact hx

/-! [Stacks tag 0CY8] -/

/-- For componentwise ring maps, integrality in a binary product is
equivalent to integrality in each component. -/
theorem isIntegralElem_prodMap_iff
    {R₁ R₂ S₁ S₂ : Type*}
    [CommRing R₁] [CommRing R₂] [CommRing S₁] [CommRing S₂]
    (f₁ : R₁ →+* S₁) (f₂ : R₂ →+* S₂) (x₁ : S₁) (x₂ : S₂) :
    (RingHom.prodMap f₁ f₂).IsIntegralElem (x₁, x₂) ↔
      f₁.IsIntegralElem x₁ ∧ f₂.IsIntegralElem x₂ := by
  let g₁ : (R₁ × R₂) →+* S₁ := f₁.comp (RingHom.fst R₁ R₂)
  let g₂ : (R₁ × R₂) →+* S₂ := f₂.comp (RingHom.snd R₁ R₂)
  letI : Algebra (R₁ × R₂) S₁ := g₁.toAlgebra
  letI : Algebra (R₁ × R₂) S₂ := g₂.toAlgebra
  have halg : algebraMap (R₁ × R₂) (S₁ × S₂) = RingHom.prod g₁ g₂ := by
    ext r <;> rfl
  have hpair :
      (RingHom.prod g₁ g₂).IsIntegralElem (x₁, x₂) ↔
        g₁.IsIntegralElem x₁ ∧ g₂.IsIntegralElem x₂ := by
    rw [← halg]
    exact IsIntegral.pair_iff
  have hfst : Function.Surjective (RingHom.fst R₁ R₂) := by
    intro r
    exact ⟨(r, 0), rfl⟩
  have hsnd : Function.Surjective (RingHom.snd R₁ R₂) := by
    intro r
    exact ⟨(0, r), rfl⟩
  have h₁ : g₁.IsIntegralElem x₁ ↔ f₁.IsIntegralElem x₁ := by
    exact integralElem_comp_surjective_iff (RingHom.fst R₁ R₂) hfst f₁
  have h₂ : g₂.IsIntegralElem x₂ ↔ f₂.IsIntegralElem x₂ := by
    exact integralElem_comp_surjective_iff (RingHom.snd R₁ R₂) hsnd f₂
  rw [show f₁.prodMap f₂ = RingHom.prod g₁ g₂ by ext r <;> rfl, hpair, h₁, h₂]

/-! The map-level form packages the elementwise product criterion. -/

/-- A componentwise product map is integral exactly when both components are. -/
theorem ringHom_isIntegral_prodMap_iff
    {R₁ R₂ S₁ S₂ : Type*}
    [CommRing R₁] [CommRing R₂] [CommRing S₁] [CommRing S₂]
    (f₁ : R₁ →+* S₁) (f₂ : R₂ →+* S₂) :
    (f₁.prodMap f₂).IsIntegral ↔ f₁.IsIntegral ∧ f₂.IsIntegral := by
  constructor
  · intro h
    constructor
    · intro x
      exact ((isIntegralElem_prodMap_iff f₁ f₂ x 0).mp (h (x, 0))).1
    · intro y
      exact ((isIntegralElem_prodMap_iff f₁ f₂ 0 y).mp (h (0, y))).2
  · rintro ⟨h₁, h₂⟩ x
    exact (isIntegralElem_prodMap_iff f₁ f₂ x.1 x.2).mpr ⟨h₁ x.1, h₂ x.2⟩

/-! [Stacks tag 0CY9] -/

/-- Membership in the integral closure of a binary product is componentwise. -/
theorem mem_integralClosure_prodMap_iff
    {R₁ R₂ S₁ S₂ : Type*}
    [CommRing R₁] [CommRing R₂] [CommRing S₁] [CommRing S₂]
    (f₁ : R₁ →+* S₁) (f₂ : R₂ →+* S₂) (x : S₁ × S₂) :
    x ∈ @integralClosure (R₁ × R₂) (S₁ × S₂) _ _ (f₁.prodMap f₂).toAlgebra ↔
      x.1 ∈ @integralClosure R₁ S₁ _ _ f₁.toAlgebra ∧
        x.2 ∈ @integralClosure R₂ S₂ _ _ f₂.toAlgebra := by
  rw [@mem_integralClosure_iff (R₁ × R₂) (S₁ × S₂) _ _ (f₁.prodMap f₂).toAlgebra,
    @mem_integralClosure_iff R₁ S₁ _ _ f₁.toAlgebra,
    @mem_integralClosure_iff R₂ S₂ _ _ f₂.toAlgebra]
  exact isIntegralElem_prodMap_iff f₁ f₂ x.1 x.2

/-- The integral closure for a binary product map is the product of the two
component integral closures, viewed as subrings. -/
theorem integralClosure_prodMap_toSubring
    {R₁ R₂ S₁ S₂ : Type*}
    [CommRing R₁] [CommRing R₂] [CommRing S₁] [CommRing S₂]
    (f₁ : R₁ →+* S₁) (f₂ : R₂ →+* S₂) :
    @Subalgebra.toSubring (R₁ × R₂) (S₁ × S₂) _ _
        (f₁.prodMap f₂).toAlgebra
        (@integralClosure (R₁ × R₂) (S₁ × S₂) _ _ (f₁.prodMap f₂).toAlgebra) =
      (@Subalgebra.toSubring R₁ S₁ _ _ f₁.toAlgebra
          (@integralClosure R₁ S₁ _ _ f₁.toAlgebra)).prod
        (@Subalgebra.toSubring R₂ S₂ _ _ f₂.toAlgebra
          (@integralClosure R₂ S₂ _ _ f₂.toAlgebra)) := by
  apply Subring.ext
  intro x
  exact mem_integralClosure_prodMap_iff f₁ f₂ x

/-- A binary product extension is integrally closed exactly when both
component extensions are integrally closed. -/
theorem isIntegrallyClosedIn_prodMap_iff
    {R₁ R₂ S₁ S₂ : Type*}
    [CommRing R₁] [CommRing R₂] [CommRing S₁] [CommRing S₂]
    (f₁ : R₁ →+* S₁) (f₂ : R₂ →+* S₂) :
    @IsIntegrallyClosedIn (R₁ × R₂) (S₁ × S₂) _ _ (f₁.prodMap f₂).toAlgebra ↔
      @IsIntegrallyClosedIn R₁ S₁ _ _ f₁.toAlgebra ∧
        @IsIntegrallyClosedIn R₂ S₂ _ _ f₂.toAlgebra := by
  rw [@isIntegrallyClosedIn_iff (R₁ × R₂) _ (S₁ × S₂) _ (f₁.prodMap f₂).toAlgebra,
    @isIntegrallyClosedIn_iff R₁ _ S₁ _ f₁.toAlgebra,
    @isIntegrallyClosedIn_iff R₂ _ S₂ _ f₂.toAlgebra]
  constructor
  · rintro ⟨hinj, hclosed⟩
    constructor
    · constructor
      · intro x y hxy
        have hprod : f₁.prodMap f₂ (x, 0) = f₁.prodMap f₂ (y, 0) := by
          exact Prod.ext hxy rfl
        exact congrArg Prod.fst (hinj hprod)
      · intro x hx
        have hprod : (f₁.prodMap f₂).IsIntegralElem (x, 0) :=
          (isIntegralElem_prodMap_iff f₁ f₂ x 0).mpr
            ⟨hx, RingHom.isIntegralElem_zero f₂⟩
        obtain ⟨y, hy⟩ := hclosed hprod
        exact ⟨y.1, congrArg Prod.fst hy⟩
    · constructor
      · intro x y hxy
        have hprod : f₁.prodMap f₂ (0, x) = f₁.prodMap f₂ (0, y) := by
          exact Prod.ext rfl hxy
        exact congrArg Prod.snd (hinj hprod)
      · intro x hx
        have hprod : (f₁.prodMap f₂).IsIntegralElem (0, x) :=
          (isIntegralElem_prodMap_iff f₁ f₂ 0 x).mpr
            ⟨RingHom.isIntegralElem_zero f₁, hx⟩
        obtain ⟨y, hy⟩ := hclosed hprod
        exact ⟨y.2, congrArg Prod.snd hy⟩
  · rintro ⟨⟨hinj₁, hclosed₁⟩, ⟨hinj₂, hclosed₂⟩⟩
    constructor
    · intro x y hxy
      apply Prod.ext
      · exact hinj₁ (congrArg Prod.fst hxy)
      · exact hinj₂ (congrArg Prod.snd hxy)
    · intro x hx
      have hcomponents := (isIntegralElem_prodMap_iff f₁ f₂ x.1 x.2).mp hx
      obtain ⟨y₁, hy₁⟩ := hclosed₁ hcomponents.1
      obtain ⟨y₂, hy₂⟩ := hclosed₂ hcomponents.2
      exact ⟨(y₁, y₂), Prod.ext hy₁ hy₂⟩

end StacksPart01
