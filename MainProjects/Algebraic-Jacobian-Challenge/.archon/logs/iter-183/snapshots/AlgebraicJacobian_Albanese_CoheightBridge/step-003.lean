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
-- topological space throughout this file. Mathlib's
-- `specializationPreorder` is marked `instance_reducible` rather than a
-- typeclass instance; this file makes it locally available for synthesis.
attribute [local instance] specializationPreorder

namespace Order

/-- **Open subsets preserve `Order.coheight`** for points of a topological
space carrying the specialisation preorder. The forward bound uses strict
monotonicity of `Subtype.val`; the reverse uses the fact that every
generisation of a point in an open set lies in that open set
(`Specializes.mem_open`). -/
lemma coheight_eq_of_isOpenEmbedding
    {X : Type*} [TopologicalSpace X] {U : Set X} (hU : IsOpen U)
    (z : X) (hz : z ∈ U) :
    Order.coheight (α := X) z = Order.coheight (α := U) ⟨z, hz⟩ := by
  -- `Subtype.val : U → X` is strictly monotone in the spec preorder.
  have hSubMono : StrictMono (Subtype.val : U → X) := by
    intro a b hab
    refine lt_iff_le_not_ge.mpr ⟨?_, ?_⟩
    · -- a.val ≤ b.val in X (spec preorder) follows from a ≤ b in U via
      -- subtype_specializes_iff applied to ⟨b.val ⤳ a.val (in U)⟩.
      exact (subtype_specializes_iff b a).mp hab.le
    · intro h
      exact hab.not_ge ((subtype_specializes_iff a b).mpr h)
  refine le_antisymm ?_ ?_
  · -- Reverse direction: coheight z (in X) ≤ coheight ⟨z,hz⟩ (in U).
    -- Every chain in X starting at z stays inside U by Specializes.mem_open.
    refine Order.coheight_le_iff'.mpr ?_
    intro p hphead
    -- Membership: every p i is in U because z ≤ p i (in spec preorder)
    -- means `p i ⤳ z`, so `p i ∈ U` since `z ∈ U` and `U` open.
    have hmem : ∀ i, p i ∈ U := by
      intro i
      have hle : z ≤ p i := by
        have := p.head_le i
        rwa [hphead] at this
      -- `z ≤ p i` in spec preorder is `p i ⤳ z`.
      exact Specializes.mem_open (hle : p i ⤳ z) hU hz
    -- Build the corresponding LTSeries in U.
    let q : LTSeries U :=
      LTSeries.mk p.length (fun i => ⟨p i, hmem i⟩) (by
        intro i j hij
        refine lt_iff_le_not_ge.mpr ⟨?_, ?_⟩
        · -- ⟨p i, _⟩ ≤ ⟨p j, _⟩ in U via subtype_specializes_iff.
          exact (subtype_specializes_iff _ _).mpr
            ((p.strictMono hij).le : (p j) ⤳ (p i))
        · intro h
          exact (p.strictMono hij).not_ge
            ((subtype_specializes_iff _ _).mp h))
    have hqhead : q.head = ⟨z, hz⟩ := by
      apply Subtype.ext
      change p 0 = z
      have : p.head = z := hphead
      exact this
    have hlen : q.length = p.length := rfl
    -- length p ≤ coheight ⟨z, hz⟩ via length_le_coheight on q.
    have := Order.length_le_coheight (x := (⟨z, hz⟩ : U)) (p := q) (by
      rw [hqhead])
    simpa [hlen] using this
  · -- Forward direction: coheight ⟨z, hz⟩ (in U) ≤ coheight z (in X).
    -- Follows from `Subtype.val` being strict-mono (so coheight goes up).
    have := Order.coheight_le_coheight_apply_of_strictMono
      (Subtype.val : U → X) hSubMono ⟨z, hz⟩
    simpa using this

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
        -- Goal: e a ≤ e b ↔ a ≤ b. After unfolding the dual order,
        -- this becomes b.asIdeal ≤ a.asIdeal ↔ a ≤ b in Spec R,
        -- which is exactly `spec_le_iff`.
        exact (AlgebraicGeometry.spec_le_iff R a b).symm }
  -- `coheight_orderIso` transports coheight along the iso, then
  -- `coheight (αᵒᵈ) x = height α x` reduces to `height`.
  have h1 : Order.coheight (α := (PrimeSpectrum R)ᵒᵈ) (e p) =
      Order.coheight (α := Spec R) p :=
    Order.coheight_orderIso e p
  rw [← h1]
  -- coheight in OrderDual = height in original.
  exact (Order.coheight_ofDual (e p) :)

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
  haveI : IsLocalization.AtPrime (X.presheaf.stalk z) p.asIdeal :=
    hU.isLocalization_stalk ⟨z, hzU⟩
  -- Step 4: ringKrullDim stalk = p.asIdeal.height = primeHeight p.
  rw [IsLocalization.AtPrime.ringKrullDim_eq_height p.asIdeal (X.presheaf.stalk z),
      Ideal.height_eq_primeHeight]
  -- Now goal is `(p.asIdeal.primeHeight : WithBot ℕ∞) = Order.coheight z`.
  -- By definition, `p.asIdeal.primeHeight = Order.height (p : PrimeSpectrum _)`.
  change (Order.height (α := PrimeSpectrum Γ(X, U)) p : WithBot ℕ∞) =
      Order.coheight z
  -- Step 5: relate height(p) to coheight(z) using Decls 1 + 2 and the
  -- homeomorphism `Spec Γ(X,U) ≃ U.toScheme` from `hU.isoSpec`.
  -- First, coheight z in X = coheight ⟨z, hzU⟩ in U.
  have h1 : Order.coheight z = Order.coheight (α := U.1) ⟨z, hzU⟩ :=
    Order.coheight_eq_of_isOpenEmbedding (X := X) (U := U.1)
      U.isOpen z hzU
  -- Next, coheight ⟨z, hzU⟩ (in U.subspace) = coheight ⟨z, hzU⟩ (in U.toScheme).
  -- These are the same Type, so the equality is rfl.
  -- Then, coheight on U.toScheme = coheight on Spec Γ(X,U) via the scheme iso.
  -- The scheme iso `hU.isoSpec : U.toScheme ≅ Spec Γ(X,U)` is a Scheme iso,
  -- giving a homeomorphism on carriers, hence an OrderIso of spec preorders.
  let hHomeo : U.toScheme ≃ₜ Spec Γ(X, U) :=
    TopCat.homeoOfIso (Scheme.forgetToTop.mapIso hU.isoSpec)
  -- Specialisations are preserved by homeomorphisms, so we get an OrderIso.
  let eOrder : U.toScheme ≃o Spec Γ(X, U) :=
    { hHomeo with
      map_rel_iff' := by
        intro a b
        -- `a ≤ b ↔ b ⤳ a` in spec preorder; homeomorphism preserves ⤳.
        refine Iff.intro (fun h => ?_) (fun h => ?_)
        · -- h : hHomeo a ≤ hHomeo b in spec preorder of Spec.
          -- i.e. hHomeo b ⤳ hHomeo a.
          -- Apply hHomeo.symm continuous: get b ⤳ a, i.e. a ≤ b.
          have := (h : hHomeo b ⤳ hHomeo a)
          have hh : b ⤳ a := by
            have heq1 := hHomeo.symm_apply_apply a
            have heq2 := hHomeo.symm_apply_apply b
            have := this.map hHomeo.symm.continuous
            rwa [heq1, heq2] at this
          exact (hh : a ≤ b)
        · -- h : a ≤ b in spec preorder of U.toScheme = b ⤳ a.
          -- Apply hHomeo continuous: hHomeo b ⤳ hHomeo a, i.e. hHomeo a ≤ hHomeo b.
          exact ((h : b ⤳ a).map hHomeo.continuous : hHomeo a ≤ hHomeo b) }
  have h2 : Order.coheight (α := U.toScheme) ⟨z, hzU⟩
      = Order.coheight (α := Spec Γ(X, U)) (eOrder ⟨z, hzU⟩) :=
    (Order.coheight_orderIso eOrder ⟨z, hzU⟩).symm
  -- The image `eOrder ⟨z, hzU⟩` equals `p`.
  have h3 : eOrder ⟨z, hzU⟩ = p := by
    -- eOrder = hHomeo as a function = isoSpec.hom as a TopCat morphism
    -- and isoSpec.hom ⟨z, hzU⟩ = hU.primeIdealOf ⟨z, hzU⟩ by definition.
    rfl
  -- Decl 2: coheight (Spec R) p = height (PrimeSpectrum R) p.
  have h4 : Order.coheight (α := Spec Γ(X, U)) p
      = Order.height (α := PrimeSpectrum Γ(X, U)) ⟨p.asIdeal, p.isPrime⟩ :=
    Order.coheight_spec_eq_height_primeSpectrum p
  -- ⟨p.asIdeal, p.isPrime⟩ is just p, definitionally.
  have h5 : (⟨p.asIdeal, p.isPrime⟩ : PrimeSpectrum Γ(X, U)) = p := rfl
  -- Assemble: coheight z = height p, then cast to WithBot ℕ∞.
  rw [h1]
  -- coheight (α := U.1) ⟨z, hzU⟩ = coheight (α := U.toScheme) ⟨z, hzU⟩
  -- These are defeq since U.toScheme.carrier = U.1.
  have h6 : Order.coheight (α := (U.1 : Set X)) ⟨z, hzU⟩
      = Order.coheight (α := U.toScheme) ⟨z, hzU⟩ := rfl
  rw [h6, h2, h3, h4, h5]

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
  -- Ring.KrullDimLE n R ↔ ringKrullDim R ≤ n
  rw [Ring.krullDimLE_iff]
  rw [ringKrullDim_stalk_eq_coheight, hz]
  -- Goal: (1 : ℕ∞) ≤ (1 : WithBot ℕ∞) under appropriate coercion.
  norm_num

end Scheme

end AlgebraicGeometry
