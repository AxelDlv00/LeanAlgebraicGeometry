/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Coheight ↔ Krull dimension of stalk bridge

This file packages the project-side bridge between the **topological coheight**
of a scheme point and the **ring-theoretic Krull dimension** of its stalk. It
is the iter-183 Lane M deliverable per
`analogies/stacks-00tt-coheight.md` Decision 2, with blueprint chapter
`blueprint/src/chapters/Albanese_CoheightBridge.tex`.

The four declarations are:

1. `Order.coheight_eq_of_isOpenEmbedding` — for `X` a topological space and
   `U ⊆ X` open, `coheight z (in X) = coheight ⟨z, hz⟩ (in U)`.
2. `Order.coheight_spec_eq_height_primeSpectrum` — for `R` a `CommRingCat` and
   `p : Spec R`, `coheight p (in Spec R) = height ⟨p.asIdeal, p.isPrime⟩
   (in PrimeSpectrum R)`.
3. `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight` — the bridge:
   `ringKrullDim (X.presheaf.stalk z) = coheight z` for any scheme point.
4. `AlgebraicGeometry.Scheme.ringKrullDimLE_of_coheight_eq_one` — codim-1
   wrapper: `coheight z = 1 → Ring.KrullDimLE 1 (X.presheaf.stalk z)`.

The first three lemmas are natural Mathlib upstream candidates; the fourth is
the project-facing consumer wrapper used in
`Albanese/CodimOneExtension.lean` (`hreg_dim` Krull-dim conjunct) and
`RiemannRoch/WeilDivisor.lean` (`Scheme.RationalMap.order` instance argument).
-/

open Order TopologicalSpace AlgebraicGeometry CategoryTheory

universe u

-- The specialisation preorder is the relevant order structure on a
-- topological space throughout this file. Mathlib's `specializationPreorder`
-- is marked `instance_reducible` rather than a true typeclass instance; this
-- file makes it locally available for synthesis so `Order.coheight` etc.
-- elaborate on arbitrary topological spaces.
attribute [local instance] specializationPreorder

namespace Order

/-- **Open subsets preserve `Order.coheight`** for points of a topological
space carrying the specialisation preorder. -/
lemma coheight_eq_of_isOpenEmbedding
    {X : Type*} [TopologicalSpace X] {U : Set X} (hU : IsOpen U)
    (z : X) (hz : z ∈ U) :
    Order.coheight (α := X) z = Order.coheight (α := U) ⟨z, hz⟩ := by
  -- `Subtype.val : ↥U → X` is continuous, hence monotone for the spec
  -- preorder, and is injective; thus strictly monotone.
  have hSubMono : StrictMono (Subtype.val : U → X) :=
    (continuous_subtype_val.specialization_monotone).strictMono_of_injective
      Subtype.val_injective
  refine le_antisymm ?_ ?_
  · -- Reverse direction: coheight z (in X) ≤ coheight ⟨z,hz⟩ (in U).
    -- Every chain in X starting at z stays inside U by Specializes.mem_open.
    refine Order.coheight_le_iff'.mpr ?_
    intro p hphead
    -- Build the corresponding LTSeries in U.
    have hmem : ∀ i, p i ∈ U := by
      intro i
      -- p.head ≤ p i, and p.head = z, so z ≤ p i in spec preorder of X.
      -- The spec preorder le is `b ⤳ a`, so `z ≤ p i` means `p i ⤳ z`.
      have hle : z ≤ p i := by
        have := p.head_le i
        rwa [hphead] at this
      exact Specializes.mem_open (show p i ⤳ z from hle) hU hz
    -- Construct LTSeries in U via Subtype.val pullback.
    let q : LTSeries U :=
      { length := p.length
        toFun := fun i => ⟨p i, hmem i⟩
        step := by
          intro i
          -- Need ⟨p i.castSucc, _⟩ < ⟨p i.succ, _⟩ in U.
          have hlt : p i.castSucc < p i.succ := p.step i
          -- Strict ineq in subspace via Subtype.val injectivity + monotone.
          refine lt_of_le_of_ne ?_ (fun heq => hlt.ne (by
            have := congrArg (Subtype.val) heq
            simpa using this))
          -- `⟨p i.castSucc, _⟩ ≤ ⟨p i.succ, _⟩` in U: equivalent to
          -- `p i.succ ⤳ p i.castSucc` in U, which by subtype_specializes_iff
          -- equals `p i.succ ⤳ p i.castSucc` in X, equivalently `p i.castSucc
          -- ≤ p i.succ` in X.
          have hspec : (p i.succ) ⤳ (p i.castSucc) := hlt.le
          exact (subtype_specializes_iff (⟨p i.succ, hmem _⟩ : U)
            (⟨p i.castSucc, hmem _⟩ : U)).mpr hspec }
    have hqhead : q.head = ⟨z, hz⟩ := by
      apply Subtype.ext
      change p 0 = z
      have hp0 : p.head = z := hphead
      exact hp0
    have hlen : q.length = p.length := rfl
    have hbound := Order.length_le_coheight (x := (⟨z, hz⟩ : U)) (p := q)
      (by rw [hqhead])
    simpa [hlen] using hbound
  · -- Forward direction: coheight ⟨z, hz⟩ (in U) ≤ coheight z (in X).
    have h :=
      Order.coheight_le_coheight_apply_of_strictMono
        (Subtype.val : U → X) hSubMono ⟨z, hz⟩
    simpa using h

end Order

namespace Order

/-- **The specialisation preorder on `Spec R` is the dual of the inclusion
preorder on `PrimeSpectrum R`.** Coheight in `Spec R` equals height in
`PrimeSpectrum R`. -/
lemma coheight_spec_eq_height_primeSpectrum
    {R : CommRingCat} (p : Spec R) :
    Order.coheight (α := Spec R) p
      = Order.height (α := PrimeSpectrum R) ⟨p.asIdeal, p.isPrime⟩ := by
  -- The order iso `Spec R ≃o (PrimeSpectrum R)ᵒᵈ` built from `spec_le_iff`.
  let e : Spec R ≃o (PrimeSpectrum R)ᵒᵈ :=
    { toFun := fun p => OrderDual.toDual ⟨p.asIdeal, p.isPrime⟩
      invFun := fun q => (OrderDual.ofDual q : PrimeSpectrum R)
      left_inv := fun _ => rfl
      right_inv := fun _ => rfl
      map_rel_iff' := by
        intro a b
        -- After unfolding the dual order, this becomes
        -- `b.asIdeal ≤ a.asIdeal ↔ a ≤ b in Spec R`, i.e. `spec_le_iff`.
        exact (AlgebraicGeometry.spec_le_iff R a b).symm }
  have h1 : Order.coheight (α := (PrimeSpectrum R)ᵒᵈ) (e p) =
      Order.coheight (α := Spec R) p :=
    Order.coheight_orderIso e p
  rw [← h1]
  -- Now: coheight (in dual) of `e p` = height (in original) of `e p` (as
  -- bare element). Use the simp lemma `coheight_toDual`.
  -- `e p = OrderDual.toDual ⟨p.asIdeal, p.isPrime⟩`
  show Order.coheight (α := (PrimeSpectrum R)ᵒᵈ)
      (OrderDual.toDual (⟨p.asIdeal, p.isPrime⟩ : PrimeSpectrum R)) = _
  exact Order.coheight_toDual _

end Order

namespace AlgebraicGeometry

namespace Scheme

/-- **Coheight ↔ Krull dimension bridge for scheme points.** For any scheme
`X` and any point `z : X`, the Krull dimension of the stalk at `z` equals the
coheight of `z` in the underlying topological space (with the specialisation
preorder). -/
theorem ringKrullDim_stalk_eq_coheight
    (X : Scheme.{u}) (z : X) :
    ringKrullDim (X.presheaf.stalk z) = Order.coheight z := by
  -- Step 1: pick an affine open U ∋ z.
  obtain ⟨U, hU, hzU, _⟩ :=
    exists_isAffineOpen_mem_and_subset (X := X) (x := z) (U := ⊤)
      (by trivial)
  -- Step 2: name the prime corresponding to z inside U.
  set p : PrimeSpectrum Γ(X, U) := hU.primeIdealOf ⟨z, hzU⟩ with hp
  -- Step 3: stalk is the localisation of Γ(X,U) at p.
  haveI hloc : IsLocalization.AtPrime (X.presheaf.stalk z) p.asIdeal :=
    hU.isLocalization_stalk ⟨z, hzU⟩
  -- Step 4: ringKrullDim stalk = p.asIdeal.height (= primeHeight p).
  have h4 :
      ringKrullDim (X.presheaf.stalk z)
        = (Order.height (α := PrimeSpectrum Γ(X, U)) p : WithBot ℕ∞) := by
    rw [IsLocalization.AtPrime.ringKrullDim_eq_height
          (A := X.presheaf.stalk z) p.asIdeal,
        Ideal.height_eq_primeHeight]
    rfl
  -- Step 5: relate height(p) to coheight(z) using Decls 1 + 2 and the
  -- homeomorphism `Spec Γ(X,U) ≃ U.toScheme` from `hU.isoSpec`.
  -- First, coheight z in X = coheight ⟨z, hzU⟩ in U.
  have h1 : Order.coheight z = Order.coheight (α := (U.1 : Set X)) ⟨z, hzU⟩ :=
    Order.coheight_eq_of_isOpenEmbedding (X := X) (U := U.1)
      U.isOpen z hzU
  -- The scheme iso `hU.isoSpec : U.toScheme ≅ Spec Γ(X,U)` is a Scheme iso;
  -- on carriers it's a homeomorphism, giving an OrderIso of spec preorders.
  let hHomeo : U.toScheme ≃ₜ Spec Γ(X, U) :=
    TopCat.homeoOfIso (Scheme.forgetToTop.mapIso hU.isoSpec)
  let eOrder : U.toScheme ≃o Spec Γ(X, U) :=
    { toEquiv := hHomeo.toEquiv
      map_rel_iff' := by
        intro a b
        constructor
        · -- h : hHomeo a ≤ hHomeo b means hHomeo b ⤳ hHomeo a in Spec.
          -- Apply hHomeo.symm continuous to get b ⤳ a in U.toScheme.
          intro h
          have hsp : hHomeo b ⤳ hHomeo a := h
          have := hsp.map hHomeo.symm.continuous
          rw [hHomeo.symm_apply_apply, hHomeo.symm_apply_apply] at this
          exact (this : a ≤ b)
        · intro h
          have hsp : b ⤳ a := h
          exact (hsp.map hHomeo.continuous : hHomeo a ≤ hHomeo b) }
  -- coheight U.toScheme ⟨z, hzU⟩ = coheight (Spec Γ(X,U)) (eOrder ⟨z, hzU⟩)
  have h2 : Order.coheight (α := U.toScheme) ⟨z, hzU⟩
      = Order.coheight (α := Spec Γ(X, U)) (eOrder ⟨z, hzU⟩) :=
    (Order.coheight_orderIso eOrder ⟨z, hzU⟩).symm
  have h3 : eOrder ⟨z, hzU⟩ = p := rfl
  -- Decl 2: coheight (Spec R) p = height (PrimeSpectrum R) p.
  have h6 : Order.coheight (α := Spec Γ(X, U)) p
      = Order.height (α := PrimeSpectrum Γ(X, U))
          ⟨p.asIdeal, p.isPrime⟩ :=
    Order.coheight_spec_eq_height_primeSpectrum p
  have h7 : (⟨p.asIdeal, p.isPrime⟩ : PrimeSpectrum Γ(X, U)) = p := rfl
  -- coheight U.1-subspace = coheight U.toScheme (defeq).
  have h8 : Order.coheight (α := (U.1 : Set X)) ⟨z, hzU⟩
      = Order.coheight (α := U.toScheme) ⟨z, hzU⟩ := rfl
  -- Assemble.
  rw [h4, h1, h8, h2, h3, h6, h7]

end Scheme

end AlgebraicGeometry

namespace AlgebraicGeometry

namespace Scheme

/-- **Codim-1 wrapper: coheight = 1 ⟹ stalk Krull dim ≤ 1.** Consumer-facing
specialisation of `ringKrullDim_stalk_eq_coheight` for the codim-`1` case used
in `Albanese/CodimOneExtension.lean` and `RiemannRoch/WeilDivisor.lean`. -/
lemma ringKrullDimLE_of_coheight_eq_one
    (X : Scheme.{u}) (z : X) (hz : Order.coheight z = 1) :
    Ring.KrullDimLE 1 (X.presheaf.stalk z) := by
  rw [Ring.krullDimLE_iff, ringKrullDim_stalk_eq_coheight, hz]
  -- Goal: ((1 : ℕ∞) : WithBot ℕ∞) ≤ ((1 : ℕ) : WithBot ℕ∞)
  norm_cast

end Scheme

end AlgebraicGeometry
