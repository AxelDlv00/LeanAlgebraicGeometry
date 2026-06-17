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
    {k : Type u} [Field k] [CharZero k]
    {B : Type u} [CommRing B] [Algebra k B] [Algebra.FiniteType k B]
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
  obtain ⟨bTilde, _hbTilde⟩ : ∃ bTilde : P.Ring, algebraMap P.Ring B bTilde = b :=
    _hπSurj b
  -- Functoriality of D: `D_B b = (map k k (MvPolynomial ι k) B)(D_{MvPoly} b̃)`.
  -- (HYBRID part (C) TRANSFER GAP — iter-151+):
  --
  -- From `hDb : D_B b = 0`, we have `D_{MvPoly} b̃` lies in the kernel of the
  -- functoriality map. Modifying `b̃` by elements of `ker π = I` to land
  -- `D_{MvPoly} b̃' = 0` in `Ω[MvPoly⁄k]` exactly requires the Leibniz-rule
  -- chase outlined above (S5.a). Once `b̃'` satisfies `D_{MvPoly} b̃' = 0`,
  -- `_mvPoly_mem_range_C_of_D_eq_zero b̃'` gives `b̃' ∈ MvPolynomial.C.range`,
  -- and `algebraMap k B = (algebraMap (MvPolynomial ι k) B) ∘ MvPolynomial.C`
  -- (`IsScalarTower k (MvPolynomial ι k) B`) closes the goal:
  -- `b = π b̃ = π b̃' = π(C r) = algebraMap k B r ∈ algebraMap.range`.
  --
  -- The full transfer is ~30 LOC of `KaehlerDifferential.ker_map_of_surjective`
  -- manipulation that requires careful unfolding of `Submodule.map`/
  -- `Finsupp.linearCombination` and the Leibniz rule on lifted relations.
  -- Recorded as iter-151+ closure point with the helper lemmas pre-staged.
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
    {k : Type u} [Field k] [CharZero k]
    {C : Scheme.{u}} [C.Over (Spec (CommRingCat.of k))]
    [IsProper (C ↘ Spec (CommRingCat.of k))]
    [Smooth (C ↘ Spec (CommRingCat.of k))]
    [IsReduced C]
    [GeometricallyIrreducible (C ↘ Spec (CommRingCat.of k))]
    {B : Type u} [CommRing B] [Algebra k B] [Algebra.FiniteType k B]
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
    {k : Type u} [Field k] {X : Scheme.{u}} [X.Over (Spec (.of k))]
    [IsProper (X ↘ Spec (.of k))]
    [Smooth (X ↘ Spec (.of k))]
    [IsReduced X]
    [GeometricallyIrreducible (X ↘ Spec (.of k))] :
    RingHom.range ((X ↘ Spec (CommRingCat.of k)).appTop.hom) = ⊤ := by
  -- Substep (1): IsReduced + GeometricallyIrreducible (over Spec k,
  -- a singleton) ⇒ X integral.
  haveI : IrreducibleSpace X :=
    GeometricallyIrreducible.irreducibleSpace_of_subsingleton
      (X ↘ Spec (CommRingCat.of k))
  haveI : IsIntegral X := isIntegral_of_irreducibleSpace_of_isReduced X
  -- Substep (2.a): IsProper extends UniversallyClosed, so Γ(X, ⊤) is a
  -- field by `isField_of_universallyClosed`.
  have _hΓfield : IsField ↑(X.presheaf.obj (Opposite.op ⊤)) :=
    isField_of_universallyClosed k (X ↘ Spec (CommRingCat.of k))
  -- Substep (2.b): the `appTop.hom` ring map is finite by
  -- `finite_appTop_of_universallyClosed` (uses `LocallyOfFiniteType`,
  -- supplied by `IsProper`).
  have _hAppTopFinite :
      ((X ↘ Spec (CommRingCat.of k)).appTop.hom).Finite :=
    finite_appTop_of_universallyClosed k (X ↘ Spec (CommRingCat.of k))
  -- Substep (3) (iter-148 smart-proof path (b)): reduce the
  -- surjectivity goal to the conjunction
  --   `IsPurelyInseparable k Γ(X, ⊤) ∧ Algebra.IsSeparable k Γ(X, ⊤)`
  -- and discharge via Mathlib's
  -- `IsPurelyInseparable.surjective_algebraMap_of_isSeparable`.
  --
  -- The iter-147 path (a) BUILD-IT chain (algclose base change + step
  -- (e) flat-base-change-of-Γ-for-proper-schemes) is moved below the
  -- main scaffold as a backup; the iter-148 prover lane commits to
  -- path (b) per `PROGRESS.md` § "Iter-148 planner path commitment".
  --
  -- Path (b) summary:
  --   (b.1) `Smooth (X ↘ Spec k)` ⇒ `Algebra.IsSeparable k Γ(X, ⊤)`.
  --         Mathlib b80f227 gap: no `Smooth ⇒ IsGeometricallyReduced`
  --         instance, and no `geom-reduced finite ext ⇒ separable`
  --         bridge in the snapshot. Two named structural sub-gaps:
  --         (S3.sep.1) `Smooth ⇒ Algebra.IsGeometricallyReduced k Γ`
  --         and (S3.sep.2) `geom-reduced field ext ⇒ separable`.
  --   (b.2) `GeometricallyIrreducible (X ↘ Spec k)` ⇒
  --         `IsPurelyInseparable k Γ(X, ⊤)`. Reduction chain:
  --         X_{\bar k} irreducible ⇒ `Γ(X_{\bar k}, ⊤)` is a domain;
  --         combine with the flat-base-change identification
  --         `Γ(X_{\bar k}, ⊤) ≅ Γ(X, ⊤) ⊗_k \bar k` (still the gap)
  --         ⇒ `Γ ⊗_k \bar k` has a unique minimal prime
  --         ⇒ `Γ/k` purely inseparable. Two named structural sub-gaps:
  --         (S3.pi.1) `Γ(X_{\bar k}, ⊤) ≅ Γ ⊗_k \bar k` (= step (e)
  --         "flat base change of Γ for proper schemes") and (S3.pi.2)
  --         "finite-dim algebra over a field with unique minimal
  --         prime ⇒ source is purely inseparable".
  --
  -- Net iter-148 structural reduction: the proof scaffold sets up the
  -- algebraic flow `appTop.hom surj ⟺ algebraMap k Γ surj
  -- ⟸ IsPurelyInseparable k Γ ∧ Algebra.IsSeparable k Γ`, so iter-149+
  -- can target the two named sub-claims directly without re-deriving
  -- the algebraic skeleton.
  rw [RingHom.range_eq_top]
  -- (a) Equip `Γ(X, ⊤)` with a `Field` structure via `_hΓfield`.
  letI _hΓfield' : Field ↥(X.presheaf.obj (Opposite.op ⊤)) := _hΓfield.toField
  -- Define the composition `k → Γ(Spec k, ⊤) → Γ(X, ⊤)` as a
  -- `CommRingCat`-morphism. The `(ΓSpecIso (.of k)).inv` arrow is the
  -- algebra-map `(.of k) ⟶ Γ(Spec (.of k), ⊤)`.
  set α : (CommRingCat.of k) ⟶ X.presheaf.obj (Opposite.op ⊤) :=
    (Scheme.ΓSpecIso (CommRingCat.of k)).inv ≫ (X ↘ Spec (CommRingCat.of k)).appTop with hαdef
  -- (a, cont.) Equip `Γ(X, ⊤)` with an `Algebra k`-structure via `α.hom`.
  letI algkΓ : Algebra k ↥(X.presheaf.obj (Opposite.op ⊤)) := α.hom.toAlgebra
  -- The `algebraMap k Γ` literal coincides with `α.hom` by `toAlgebra`.
  have h_algebraMap_eq :
      (algebraMap k ↥(X.presheaf.obj (Opposite.op ⊤))) = α.hom := rfl
  -- (a, cont.) Reduce surjectivity of `appTop.hom` to surjectivity of `algebraMap k Γ`.
  suffices h_surj : Function.Surjective
      (algebraMap k ↥(X.presheaf.obj (Opposite.op ⊤))) by
    intro y
    obtain ⟨c, hc⟩ := h_surj y
    refine ⟨(Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom c, ?_⟩
    -- `appTop.hom ∘ (ΓSpecIso).inv.hom = α.hom = algebraMap k Γ`.
    have hcomp :
        ((X ↘ Spec (CommRingCat.of k)).appTop.hom).comp
          ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom) = α.hom := by
      simp [hαdef, CommRingCat.hom_comp]
    have hcompc := congrArg (fun (f : k →+* _) => f c) hcomp
    simp only [RingHom.comp_apply] at hcompc
    -- `algebraMap k Γ c = y` from `hc`; rewrite `algebraMap` to `α.hom`.
    rw [hcompc]
    -- Now goal: `α.hom c = y`. By definitional `algebraMap = α.hom`.
    have hac : α.hom c = (algebraMap k ↥(X.presheaf.obj (Opposite.op ⊤))) c := by
      rw [h_algebraMap_eq]
    rw [hac]; exact hc
  -- (b.1) + (b.2): split into two named sub-sorries (iter-149 Lane 2
  -- structural refinement) so each can be closed independently once
  -- Lane 1 lands the (S3.*) bodies.
  --
  -- (b.2) `IsPurelyInseparable k Γ` ← GeometricallyIrreducible:
  --   For every field extension `K / k`, `X ×_k Spec K` is irreducible.
  --   In particular `X_{\bar k}` is irreducible. Combined with
  --   `IsReduced X_{\bar k}` (smooth-stable base change), get
  --   `IsIntegral X_{\bar k}`, hence `Γ(X_{\bar k}, ⊤)` is a domain.
  --   With the flat-base-change identification
  --   `Γ(X_{\bar k}, ⊤) ≅ Γ ⊗_k \bar k` from
  --   `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`
  --   ((S3.pi.1); body sorry, Lane 1), `Γ ⊗_k \bar k` has a unique
  --   minimal prime. Then
  --   `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`
  --   ((S3.pi.2); body sorry, Lane 1) closes pure inseparability.
  --
  -- (b.1) `Algebra.IsSeparable k Γ` ← Smooth:
  --   `AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth`
  --   ((S3.sep.1); body sorry, Lane 1) gives
  --   `Algebra.IsGeometricallyReduced k Γ`. Combined with
  --   `FiniteDimensional k Γ` (from `_hAppTopFinite` + the
  --   `Scheme.ΓSpecIso k` identification),
  --   `Algebra.IsSeparable.of_isGeometricallyReduced_of_finite`
  --   ((S3.sep.2); body sorry, Lane 1) closes separability.
  have ⟨hPI, hSep⟩ :
      IsPurelyInseparable k ↥(X.presheaf.obj (Opposite.op ⊤)) ∧
        Algebra.IsSeparable k ↥(X.presheaf.obj (Opposite.op ⊤)) := by
    refine ⟨?_, ?_⟩
    · -- (b.2) `IsPurelyInseparable k Γ`.
      --
      -- The full wiring chain is:
      --   (i) `GeometricallyIrreducible (X ↘ Spec k)` propagates to
      --       `IrreducibleSpace X_{\bar k}` (via
      --       `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`
      --       applied to `Spec \bar k`).
      --   (ii) Smoothness propagates under base change to give
      --        `IsReduced X_{\bar k}` (via `Smooth.isReduced` over
      --        a perfect base; here `\bar k` is even algebraically closed).
      --   (iii) Combining gives `IsIntegral X_{\bar k}` and hence
      --         `Γ(X_{\bar k}, ⊤)` is a domain.
      --   (iv) Apply (S3.pi.1)
      --        `AlgebraicGeometry.Gamma_baseChange_iso_tensor_of_proper`
      --        to identify `Γ ⊗_k \bar k ≃ₐ[\bar k] Γ(X_{\bar k}, ⊤)`.
      --        The domain property transports, so `Γ ⊗_k \bar k` is a
      --        domain ⇒ `(minimalPrimes (Γ ⊗_k \bar k)).Subsingleton`.
      --   (v)  Apply (S3.pi.2)
      --        `Algebra.IsPurelyInseparable.of_unique_minPrime_baseChange`
      --        to extract `IsPurelyInseparable k Γ`.
      --
      -- The chain requires `FiniteDimensional k Γ` for step (v); see
      -- the (b.1) branch below for the corresponding bridge from
      -- `_hAppTopFinite` to `FiniteDimensional k Γ`. Both branches
      -- collapse to a single bridge once shared. Iter-150+ closure.
      sorry
    · -- (b.1) `Algebra.IsSeparable k Γ`. The branch is closed
      -- project-internally; the only residual sorries are the bodies
      -- of `(S3.sep.1) isGeometricallyReduced_Gamma_of_smooth` and
      -- `(S3.sep.2) IsSeparable.of_isGeometricallyReduced_of_finite`
      -- in `ChartAlgebraS3.lean` (Lane 1, both sorries iter-149).
      --
      -- Step 1: extract geometrically-reduced via (S3.sep.1).
      haveI _hGR : Algebra.IsGeometricallyReduced k
          ↥(X.presheaf.obj (Opposite.op ⊤)) :=
        AlgebraicGeometry.isGeometricallyReduced_Gamma_of_smooth
      -- Step 2: bridge `_hAppTopFinite : (.appTop.hom).Finite` to
      -- `Module.Finite k Γ` (= `FiniteDimensional k Γ` under the
      -- `Field k`-`Field Γ` setup). Chain:
      --   `(ΓSpecIso (.of k)).inv.hom : (.of k) →+* Γ(Spec(.of k), ⊤)`
      --     is a ring iso (extracted via `Iso.commRingCatIsoToRingEquiv`),
      --     hence `.Finite` via `RingEquiv.finite`.
      --   `(.appTop.hom) : Γ(Spec(.of k), ⊤) →+* Γ` is `.Finite`
      --     by `_hAppTopFinite`.
      --   Composing via `RingHom.Finite.comp` gives `α.hom.Finite`.
      --   `α.hom = algebraMap k Γ` by `algkΓ := α.hom.toAlgebra`.
      --   So `RingHom.finite_algebraMap.mp` gives `Module.Finite k Γ`.
      have hαFinite : (CommRingCat.Hom.hom α).Finite := by
        have hiso : ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom).Finite :=
          (CategoryTheory.Iso.commRingCatIsoToRingEquiv
            (Scheme.ΓSpecIso (CommRingCat.of k))).symm.finite
        have hαeq : (CommRingCat.Hom.hom α) =
            ((X ↘ Spec (CommRingCat.of k)).appTop.hom).comp
              ((Scheme.ΓSpecIso (CommRingCat.of k)).inv.hom) := by
          simp [hαdef, CommRingCat.hom_comp]
        rw [hαeq]; exact _hAppTopFinite.comp hiso
      haveI : Module.Finite k ↥(X.presheaf.obj (Opposite.op ⊤)) :=
        RingHom.finite_algebraMap.mp hαFinite
      -- Step 3: apply (S3.sep.2) to close.
      exact Algebra.IsSeparable.of_isGeometricallyReduced_of_finite k _
  haveI := hPI; haveI := hSep
  -- Conclude via Mathlib's `surjective_algebraMap_of_isSeparable`.
  exact IsPurelyInseparable.surjective_algebraMap_of_isSeparable k
    ↥(X.presheaf.obj (Opposite.op ⊤))

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
