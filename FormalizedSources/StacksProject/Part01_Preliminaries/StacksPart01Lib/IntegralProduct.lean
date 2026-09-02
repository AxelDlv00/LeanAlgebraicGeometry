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

end StacksPart01
