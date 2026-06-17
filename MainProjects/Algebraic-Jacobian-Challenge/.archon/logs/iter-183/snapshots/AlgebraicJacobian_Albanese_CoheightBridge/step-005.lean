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
   `U ⊆ X` open, `coheight z (in X) = coheight ⟨z, hz⟩ (in U)` (both wrt the
   specialisation preorder).
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

namespace Order

/-- **Open subsets preserve `Order.coheight`** for points of a topological
space carrying the specialisation preorder. The `Preorder` instances on both
sides are pinned to the specialisation preorder explicitly to avoid clashing
with `Subtype.preorder` (which would otherwise be picked up automatically when
the parent space carries another preorder, e.g. `Scheme`'s).

Forward bound: `Subtype.val` is continuous, hence spec-monotone, and is
injective; therefore strictly monotone. Reverse bound: every generisation of a
point in an open set lies in that open (`Specializes.mem_open`), so a chain
starting at `z` in `X` lifts to a chain in `↥U` of the same length. -/
lemma coheight_eq_of_isOpenEmbedding
    {X : Type*} [TopologicalSpace X] {U : Set X} (hU : IsOpen U)
    (z : X) (hz : z ∈ U) :
    @Order.coheight X (specializationPreorder X) z
      = @Order.coheight U (specializationPreorder U) ⟨z, hz⟩ := by
  -- Provide the spec preorders locally so that ordinary `≤`/`<` notation
  -- elaborates against them in this proof.
  letI : Preorder X := specializationPreorder X
  letI : Preorder ↥U := specializationPreorder ↥U
  -- `Subtype.val : ↥U → X` is continuous, hence monotone for the spec
  -- preorder, and is injective; thus strictly monotone.
  have hSubMono : StrictMono (Subtype.val : ↥U → X) :=
    Monotone.strictMono_of_injective
      (continuous_subtype_val.specialization_monotone (X := X))
      Subtype.val_injective
  refine le_antisymm ?_ ?_
  · -- Reverse direction: coheight z (in X) ≤ coheight ⟨z,hz⟩ (in ↥U).
    refine Order.coheight_le_iff'.mpr ?_
    intro p hphead
    -- Every p i lies in U: p.head = z and z ≤ p i (in spec preorder X)
    -- means p i ⤳ z; combined with `z ∈ U` open, gives p i ∈ U.
    have hmem : ∀ i, p i ∈ U := by
      intro i
      have hle : z ≤ p i := by
        have := p.head_le i; rwa [hphead] at this
      exact Specializes.mem_open (show p i ⤳ z from hle) hU hz
    -- Build the corresponding LTSeries in ↥U.
    let q : LTSeries ↥U :=
      { length := p.length
        toFun := fun i => ⟨p i, hmem i⟩
        step := by
          intro i
          have hlt : p i.castSucc < p i.succ := p.step i
          have hspec : (p i.succ) ⤳ (p i.castSucc) := hlt.le
          have hsub : (⟨p i.succ, hmem _⟩ : ↥U) ⤳ ⟨p i.castSucc, hmem _⟩ :=
            (subtype_specializes_iff _ _).mpr hspec
          refine lt_of_le_of_ne (show _ ≤ _ from hsub) (fun heq => ?_)
          exact hlt.ne (by simpa using congrArg Subtype.val heq) }
    have hqhead : q.head = ⟨z, hz⟩ := by
      apply Subtype.ext; change p 0 = z; exact hphead
    have hlen : q.length = p.length := rfl
    have hbound := Order.length_le_coheight (x := (⟨z, hz⟩ : ↥U)) (p := q)
      (by rw [hqhead])
    simpa [hlen] using hbound
  · -- Forward direction: coheight ⟨z, hz⟩ (in ↥U) ≤ coheight z (in X).
    have h :=
      Order.coheight_le_coheight_apply_of_strictMono
        (Subtype.val : ↥U → X) hSubMono ⟨z, hz⟩
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
        exact (spec_le_iff R a b).symm }
  have h1 : Order.coheight (α := (PrimeSpectrum R)ᵒᵈ) (e p) =
      Order.coheight (α := Spec R) p :=
    Order.coheight_orderIso e p
  rw [← h1]
  -- `e p = OrderDual.toDual ⟨p.asIdeal, p.isPrime⟩`; reduce via
  -- `coheight (toDual x) = height x`.
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
  -- The IsLocalization instance carries an Algebra structure (from the
  -- presheaf section-to-stalk algebra). Bind it locally.
  letI : Algebra Γ(X, U) (X.presheaf.stalk z) :=
    TopCat.Presheaf.algebra_section_stalk X.presheaf ⟨z, hzU⟩
  -- Step 4: ringKrullDim stalk = p.asIdeal.height (= primeHeight p).
  have h4 :
      ringKrullDim (X.presheaf.stalk z)
        = (Order.height (α := PrimeSpectrum Γ(X, U)) p : WithBot ℕ∞) := by
    rw [IsLocalization.AtPrime.ringKrullDim_eq_height
          p.asIdeal (A := X.presheaf.stalk z),
        Ideal.height_eq_primeHeight]
    rfl
  -- Step 5: relate height(p) to coheight(z) via Decls 1 + 2 and the
  -- homeomorphism `Spec Γ(X,U) ≃ U.toScheme` from `hU.isoSpec`.
  -- (5a) Decl 1: coheight z in X = coheight ⟨z, hzU⟩ in U.1 subspace.
  have h1' :
      @Order.coheight X (specializationPreorder X) z
        = @Order.coheight U.1 (specializationPreorder U.1) ⟨z, hzU⟩ :=
    Order.coheight_eq_of_isOpenEmbedding (X := X) (U := U.1) U.isOpen z hzU
  -- For a Scheme, the standard `Preorder` instance is definitionally
  -- `specializationPreorder`, so we can re-cast h1' to use the Scheme's
  -- preorder on the X side (and U.toScheme's preorder on the U side).
  have h1 :
      Order.coheight (α := X) z
        = Order.coheight (α := U.toScheme) ⟨z, hzU⟩ := h1'
  -- (5b) The scheme iso `hU.isoSpec : U.toScheme ≅ Spec Γ(X,U)` is a Scheme
  -- iso; the underlying carrier-level map is a homeomorphism, giving an
  -- order iso of spec preorders.
  let hHomeo : U.toScheme ≃ₜ Spec Γ(X, U) :=
    TopCat.homeoOfIso (Scheme.forgetToTop.mapIso hU.isoSpec)
  let eOrder : U.toScheme ≃o Spec Γ(X, U) :=
    { toEquiv := hHomeo.toEquiv
      map_rel_iff' := by
        intro a b
        constructor
        · intro h
          -- h : hHomeo a ≤ hHomeo b means hHomeo b ⤳ hHomeo a in Spec.
          have hsp : hHomeo b ⤳ hHomeo a := h
          have hsp' := hsp.map hHomeo.symm.continuous
          rw [hHomeo.symm_apply_apply, hHomeo.symm_apply_apply] at hsp'
          exact (hsp' : a ≤ b)
        · intro h
          have hsp : b ⤳ a := h
          exact (hsp.map hHomeo.continuous : hHomeo a ≤ hHomeo b) }
  have h2 : Order.coheight (α := U.toScheme) ⟨z, hzU⟩
      = Order.coheight (α := Spec Γ(X, U)) (eOrder ⟨z, hzU⟩) :=
    (Order.coheight_orderIso eOrder ⟨z, hzU⟩).symm
  have h3 : eOrder ⟨z, hzU⟩ = p := rfl
  -- (5c) Decl 2: coheight (Spec R) p = height (PrimeSpectrum R) p.
  have h6 : Order.coheight (α := Spec Γ(X, U)) p
      = Order.height (α := PrimeSpectrum Γ(X, U))
          ⟨p.asIdeal, p.isPrime⟩ :=
    Order.coheight_spec_eq_height_primeSpectrum p
  have h7 : (⟨p.asIdeal, p.isPrime⟩ : PrimeSpectrum Γ(X, U)) = p := rfl
  -- Assemble.
  rw [h4, h1, h2, h3, h6, h7]

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
