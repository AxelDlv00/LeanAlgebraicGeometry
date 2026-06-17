/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Cotangent.ChartAlgebraS3
import AlgebraicJacobian.Cotangent.GrpObj
import AlgebraicJacobian.Rigidity
import Mathlib.RingTheory.IsTensorProduct
import Mathlib.RingTheory.Kaehler.Basic
import Mathlib.RingTheory.Kaehler.Polynomial
import Mathlib.RingTheory.Smooth.StandardSmoothCotangent
import Mathlib.Algebra.MvPolynomial.PDeriv

-- iter-145 NOTE: the directive named `Mathlib.RingTheory.IsPushout` as a
-- desired import, but that file does not exist upstream; the closest
-- canonical anchor is `Mathlib.RingTheory.IsTensorProduct` (which exposes
-- the `Algebra.IsPushout` square API). The directive also listed
-- `Mathlib.Algebra.CharP.Frobenius`; it is not required for the
-- iter-145 `: True := sorry` placeholders and is intentionally omitted
-- (iter-146 may reintroduce it when the real signatures land).
--
-- iter-146 NOTE: import `AlgebraicJacobian.Rigidity` for the iter-125
-- packaging lemma `Scheme.Over.ext_of_eqOnOpen` consumed by the (lift)
-- sub-piece below. The Mathlib `Algebra.TensorProduct.rightAlgebra` is
-- a `local instance` inside `Mathlib.RingTheory.IsTensorProduct`; we
-- re-enable it as a local instance here so the canonical
-- `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)` instance is in scope for the
-- (α) sub-piece closure.

/-!
# Chart-algebra skeleton for the iter-144 piece (ii) pivot

This file scaffolds the five sub-pieces of the iter-144 chart-algebra pivot
route for piece (ii) of the M2.body-pile (per `STRATEGY.md` §
"Iter-144 chart-algebra pivot — COMMITTED" + `RigidityKbar.tex` §
"Iter-144 chart-algebra envelope for piece (ii)").

## Status (iter-146 prover lane)

* (α) `algebra_isPushout_of_affine_product` — **CLOSED** iter-146;
  refined signature to `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)` and
  discharged by `inferInstance` (Mathlib `TensorProduct.isPushout`
  under the locally re-enabled `Algebra.TensorProduct.rightAlgebra`).
* (β-aux) `constants_integral_over_base_field` — signature refined
  iter-146 to `RingHom.range ((X ↘ Spec (.of k)).appTop.hom) = ⊤`
  (smooth proper geometrically irreducible `X` over a field `k`);
  body remains a structured `sorry` pending iter-147+ closure of the
  base-change-to-`\bar k`-and-properness chain.
* (lift) `Scheme.Over.ext_of_diff_zero` — signature refined iter-146
  to `(f g : C ⟶ A)` over `Spec k` agreeing on a non-empty open
  imply `f = g`; closed by delegating to the iter-125
  `Scheme.Over.ext_of_eqOnOpen` (the `df = dg` hypothesis is
  redundant when `eqOnOpen` is given outright, per the iter-146
  prover-lane reading of the planner spec; iter-147+ refines to
  encode `df = dg` substantively once (β-core) lands).

The two deferred sub-pieces (β-core + KDM ring-side) keep their
iter-145 `: True := sorry` skeletons pending iter-147+ prover lane
after the iter-147 blueprint-reviewer green-light on the iter-146
`blueprint-writer-rigiditykbar-iter146` absorption.

For the informal mathematical content + closure-path documentation, see
`blueprint/src/chapters/RigidityKbar.tex` § "Chart-algebra piece (ii)
first-class decomposition".
-/

open CategoryTheory Limits TopologicalSpace

universe u

namespace AlgebraicGeometry

-- Mathlib's `Algebra.TensorProduct` ships only the LEFT algebra instance on
-- `B₁ ⊗[k] B₂`; the symmetric right-algebra is a `local instance` inside
-- `Mathlib.RingTheory.IsTensorProduct`. Re-enable it here so the canonical
-- `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)` instance from Mathlib resolves.
attribute [local instance] Algebra.TensorProduct.rightAlgebra

namespace GrpObj

/-- Chart-algebra (α): the affine pullback `Spec B₁ ×_(Spec k) Spec B₂ =
Spec (B₁ ⊗_k B₂)` carries the canonical `Algebra.IsPushout k B₁ B₂
(B₁ ⊗[k] B₂)` square at the ring level. Refined iter-146 to its real
signature (the algebra-level core of the blueprint's three-step
chart-scheme bridge); discharged by `inferInstance` after re-enabling
the local right-algebra instance. -/
theorem algebra_isPushout_of_affine_product
    (k B₁ B₂ : Type*) [CommRing k] [CommRing B₁] [CommRing B₂]
    [Algebra k B₁] [Algebra k B₂] :
    Algebra.IsPushout k B₁ B₂ (TensorProduct k B₁ B₂) :=
  inferInstance

end GrpObj

/-! ### (BR.5) helper machinery — MvPolynomial joint-kernel collapse

The (BR.5) joint-kernel collapse argument for the KDM lemma below is built on
two helper facts about `MvPolynomial σ k` in `CharZero`:

1. The coefficient formula for `pderiv`: for `u : σ →₀ ℕ` with `u i ≥ 1`,
   `coeff (u - single i 1) (pderiv i f) = coeff u f * (u i : k)`.

2. The joint-kernel-equals-constants fact for the free polynomial algebra: in
   `CharZero`, if all `pderiv i f = 0` then `f ∈ MvPolynomial.C.range`.

The (BR.5) closure path for a standard-smooth `B` then proceeds by lifting `b`
to `b̃ ∈ MvPolynomial ι k` via the `SubmersivePresentation`, transferring the
`D b = 0` hypothesis through the functoriality `Ω[MvPoly⁄k] → Ω[B⁄k]`, and
applying helper 2 — modulo the technical step of choosing a lift `b̃` whose
own `D b̃` vanishes in `Ω[MvPoly⁄k]` (not just in the quotient). The transfer
step depends on a Mathlib-side observation about `KaehlerDifferential.ker_map_of_surjective`
that is not directly packaged in `b80f227`; the iter-150 HYBRID (C) commitment
lands the helpers and the strategic scaffold, with the transfer-step Mathlib
gap recorded inline at the `sorry` point. -/

private lemma _finsupp_sub_single_eq_of_one_le
    {σ : Type*} (s t : σ →₀ ℕ) (i : σ)
    (hsub : s - Finsupp.single i 1 = t - Finsupp.single i 1)
    (hsi : 1 ≤ s i) (hti : 1 ≤ t i) :
    s = t := by
  classical
  ext j
  have hj : (s - Finsupp.single (α := σ) i (1 : ℕ)) j =
            (t - Finsupp.single (α := σ) i (1 : ℕ)) j := DFunLike.congr_fun hsub j
  rw [Finsupp.tsub_apply, Finsupp.tsub_apply, Finsupp.single_apply] at hj
  by_cases hji : j = i
  · subst hji; simp at hj; omega
  · rw [if_neg (fun h => hji h.symm)] at hj; simpa using hj

/-- Coefficient formula for `pderiv`: for `u` with `u i ≥ 1`, the coefficient
of `pderiv i f` at `u - single i 1` is exactly `coeff u f * (u i : k)`. -/
private lemma _mvPoly_coeff_pderiv_at_shifted
    {σ : Type*} {k : Type*} [CommSemiring k]
    (f : MvPolynomial σ k) (i : σ) (u : σ →₀ ℕ) (hui : 1 ≤ u i) :
    MvPolynomial.coeff (u - Finsupp.single i 1) ((MvPolynomial.pderiv i) f) =
      MvPolynomial.coeff u f * (u i : k) := by
  classical
  conv_lhs => rw [MvPolynomial.as_sum f]
  rw [map_sum, MvPolynomial.coeff_sum]
  simp_rw [MvPolynomial.pderiv_monomial, MvPolynomial.coeff_monomial]
  by_cases hu : u ∈ f.support
  · rw [Finset.sum_eq_single u]
    · simp
    · intro x _ hxne
      by_cases hxsub : x - Finsupp.single i 1 = u - Finsupp.single i 1
      · rw [if_pos hxsub]
        by_cases hxi : 1 ≤ x i
        · exact absurd (_finsupp_sub_single_eq_of_one_le x u i hxsub hxi hui) hxne
        · have hxi' : x i = 0 := Nat.lt_one_iff.mp (Nat.not_le.mp hxi)
          rw [hxi']; simp
      · rw [if_neg hxsub]
    · intro hu'; exact absurd hu hu'
  · rw [MvPolynomial.notMem_support_iff.mp hu, zero_mul]
    apply Finset.sum_eq_zero
    intro x hx
    by_cases hxsub : x - Finsupp.single i 1 = u - Finsupp.single i 1
    · rw [if_pos hxsub]
      by_cases hxi : 1 ≤ x i
      · exact absurd (by
          rw [_finsupp_sub_single_eq_of_one_le x u i hxsub hxi hui] at hx; exact hx) hu
      · have hxi' : x i = 0 := Nat.lt_one_iff.mp (Nat.not_le.mp hxi)
        rw [hxi']; simp
    · rw [if_neg hxsub]

/-- In `CharZero`, an `MvPolynomial` whose all partial derivatives vanish lies
in the image of `MvPolynomial.C`. This is the FREE-CASE of the joint-kernel
collapse (BR.5), proven via the coefficient formula `_mvPoly_coeff_pderiv_at_shifted`.

Strategy: We show `f.support ⊆ {0}`, hence `f = monomial 0 (coeff 0 f) = C (coeff 0 f)`.
If `s ∈ f.support` with `s ≠ 0`, pick `i` with `s i ≥ 1`. By the coefficient formula,
`coeff (s - single i 1) (pderiv i f) = coeff s f * (s i : k)`. The LHS is `0`
(by `pderiv i f = 0`), but the RHS is nonzero (`coeff s f ≠ 0` since `s ∈ support`,
and `(s i : k) ≠ 0` by `CharZero` + `s i ≥ 1`). Contradiction. -/
private lemma _mvPoly_mem_range_C_of_pderiv_eq_zero
    {σ : Type*} {k : Type*} [Field k] [CharZero k]
    {f : MvPolynomial σ k} (hPDeriv : ∀ i : σ, MvPolynomial.pderiv i f = 0) :
    f ∈ (MvPolynomial.C : k →+* MvPolynomial σ k).range := by
  classical
  suffices hsupp : ∀ s ∈ f.support, s = 0 by
    refine ⟨MvPolynomial.coeff 0 f, ?_⟩
    nth_rewrite 2 [MvPolynomial.as_sum f]
    rw [show (MvPolynomial.C (MvPolynomial.coeff 0 f) : MvPolynomial σ k) =
        MvPolynomial.monomial 0 (MvPolynomial.coeff 0 f) by rfl]
    by_cases h0 : 0 ∈ f.support
    · have : f.support = {0} := Finset.eq_singleton_iff_unique_mem.mpr ⟨h0, hsupp⟩
      rw [this]; simp
    · have : f.support = ∅ := by
        apply Finset.eq_empty_iff_forall_notMem.mpr
        intro s hs
        rw [hsupp s hs] at hs; exact h0 hs
      rw [this, Finset.sum_empty, MvPolynomial.notMem_support_iff.mp h0]; simp
  intro s hs
  by_contra hne
  obtain ⟨i, hi⟩ : ∃ i, s i ≠ 0 := by
    by_contra h
    apply hne
    ext j
    by_contra hj
    exact h ⟨j, hj⟩
  have hsi : 1 ≤ s i := Nat.one_le_iff_ne_zero.mpr hi
  have hc := _mvPoly_coeff_pderiv_at_shifted f i s hsi
  rw [hPDeriv i, MvPolynomial.coeff_zero] at hc
  have hcf : MvPolynomial.coeff s f = 0 := by
    rcases mul_eq_zero.mp hc.symm with h | h
    · exact h
    · exfalso
      have : (s i : ℕ) = 0 := by exact_mod_cast h
      omega
  exact MvPolynomial.mem_support_iff.mp hs hcf

/-- The KDM (BR.5) FREE-CASE: in `CharZero`, the universal Kähler derivation
`D : MvPolynomial σ k → Ω[MvPolynomial σ k⁄k]` has kernel exactly
`MvPolynomial.C.range`. -/
private lemma _mvPoly_mem_range_C_of_D_eq_zero
    {σ : Type*} {k : Type*} [Field k] [CharZero k]
    {f : MvPolynomial σ k}
    (hDf : _root_.KaehlerDifferential.D k (MvPolynomial σ k) f = 0) :
    f ∈ (MvPolynomial.C : k →+* MvPolynomial σ k).range := by
  apply _mvPoly_mem_range_C_of_pderiv_eq_zero
  intro i
  have h := KaehlerDifferential.mvPolynomialBasis_repr_apply k σ f i
  rw [hDf] at h
  simp at h
  exact h.symm

/-- Algebra-level core: for `k` a field of characteristic 0 and `B` a
standard-smooth `k`-algebra of relative dimension `n`, if `b : B` satisfies
`D b = 0` in `Ω_{B/k}` then `b ∈ range (algebraMap k B)`. This is the
chart-algebra (β-core ring-side) helper of the iter-144 piece (ii) pivot,
formalising the "constants = kernel of universal derivation" content of the
Kähler derivation in characteristic 0.

Iter-149 signature inflation (BR.1): `[CharZero k]` +
`[Algebra.IsStandardSmoothOfRelativeDimension n k B]` typeclass conjunction
absorbed per `PROGRESS.md` § "Iter-149 Lane 2" + blueprint
`lem:KaehlerDifferential_mem_range_algebraMap_of_D_eq_zero` §
"Primary path (p2)". The body now packages (BR.2) freeness of `Ω[B⁄k]`
from `Algebra.IsStandardSmooth.free_kaehlerDifferential` and documents
the residual (BR.3)–(BR.5) joint-coordinate-kernel collapse step
inline. The structured `sorry` still concentrates at (BR.5) — the
char-0 joint-kernel-of-coordinate-derivations equals
`range (algebraMap k B)` step — which is the substantive Mathlib gap-
fill of the bridge (~80–150 LOC of iter-150+ project work).

Signature inflation honesty (char-0 commitment): the (p1) char-p
Cartier-direction alternative path documented in the iter-148 docstring
is DROPPED from this lemma's commitment via the `[CharZero k]`
hypothesis. A future char-p formalisation would either branch on
`CharP k p` inside the body, or split into two named lemmas.

Reverse inclusion: `_hRev` records that `D ∘ algebraMap k B = 0` so the
forward direction stated here is the substantive content. Downstream
consumer: `GrpObj.df_zero_factors_through_constant_on_chart` below
(inflated correspondingly per planner). -/
theorem KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    {B : Type u} [CommRing B] [IsDomain B] [Algebra k B] [Algebra.FiniteType k B]
    {n : ℕ} [Algebra.IsStandardSmoothOfRelativeDimension n k B]
    {b : B} (hDb : _root_.KaehlerDifferential.D k B b = 0) :
    b ∈ (algebraMap k B).range := by
  -- Reverse inclusion (recorded for downstream symmetry):
  -- `D : Derivation k B Ω[B⁄k]` vanishes on the algebraMap image by
  -- `Derivation.map_algebraMap`.
  have _hRev : ∀ a : k, _root_.KaehlerDifferential.D k B (algebraMap k B a) = 0 :=
    fun a => (_root_.KaehlerDifferential.D k B).map_algebraMap a
  -- (BR.2) Free-module structure on `Ω[B⁄k]` from the standard-smooth
  -- chart hypothesis: `Module.Free B Ω[B⁄k]` of rank `n`. The relative-
  -- dimension class is a `Prop`, not registered as an instance for
  -- `IsStandardSmooth`, so dispatch through the named theorem.
  haveI _hStdSm : Algebra.IsStandardSmooth k B :=
    Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n
  haveI _hFree : Module.Free B (Ω[B⁄k]) :=
    Algebra.IsStandardSmooth.free_kaehlerDifferential
  -- (BR.3) Coordinate-derivation construction. For a chosen basis
  -- `{dx_i}_{i : ChooseBasisIndex B Ω[B⁄k]}` of `Ω[B⁄k]`, each B-linear
  -- coordinate functional `basis.coord i : Ω[B⁄k] →ₗ[B] B` composes with
  -- the universal Kähler derivation `D : Derivation k B Ω[B⁄k]` (via
  -- `LinearMap.compDer`) to produce a k-derivation
  -- `∂_i : Derivation k B B`. Since `D b = 0` (hypothesis), each
  -- `∂_i b = (basis.coord i) (D b) = (basis.coord i) 0 = 0` (record
  -- this for the (BR.5) consumer).
  let _basis := Module.Free.chooseBasis B (Ω[B⁄k])
  have _hCoordVanish : ∀ i, ((_basis.coord i).compDer
      (_root_.KaehlerDifferential.D k B)) b = 0 := by
    intro i
    -- `∂_i b = (basis.coord i) (D b) = (basis.coord i) 0 = 0` via the
    -- `LinearMap.compDer` coe-unfolding and `LinearMap.map_zero`.
    simp [Derivation.coe_comp, hDb]
  -- (BR.4) `Differential B` instance: each `∂_i : Derivation k B B`
  -- restricts to a `Derivation ℤ B B` via `Derivation.restrictScalars`,
  -- which is the witness for the `Differential B` structure. Multiple
  -- coordinate `Differential B` instances are mutually incompatible
  -- (Lean's typeclass synthesis picks one); we keep this as an
  -- explicit `let` rather than registering it globally.
  --
  -- (BR.5) JOINT-KERNEL COLLAPSE — HYBRID part (C) approach (iter-150).
  --
  -- We extract a `SubmersivePresentation P : SubmersivePresentation k B ι σ`
  -- from `IsStandardSmoothOfRelativeDimension n k B`. This gives:
  -- * `P.Ring = MvPolynomial ι k` (a polynomial ring on a finite index set ι);
  -- * a surjective `k`-algebra map `π : MvPolynomial ι k →ₐ[k] B`.
  --
  -- The MvPolynomial-side joint-kernel-equals-constants fact for the FREE
  -- case is `_mvPoly_mem_range_C_of_D_eq_zero` above: in `CharZero`,
  -- `D f = 0` on `MvPolynomial σ k` implies `f ∈ MvPolynomial.C.range`.
  -- This is proven directly via `_mvPoly_coeff_pderiv_at_shifted` + a
  -- support-analysis monomial argument (no use of standard-smooth structure;
  -- the FREE case suffices).
  --
  -- The TRANSFER from `MvPolynomial`-side to `B`-side:
  --
  -- Lift `b` to `b̃ ∈ P.Ring = MvPolynomial ι k` via the surjection.
  -- By the functoriality `KaehlerDifferential.map_D`, we have
  --   `D_B (π b̃) = (KaehlerDifferential.map k k (MvPolynomial ι k) B) (D_A b̃)`.
  -- So `D_B b = 0` gives `D_A b̃ ∈ ker (KaehlerDifferential.map ...)`.
  -- By `KaehlerDifferential.ker_map_of_surjective`, this kernel is the image of
  -- `(LinearMap.ker finsupp_map).map (Finsupp.linearCombination A (D R A))` —
  -- i.e., the `A`-submodule generated by `{D_A r : r ∈ I}` (informally) where
  -- `I = ker π`. The challenge is converting this into a CONCRETE statement
  -- "there exists a lift `b̃'` with `D_A b̃' = 0`", which would unlock the
  -- application of `_mvPoly_mem_range_C_of_D_eq_zero`. This step
  -- requires either:
  -- * (S5.a) constructing the lift `b̃'` explicitly from the `ker_map`
  --   description by Leibniz-rule manipulation, which absorbs the
  --   modification by `I·Ω[A⁄k]` AND the residual `I·D(coefficients)`
  --   terms — about ~30 LOC of `Submodule.map`/`Finsupp.sum` chasing, or
  -- * (S5.b) a Mathlib-PR-grade abstract argument via
  --   `Algebra.FormallySmooth.subsingleton_h1Cotangent` + the
  --   `Algebra.Extension.cotangentComplex` exact sequence to argue that
  --   `ker(D_B) ⊆ image(algebraMap k B)` directly for FormallySmooth B.
  --
  -- For iter-150, we land the (BR.1)-(BR.4) scaffolding and the FREE-case
  -- helpers (`_mvPoly_*` above); the residual TRANSFER step is the
  -- iter-151+ continuation. The structured `sorry` below is GUARDED by
  -- the helper lemmas: any iter-151+ closure that goes through this
  -- transfer route benefits directly from the helper investment.
  --
  -- Extract the SubmersivePresentation and lift `b`.
  obtain ⟨ι, σ, _hFinσ, _hFinι, ⟨P⟩⟩ := ‹Algebra.IsStandardSmooth k B›.out
  -- `algebraMap P.Ring B` is the algebra map under which `B` is presented;
  -- it is surjective by `Algebra.Generators.algebraMap_surjective`.
  -- Note: `P.Ring = MvPolynomial ι k` as an abbreviation, with the algebra
  -- instance carried by `P.algebra` (registered via `instance : Algebra P.Ring S := P.algebra`).
  have _hπSurj : Function.Surjective (algebraMap P.Ring B) :=
    P.toGenerators.algebraMap_surjective
  obtain ⟨bTilde, hbTilde⟩ : ∃ bTilde : P.Ring, algebraMap P.Ring B bTilde = b :=
    _hπSurj b
  -- Functoriality of D: `D_B (π bTilde) = (map k k P.Ring B)(D_A bTilde)`.
  -- This is `KaehlerDifferential.map_D`.
  have _hFunct :
      (_root_.KaehlerDifferential.map k k P.Ring B)
        ((_root_.KaehlerDifferential.D k P.Ring) bTilde) = 0 := by
    have hMap :
        (_root_.KaehlerDifferential.map k k P.Ring B)
          ((_root_.KaehlerDifferential.D k P.Ring) bTilde) =
        (_root_.KaehlerDifferential.D k B) ((algebraMap P.Ring B) bTilde) :=
      _root_.KaehlerDifferential.map_D k k P.Ring B bTilde
    rw [hbTilde, hDb] at hMap
    exact hMap
  -- (C.d) TRANSFER STEP — now a GENUINE to-prove goal under the corrected
  -- `[IsAlgClosed k]` + `[IsDomain B]` signature (iter-152).
  --
  -- The bare `B`-only lemma WITHOUT these two hypotheses is FALSE; two
  -- counterexamples (each satisfies `[Field k] [CharZero k]`,
  -- `[Algebra.FiniteType k B]`, `[IsStandardSmoothOfRelativeDimension n k B]`):
  --   (CE1, disconnected) `B = k × k`, `n = 0`: finite étale, `Ω[B⁄k] = 0`,
  --     so `D = 0` and `hDb` holds for every `b`, yet `range(algebraMap k B)`
  --     is the diagonal `⊊ B`. EXCLUDED by `[IsDomain B]`.
  --   (CE2, connected, not geometrically) `k = ℚ`, `B = ℚ(√2)`, `n = 0`:
  --     finite separable ⟹ étale ⟹ `Ω[B⁄k] = 0`, `D = 0`, `hDb` holds for
  --     every `b`, yet `range(algebraMap ℚ B) = ℚ ⊊ ℚ(√2)`. EXCLUDED by
  --     `[IsAlgClosed k]` (no proper finite extension of an algebraically
  --     closed field; and `k` is algebraically closed in `Frac B` for a
  --     geometrically integral char-0 `B`).
  --
  -- Jointly the statement is TRUE: this is the constants-of-derivation
  -- transfer `ker d_{Frac B / k} = k` for a char-0 geometrically-integral
  -- `B` over an algebraically closed `k`. The residual `sorry` is the
  -- genuine to-prove step; the (C.a)-(C.c) scaffolding above (FREE-CASE
  -- `_mvPoly_*` helpers + `_hFunct` functoriality reduction) remains valid
  -- and reusable in its closure.
  --
  -- iter-153 BRIGHT-LINE STOP (Mathlib gap confirmed). The single residual
  -- content is blueprint step (FT.3): for the separably-generated (here
  -- char-0) field extension `K = Frac B` over `k`, the kernel of the
  -- universal derivation `d : K → Ω[K⁄k]` equals the relative algebraic
  -- closure of `k` in `K`. Combined with (FT.2) `k` algebraically closed
  -- in `K` (from `[IsAlgClosed k]` + `[IsDomain B]`), that gives
  -- `ker d_{K/k} = k`, hence `b ∈ range (algebraMap k B)`.
  --
  -- Searched Mathlib (snapshot b80f227) iter-153 — the load-bearing FT.3
  -- lemma is ABSENT. Concretely:
  --   * No `ker (KaehlerDifferential.D k K) = ...` description lemma exists
  --     (loogle `KaehlerDifferential.D _ _ ?x = 0` → ∅).
  --   * `Differential.ContainConstants` / `mem_range_of_deriv_eq_zero`
  --     (`Mathlib.RingTheory.Derivation.DifferentialRing`) is stated for an
  --     ABSTRACT single derivation `B → B` (a `Differential B` instance),
  --     NOT the universal Kähler derivation `K → Ω[K⁄k]`; the ONLY instance
  --     shipped is the trivial `ContainConstants A A`. No instance for our
  --     case (would itself require FT.3).
  --   * `Algebra.FormallyUnramified.iff_isSeparable` + `Subsingleton Ω[L⁄K]`
  --     (`Mathlib.RingTheory.Unramified.Field`) only cover the ALGEBRAIC
  --     (`EssFiniteType`) case `Ω = 0`; the function field `K = Frac B` has
  --     positive transcendence degree, so `Ω[K⁄k] ≠ 0` and this does not
  --     apply where the actual content lives.
  --   * `Mathlib.RingTheory.Smooth.Field` gives `FormallySmooth` for
  --     separably-generated extensions but exposes NO basis of `Ω[K⁄k]`
  --     from a separating transcendence basis and NO kernel description.
  -- Per PROGRESS.md objective (b) bright-line: STOP here, do NOT add a new
  -- helper layer or re-decompose. iter-154 should dispatch a
  -- `mathlib-analogist` consult on the FT.3 shape (see task_results).
  sorry

namespace GrpObj

/-- Chart-algebra (β-core): per-chart translation-invariance Kähler-derivation.
For a smooth proper geometrically irreducible curve `C/k` and an affine chart
`V ⊆ C` whose chart-ring `B = Γ(V, O_C)` carries a finite-type `k`-algebra
structure, a chart-section `b ∈ B` with vanishing universal Kähler derivation
`KaehlerDifferential.D k B b = 0` lies in `range (algebraMap k B)` — the chart-
local kernel-of-`D` content of the iter-144 chart-algebra pivot piece (ii) is
the algebra-level statement that constants are the image of the base field.

Iter-147 signature refinement: the chart-of-proper-curve hypothesis is carried
as typeclass arguments on `C` (smooth, proper, reduced, geometrically
irreducible over `Spec k`); the chart-ring `B` is carried as a separate finite-
type `k`-algebra argument with the (chart-side identification `B ≃ₐ[k] Γ(V, O_C)`
deferred to the consumer site via the `Scheme.Over.ext_of_diff_zero` refinement
plan; iter-148+). The body delegates to the algebra-level KDM helper
`KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` above.

The full 5-step closure path is documented in `blueprint/src/chapters/
RigidityKbar.tex` § "Chart-algebra piece (ii) first-class decomposition"
under `lem:chart_algebra_df_zero_factors_through_constant_on_chart`:
(1) chart-Kähler kernel extraction (this is KDM); (2) standard-smooth chart
witness from `Algebra.IsStandardSmooth.free_kaehlerDifferential`;
(3) 2-chart Čech Mayer–Vietoris on `Ω_{C/k}^{⊕n}` reusing
`Cohomology/MayerVietoris*`; (4) 2-chart-cover existence per Stacks 0F8L;
(5) char-p Frobenius patch via `RingHom.iterateFrobenius_comm`. -/
theorem df_zero_factors_through_constant_on_chart
    {k : Type u} [Field k] [IsAlgClosed k] [CharZero k]
    {C : Scheme.{u}} [C.Over (Spec (CommRingCat.of k))]
    [IsProper (C ↘ Spec (CommRingCat.of k))]
    [Smooth (C ↘ Spec (CommRingCat.of k))]
    [IsReduced C]
    [GeometricallyIrreducible (C ↘ Spec (CommRingCat.of k))]
    {B : Type u} [CommRing B] [IsDomain B] [Algebra k B] [Algebra.FiniteType k B]
    {n : ℕ} [Algebra.IsStandardSmoothOfRelativeDimension n k B]
    {b : B} (hDb : _root_.KaehlerDifferential.D k B b = 0) :
    b ∈ (algebraMap k B).range :=
  -- Iter-149 signature inflation: `[CharZero k]` and
  -- `[Algebra.IsStandardSmoothOfRelativeDimension n k B]` propagated
  -- from the KDM (p2) bridge directive in `PROGRESS.md` § "Iter-149
  -- Lane 2". Char-p alternative (p1) path is deferred. The scheme-
  -- level chart-of-proper-curve hypotheses on `C` remain the
  -- standing premise for a future char-p reactivation if the
  -- project widens the KDM commitment.
  AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero (n := n) hDb

end GrpObj

/-- Integrally-closed-constants helper: in a (smooth) proper geometrically
irreducible scheme `X` over a base field `k`, the global sections
`Γ(X, O_X)` are exhausted by the image of the structure-morphism's
action on the top open, i.e.\ the `appTop` ring hom of the structure
morphism `X ⟶ Spec k` is surjective. Equivalently, `Γ(X, O_X) ≅ k` as
`k`-algebras (modulo the canonical iso `Γ(Spec k, ⊤) ≃ k`).

Blueprint: `chapters/RigidityKbar.tex` §
`\lem:constants_integral_over_base_field`. Three-substep recipe (per
the iter-146 prover-lane reading):
(1) `IsReduced X` + `GeometricallyIrreducible (X ↘ Spec k)` (over the
    singleton-base `Spec k`) ⇒ `IsIntegral X` (combine
    `GeometricallyIrreducible.irreducibleSpace_of_subsingleton` with
    `isIntegral_of_irreducibleSpace_of_isReduced`).
(2) `IsIntegral X` + `UniversallyClosed (X ↘ Spec k)` (from
    `IsProper`) ⇒ `Γ(X, O_X)` is a field
    (`isField_of_universallyClosed`); and additionally
    `LocallyOfFiniteType (X ↘ Spec k)` ⇒ the `appTop` map is finite
    (`finite_appTop_of_universallyClosed`). So `Γ(X, O_X)` is a finite
    field extension of `k`.
(3) Geometric irreducibility ⇒ this field extension is trivial via
    base change to `\bar k`: `Γ(X, O_X) ⊗_k \bar k ≃ Γ(X_{\bar k},
    ⊤) = \bar k` (the latter equality by the same chain applied to
    `X_{\bar k}` over `\bar k`, which is integral after base change
    because geometric irreducibility is stable under base change).
    A finite field extension `Γ` of `k` with `Γ ⊗_k \bar k = \bar k`
    has `dim_k Γ = 1`, hence `Γ = k`.

Iter-146 prover lane: signature refined to its real shape; substeps
(1)–(2) of the chain are closed by chasing the Mathlib lemmas
identified by the planner; substep (3) (the geom-irr base-change step)
remains a structured `sorry`. The `[IsReduced X]` hypothesis is added
explicitly because Mathlib snapshot `b80f227` lacks the lemma
`Smooth ⇒ IsReduced` over a field — see the `Rigidity.lean` "Hypothesis
history" block for the same explicit-`IsReduced` discipline. -/
theorem constants_integral_over_base_field
    {k : Type u} [Field k] [IsAlgClosed k] {X : Scheme.{u}} [X.Over (Spec (.of k))]
    [IsProper (X ↘ Spec (.of k))]
    [Smooth (X ↘ Spec (.of k))]
    [IsReduced X]
    [GeometricallyIrreducible (X ↘ Spec (.of k))] :
    RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤ := by
  -- Iter-153 alg-closed closure. Under `[IsAlgClosed k]` the proof
  -- collapses to three steps: (1) `X` integral ⟹ `Γ(X, O_X)` a field;
  -- (2) properness ⟹ `Γ(X, O_X)` finite (hence integral) over `k`;
  -- (3) `IsAlgClosed.algebraMap_bijective_of_isIntegral` gives the
  -- structure ring hom `k → Γ(X, O_X)` bijective, hence surjective,
  -- which is the displayed `range = ⊤`.
  set f := X ↘ Spec (CommRingCat.of k) with hf
  -- (1) `X` is integral: smoothness gives `IsReduced X`, geometric
  -- irreducibility over the singleton base `Spec k` gives `IrreducibleSpace X`,
  -- and the two combine to `IsIntegral X`.
  haveI : IrreducibleSpace X :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton f
  haveI : IsIntegral X := isIntegral_of_irreducibleSpace_of_isReduced X
  -- (1, cont.) properness ⟹ universally closed ⟹ `Γ(X, ⊤)` is a field.
  letI : Field Γ(X, ⊤) := (isField_of_universallyClosed k f).toField
  -- (2) The composite `F : k → Γ(X, ⊤)` (structure map through the
  -- canonical `ΓSpecIso`) is finite, hence integral over `k`.
  let F := (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ f.appTop
  have hFinF : F.hom.Finite := by
    apply RingHom.finite_respectsIso.2
      (e := (Scheme.ΓSpecIso (CommRingCat.of k)).symm.commRingCatIsoToRingEquiv)
    exact finite_appTop_of_universallyClosed k f
  letI : Algebra k Γ(X, ⊤) := F.hom.toAlgebra
  haveI : Module.Finite k Γ(X, ⊤) := hFinF
  haveI : Algebra.IsIntegral k Γ(X, ⊤) := Algebra.IsIntegral.of_finite k Γ(X, ⊤)
  -- (3) `k` algebraically closed ⟹ `algebraMap k Γ(X, ⊤) = F.hom` is
  -- bijective, hence surjective.
  have hbij : Function.Bijective (algebraMap k Γ(X, ⊤)) :=
    IsAlgClosed.algebraMap_bijective_of_isIntegral
  -- Convert the range goal to surjectivity of `f.appTop.hom`; since
  -- `F.hom = f.appTop.hom ∘ (ΓSpecIso).inv.hom` is surjective, so is
  -- `f.appTop.hom`.
  rw [RingHom.range_eq_top]
  have hFsurj : Function.Surjective ⇑F.hom := hbij.surjective
  have hcomp : F.hom = f.appTop.hom.comp (Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom := rfl
  rw [hcomp, RingHom.coe_comp] at hFsurj
  exact hFsurj.of_comp

namespace Scheme

namespace Over

/-- Scheme-level lift: two morphisms `f, g : C ⟶ A` in `Over (Spec k)`
agreeing on a non-empty open subset `U ⊆ C.left` are equal, when `A`
is separated over `Spec k`, `C.left` is reduced, and `C` is
geometrically irreducible over `Spec k`.

This is a thin renaming of the iter-125 packaging
`AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen` (in
`AlgebraicJacobian/Rigidity.lean`) under the
`Scheme.Over.ext_of_diff_zero` name committed by the iter-145
chart-algebra planner. Per the blueprint's three-step
proof recipe (`chapters/RigidityKbar.tex` §
`\lem:Scheme_Over_ext_of_diff_zero`), the iter-125 packaging
discharges Step 3 (the `ext_of_eqOnOpen` packaging) directly given the
`eqOnOpen` hypothesis. Iter-147+ will refine the signature to *also*
take a chart-algebra `df = dg` hypothesis and *derive* `eqOnOpen` from
it via Steps 1–2 of the recipe (chart-algebra
`df_zero_factors_through_constant_on_chart` β-core; currently a
deferred sub-piece, see L97 above). The lift here is the iter-146
sorry-free closure under the planner's chart-algebra envelope; the
substantive Steps 1–2 derivation lands once the β-core sub-piece
closes.

Hypotheses match `Scheme.Over.ext_of_eqOnOpen`; the renaming preserves
the iter-125 proof discipline that `IsSeparated A.hom` (not the
stronger `IsProper`) is sufficient for the rigidity packaging. -/
theorem ext_of_diff_zero
    {k : Type u} [Field k]
    {C A : Over (Spec (.of k))}
    [IsSeparated A.hom]
    [IsReduced C.left]
    [GeometricallyIrreducible C.hom]
    (f g : C ⟶ A) (U : C.left.Opens) (hU : (U : Set C.left).Nonempty)
    (hUf : (U.ι : (U : C.left.Opens).toScheme ⟶ C.left) ≫ f.left =
      (U.ι : (U : C.left.Opens).toScheme ⟶ C.left) ≫ g.left) :
    f = g :=
  AlgebraicGeometry.Scheme.Over.ext_of_eqOnOpen f g U hU hUf

end Over

end Scheme

end AlgebraicGeometry
