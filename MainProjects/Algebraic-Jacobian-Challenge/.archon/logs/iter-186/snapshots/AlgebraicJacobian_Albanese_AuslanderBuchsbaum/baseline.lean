/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Auslander–Buchsbaum formula (A.4.b)

This file is the **A.4.b** file-skeleton sub-build chapter for the project's
positive-genus arm of `nonempty_jacobianWitness`. It packages the
Auslander–Buchsbaum formula and the corollary "regular local ring
⟹ Cohen–Macaulay" that the sibling sub-build **A.4.a** (codim-1 extension of a
rational map across a codim-2 closed point on a regular projective surface)
consumes.

Per STRATEGY.md L30 this row is gated downstream on A.4.a but is independently
startable on the Mathlib side: the algebra here is decoupled from the Albanese
geometry and lives entirely under `RingTheory.*`. Mathlib at the project's
pinned commit (`b80f227`) exposes `IsRegularLocalRing` and the categorical
`CategoryTheory.projectiveDimension` on an abelian category (specialised to
`ModuleCat R`), as well as the regular-sequence definition
`RingTheory.Sequence.IsRegular`. The depth function `Module.depth`, the
Auslander–Buchsbaum formula, and the Cohen–Macaulay predicate are *not* in
Mathlib at the pinned commit — they are the new content scaffolded here.

## Status (iter-178 update — projectiveDimension closed)

This file was originally landed iter-175 (Lane F file-skeleton) with each
blueprint-pinned declaration carrying the *intended* substantive type
signature (matching the `\lean{...}` pin in
`blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`). The bodies were
scheduled for iter-176+ work; the chapter is independent of the rest of
Route A's geometric infrastructure, making it a good parallel-work
candidate.

iter-178 closed `Module.projectiveDimension` kernel-clean as a one-liner
re-export of the categorical `CategoryTheory.projectiveDimension`. The
remaining five typed `sorry` bodies (`depth`, `depth_eq_smallest_ext_index`,
`depth_of_short_exact`, `auslander_buchsbaum_formula`,
`CohenMacaulay.of_regular`) are substantive multi-iter content and stay
gated on dedicated body lanes.

The 7 pinned declarations are:

1. `RingTheory.Module.depth` (noncomputable def, ~6 LOC) — the `I`-depth of a
   finite `R`-module as the supremum of lengths of `M`-regular sequences in
   `I`, valued in `ℕ∞`.
2. `RingTheory.Module.depth_eq_smallest_ext_index` (theorem, ~10 LOC) — for
   `(R, 𝔪)` Noetherian local and `M ≠ 0` finite, `depth(M)` equals the
   smallest `i` with `Ext^i_R(κ, M) ≠ 0`. Encoded via the depth-bound iff
   `Ext` vanishes below.
3. `Module.projectiveDimension` (noncomputable def, ~3 LOC) — an
   `R`-module-side wrapper for the categorical
   `CategoryTheory.projectiveDimension (ModuleCat.of R M)`. The categorical
   version exists in Mathlib `b80f227`; this is the re-export pinned by the
   blueprint.
4. `RingTheory.depth_of_short_exact` (theorem, ~12 LOC) — the
   depth-on-a-short-exact-sequence inequalities (Stacks 00LE).
5. `RingTheory.auslander_buchsbaum_formula` (theorem, ~10 LOC) — the formula
   `pd_R(M) + depth(M) = depth(R)` for a nonzero finite `R`-module of finite
   projective dimension over a Noetherian local ring.
6. `RingTheory.CohenMacaulay` (class, ~3 LOC) — `IsCohenMacaulayLocalRing R`
   encoded as `depth(R) = krullDim R`.
7. `RingTheory.CohenMacaulay.of_regular` (theorem, ~6 LOC) — a regular local
   ring is Cohen–Macaulay (the consumer-facing input for A.4.a).

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof", each
declaration carries a substantive, non-tautological type:

- `depth` returns `ℕ∞` and is defined by the regular-sequence supremum.
- `depth_eq_smallest_ext_index` is encoded as the depth-bound `↔` `Ext`
  vanishing characterisation (the smallest non-vanishing `Ext` index = depth).
- `projectiveDimension` re-exports the categorical
  `CategoryTheory.projectiveDimension` on `ModuleCat.of R M`.
- `depth_of_short_exact` packages the three Stacks 00LE inequalities into a
  conjunction.
- `auslander_buchsbaum_formula` is the numeric equation
  `pd + depth = depth(R)`.
- `CohenMacaulay` is the equation `depth(R) = ringKrullDim R`.
- `CohenMacaulay.of_regular` is an `IsRegularLocalRing → IsCohenMacaulayLocalRing`
  implication, the consumer-facing statement.

Unfolding any declaration exposes the named substantive content (a regular-
sequence supremum, an `Ext`-vanishing characterisation, the categorical
projective dimension, …); no `Iso.refl _` / `Classical.choice ⟨witness⟩` /
empty-content `proof_wanted` placeholders are used.

## References

Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex` (~560 LOC,
7 pins). Stacks Project tags 00LF (definition-depth), 00LP (lemma-depth-ext),
00LE (lemma-depth-in-ses), 090V (proposition-Auslander–Buchsbaum), 00N4
(definition-local-ring-CM), 00OD (lemma-regular-ring-CM). Matsumura,
*Commutative Ring Theory*, Theorem 19.1. Auslander–Buchsbaum, "Homological
dimension in local rings", 1957.
-/

set_option autoImplicit false

universe u v

open CategoryTheory

namespace RingTheory

namespace Module

/-! ## §1. Depth of a finite module

The `I`-depth of a finite `R`-module `M` is the supremum in
`{0, 1, 2, …, ∞}` of the lengths of `M`-regular sequences contained in `I`
(provided `IM ≠ M`; if `IM = M` we set `depth_I(M) = ∞`). Mathlib `b80f227`
exposes the regular-sequence predicate `RingTheory.Sequence.IsRegular`
(`Mathlib.RingTheory.Regular.RegularSequence`) but not the resulting
numeric depth function — that is the gap this declaration fills.

Blueprint reference: `def:depth` (Stacks tag 00LF). -/

/-- The **`I`-depth** of a finite `R`-module `M`: the supremum (in `ℕ∞`) of
lengths of `M`-regular sequences contained in the ideal `I`.

When `IM = M` (the "trivial-quotient" case, e.g. `M = 0` or `I = R`) the
supremum is taken to be `⊤` by convention. When `(R, 𝔪)` is local one usually
calls `depth (IsLocalRing.maximalIdeal R) M` simply *the depth* of `M`.

iter-176+: the body is the supremum
```
sSup { (n : ℕ∞) | ∃ rs : List R, rs.length = n ∧ (∀ r ∈ rs, r ∈ I) ∧
                  RingTheory.Sequence.IsRegular M rs }
```
folded with the `IM = M` clause. The signature is non-tautological: it
asserts a function `(Ideal R) → (M : Type v) → ℕ∞` matching the Stacks
00LF definition.

**iter-179 Mathlib-gap check (Lane F Target 2 STRETCH)**: a pinned-commit
audit of `Mathlib.RingTheory.Regular.Depth` (the only file under
`Mathlib/RingTheory/*` containing the word "depth") confirms that Mathlib
`b80f227` ships only depth-zero lemmas (`IsSMulRegular.subsingleton_linearMap_iff`)
and *not* the numeric depth function itself. The one-liner re-export route
is therefore not available; the body stays a typed `sorry` until an
iter-180+ body lane fills the supremum-with-`IM=M` clause directly. -/
noncomputable def depth {R : Type u} [CommRing R] (_I : Ideal R)
    (_M : Type v) [AddCommGroup _M] [Module R _M] : ℕ∞ :=
  open Classical in
  if _I • (⊤ : Submodule R _M) = ⊤ then (⊤ : ℕ∞)
  else sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
    (∀ r ∈ rs, r ∈ _I) ∧ RingTheory.Sequence.IsRegular _M rs }

end Module

end RingTheory

/-! ## §2. Projective dimension

Mathlib `b80f227` exposes the categorical
`CategoryTheory.projectiveDimension : C → WithBot ℕ∞` on an abelian category
with enough projectives (file `Mathlib.CategoryTheory.Abelian.Projective.Dimension`).
For `R`-modules this specialises to `ModuleCat.of R M`. The blueprint pins the
`Module.projectiveDimension` name as the re-export that downstream consumers
can use directly on an `R`-module without first packaging it in `ModuleCat`.

Blueprint reference: `def:projective_dimension`. -/

namespace Module

/-- The **projective dimension** of an `R`-module `M`, defined as the
categorical projective dimension of `ModuleCat.of R M`.

This is a re-export of `CategoryTheory.projectiveDimension` specialised to
the abelian category `ModuleCat R`. The categorical definition is the
infimum (in `WithBot ℕ∞`) of `n : ℕ` such that all `Ext^i(M, -)` vanish for
`i > n`, equivalently the smallest length of a projective resolution of `M`.

Mathlib has the categorical `projectiveDimension` and the module-specific
`ModuleCat.projectiveDimension_eq_of_linearEquiv`; the blueprint pins the
wrapper name so downstream consumers can write
`Module.projectiveDimension R M` rather than threading `ModuleCat.of`.

The body is the one-line re-export
`CategoryTheory.projectiveDimension (ModuleCat.of R _M)`; iter-178 closed
this declaration kernel-clean. -/
noncomputable def projectiveDimension (R : Type u) [Ring R]
    (_M : Type u) [AddCommGroup _M] [Module R _M] : WithBot ℕ∞ :=
  CategoryTheory.projectiveDimension (ModuleCat.of R _M)

end Module

namespace RingTheory

namespace Module

/-! ## §3. Depth via Ext characterisation

For a Noetherian local ring `(R, 𝔪)` with residue field `κ = R/𝔪` and a
nonzero finite `R`-module `M`, the depth of `M` equals the smallest index `i`
at which `Ext^i_R(κ, M)` is nonzero (Stacks tag 00LP).

This is the lemma A.4.a's downstream consumer ultimately reads off:
combined with the regular-sequence definition (`depth`), the Ext
characterisation provides both the *lower bound* (regular sequences exhibit
`Ext^i = 0` for `i < length(rs)`) and the *upper bound* (failure of any
extension lifts a non-zero element in `Ext^{depth}(κ, M)`).

The signature pins the equivalence via the depth-bound `↔` `Ext`-vanishing-
below: `n ≤ depth(M) ↔ Ext^i(κ, M) = 0 for all i < n`. This is logically
equivalent to "depth(M) = smallest i with Ext^i ≠ 0" and is the form most
convenient for inductive proofs (Stacks 00LP proof: pick `x ∈ 𝔪`
non-zero-divisor, use long exact `Ext^*(κ, -)` on `0 → M → M → M/xM → 0`).

Blueprint reference: `lem:depth_via_ext` (Stacks tag 00LP). -/

/-! ### Helper C (iter-183 Lane G, axiom-clean): `Ann`-killing of Ext via R-linearity

For any `R`-modules `N, M` and any `x : R` in the annihilator of `N`, the
R-action `x • e` on `e : Ext^i_R(N, M)` is zero.

Proof sketch: `x • e = (mk₀ (x • 𝟙_N)).comp e (zero_add i)` (by R-linearity:
`mk₀_smul + smul_comp + mk₀_id_comp`). For `x ∈ Ann(N)` the morphism
`x • 𝟙_N : N ⟶ N` is the zero map, so `mk₀ (x • 𝟙_N) = mk₀ 0 = 0`
(`mk₀_zero`), and `0.comp e = 0` (`zero_comp`).

iter-183 Lane G: closed kernel-clean. This is the precise statement of the
Stacks-00LP "`x ∈ 𝔪` annihilates `Ext^*(κ, -)`" trick, lifted to the more
general `x ∈ Ann(N)` form so it covers both `N = κ` and `N = R/(x_1,…,x_k)`. -/
private lemma ext_smul_eq_zero_of_mem_annihilator
    {R : Type u} [CommRing R]
    {N M : ModuleCat.{u} R} {i : ℕ} (e : Abelian.Ext.{u} N M i)
    {x : R} (hx : x ∈ Module.annihilator R (N : Type u)) :
    x • e = 0 := by
  -- Step 1: x • 𝟙_N = 0 in ModuleCat (the underlying linear map sends m ↦ x • m,
  -- which is 0 since x ∈ Ann(N)).
  have hkill : (x • (𝟙 N : N ⟶ N)) = (0 : N ⟶ N) := by
    apply ModuleCat.hom_ext
    apply LinearMap.ext
    intro n
    change x • n = 0
    exact Module.mem_annihilator.mp hx n
  -- Step 2: x • e = (mk₀ (x • 𝟙_N)).comp e (zero_add i) by R-linearity.
  have hreflect :
      (CategoryTheory.Abelian.Ext.mk₀ (x • (𝟙 N : N ⟶ N))).comp e (zero_add i)
        = x • e := by
    have hmk : (CategoryTheory.Abelian.Ext.mk₀ (x • (𝟙 N : N ⟶ N))
                : Abelian.Ext.{u} N N 0)
        = x • CategoryTheory.Abelian.Ext.mk₀ (𝟙 N) :=
      CategoryTheory.Abelian.Ext.mk₀_smul (R := R) x (𝟙 N)
    rw [hmk, CategoryTheory.Abelian.Ext.smul_comp,
        CategoryTheory.Abelian.Ext.mk₀_id_comp]
  -- Step 3: substitute hkill to collapse mk₀ … to mk₀ 0 = 0, then zero_comp.
  rw [← hreflect, hkill, CategoryTheory.Abelian.Ext.mk₀_zero,
      CategoryTheory.Abelian.Ext.zero_comp]

/-- **Depth via Ext characterisation.** For a Noetherian local ring `(R, 𝔪)`
with residue field `κ = R/𝔪` and a nonzero finite `R`-module `M`, the
depth-bound `n ≤ depth(M)` is equivalent to the vanishing of `Ext^i_R(κ, M)`
for all `i < n`. Equivalently, `depth(M)` is the smallest `i` at which
`Ext^i_R(κ, M)` is nonzero.

iter-176+: the body proceeds by induction on `n` via the long exact sequence
of `Ext^*(κ, -)` applied to `0 → M → M → M/xM → 0` for a non-zero-divisor
`x ∈ 𝔪`. The base case `n = 0` is `Hom(κ, M) ≠ 0 ↔ depth(M) = 0`, which is
the standard "the maximal ideal contains a zero-divisor on `M` iff
`𝔪 ∈ Ass(M)`" characterisation (Stacks 00LC).

iter-183 Lane G structural progress:
* Generalised the inductive hypothesis over `M` (so `ih` is universally
  quantified in `M`, allowing recursive use on `M/xM`).
* Base case `n = 0` closed kernel-clean (both directions trivial).
* New axiom-clean helper `ext_smul_eq_zero_of_mem_annihilator` (lines
  229–254) discharges substantive piece (a) of the Stacks 00LP proof:
  *"`x ∈ Ann N` annihilates `Ext^*(N, ·)`"*, via
  `mk₀_smul + smul_comp + mk₀_id_comp + mk₀_zero + zero_comp`.
* The inductive step's **backward direction** has the regular-element
  extraction stage closed structurally: from the `Ext^0(κ, M) = 0`
  hypothesis we derive `Subsingleton (κ →ₗ[R] M)` (via `mk₀_eq_zero_iff +
  ModuleCat.hom_ext_iff`) and then invoke
  `IsSMulRegular.subsingleton_linearMap_iff` + `Ideal.annihilator_quotient`
  to obtain `x ∈ 𝔪` with `IsSMulRegular M x`, with
  `nontrivial_quotSMulTop_of_mem_maximalIdeal` providing the `Nontrivial
  (M/xM)` instance for the recursive IH application.

Residual `sorry`s (2 named inline branches):
1. **Forward direction**  `(n+1 : ℕ∞) ≤ depth M → ∀ i ≤ n, Ext^i(κ, M) = 0` —
   needs: extract regular sequence of length n+1 from supremum (handle `⊤`
   via Nakayama); cons-decompose via `isRegular_cons_iff`; LES of Ext on
   `IsSMulRegular.smulShortComplex_shortExact`; recurse via `ih` on M/xM.
2. **Backward direction**, final assembly — after the regular-element
   extraction (already done), needs: LES chase to derive Ext-vanishing on
   M/xM at indices `j < n` (using the new helper to kill the
   multiplication-by-x maps); apply `ih (M := M/xM)` to obtain regular
   sequence `rs'`; cons `x :: rs'`; conclude via `le_sSup`. -/
theorem depth_eq_smallest_ext_index
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M] (n : ℕ) :
    (n : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) M ↔
      ∀ i : ℕ, i < n →
        ∀ e : Abelian.Ext.{u}
            (ModuleCat.of R (IsLocalRing.ResidueField R))
            (ModuleCat.of R M) i, e = 0 := by
  -- We generalize `M` so the inductive hypothesis is universally quantified
  -- over the module — this lets the induction step recursively apply the IH
  -- to the quotient `M / xM` (a *different* module of the same shape).
  induction n generalizing M with
  | zero =>
    -- LHS: `(0 : ℕ∞) ≤ depth M` is `bot_le`.
    -- RHS: `∀ i < 0, …` is vacuous since no `i` satisfies `i < 0`.
    exact ⟨fun _ i hi _ => absurd hi (Nat.not_lt_zero i), fun _ => bot_le⟩
  | succ n ih =>
    -- The Stacks 00LP inductive step. The blueprint sketch is:
    --
    -- (⇒) Assume `(n+1 : ℕ∞) ≤ depth M`. Then `Nontrivial M` rules out
    --     `𝔪 • ⊤ = ⊤` (Nakayama), so `depth M` is the supremum and we can
    --     extract an `M`-regular sequence `rs = x :: rs'` of length `n+1` in
    --     `𝔪`. The cons-decomposition `RingTheory.Sequence.isRegular_cons_iff`
    --     gives `IsSMulRegular M x` and `IsRegular (QuotSMulTop x M) rs'`.
    --     For `i = 0`: `Hom(κ, M) ↪ Hom(κ, M)` via `[x]` is `[x]` on the
    --     domain `Hom(κ, M)`, but `x ∈ 𝔪 = Ann(κ)` kills this on the κ side,
    --     so `Hom(κ, M) = 0`. Pass to `Ext^0` via `addEquiv₀`.
    --     For `1 ≤ i ≤ n`: the SES `0 → M →[x] M → M/xM → 0` (built via
    --     `IsSMulRegular.smulShortComplex_shortExact`) plus the fact that
    --     `[x]_*` is zero on `Ext^i(κ, M)` (because `x ∈ Ann κ` ⇒
    --     `x • 𝟙_κ = 0`, hence by `precomp_smul = smul_precomp` the
    --     R-action on `Ext^i(κ, M)` is annihilated by `x`) lets the
    --     LES connecting map `Ext^{i-1}(κ, M/xM) ↠ Ext^i(κ, M)` be
    --     surjective.  By IH applied to `M/xM` (we get `n ≤ depth (M/xM)`,
    --     so `Ext^j(κ, M/xM) = 0` for `j < n`) we conclude
    --     `Ext^i(κ, M) = 0` for `1 ≤ i ≤ n`.
    --
    -- (⇐) Assume `∀ i < n+1, ∀ e ∈ Ext^i(κ, M), e = 0`.
    --     Specialise at `i = 0` and use `Ext.addEquiv₀` to extract
    --     `Subsingleton (κ →ₗ[R] M)`.  Apply
    --     `IsSMulRegular.subsingleton_linearMap_iff` (Mathlib) with
    --     `N := ResidueField R` and `Module.annihilator R (ResidueField R) =
    --     maximalIdeal R` to obtain `x ∈ 𝔪` with `IsSMulRegular M x`.
    --     The SES + same "x annihilates Ext^*(κ, ·)" fact give
    --     `Ext^j(κ, M/xM) = 0` for `j < n` (via the LES at indices `j ≤ n-1`).
    --     `M/xM := QuotSMulTop x M` is `Nontrivial` by
    --     `nontrivial_quotSMulTop_of_mem_maximalIdeal` and `Module.Finite`
    --     as a quotient.  Apply `ih` on `M/xM` at index `n` to get a
    --     regular sequence `rs'` of length `n` in `𝔪` on `M/xM`.  Then
    --     `x :: rs'` is a regular sequence of length `n+1` in `𝔪` on `M`
    --     by `RingTheory.Sequence.isRegular_cons_iff`. This gives
    --     `(n+1 : ℕ∞) ≤ depth M` via `le_sSup` on the depth supremum.
    --
    -- iter-183: the helper `ext_smul_eq_zero_of_mem_annihilator` above closes
    -- the substantive piece (a) "`x ∈ Ann N` annihilates `Ext^i(N, M)`"; this
    -- is the algebraic fact under both directions of the iff. The remaining
    -- pieces are LES-of-Ext bookkeeping + supremum-extraction.
    --
    -- The remaining substantive Mathlib gaps for closing this step are:
    --   (b) Extracting `Module.annihilator R (ResidueField R) = maximalIdeal R`
    --       (a one-liner via `Ideal.annihilator_quotient`).
    --   (c) The "sSup gives a witness of length ≥ n+1" reasoning, which
    --       in `ℕ∞` requires handling the `⊤` case (Nakayama rules it out
    --       under `Nontrivial M`).
    --   (d) Lifting `IsSMulRegular`-cons via `isRegular_cons_iff`.
    --
    -- We open the backward direction's regular-element-extraction step
    -- below to expose the API path for the next iter; the forward
    -- direction's regular-sequence-extraction + LES chase is the larger
    -- body remaining as `sorry`.
    refine ⟨?_, ?_⟩
    · -- (⇒) Forward direction: `(n+1 : ℕ∞) ≤ depth M → ∀ i ≤ n, Ext^i(κ, M) = 0`.
      -- iter-184 Lane G: closed via Nakayama-driven `depth = sSup`
      -- extraction + cons-decomposition + LES chase using
      -- `ext_smul_eq_zero_of_mem_annihilator` + `covariant_sequence_exact₁`.
      intro _hdepth i _hi _e
      -- Step 1: unfold `depth M = sSup S_M` (Nakayama rules out `𝔪 • ⊤ = ⊤`).
      have hne_M : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R M) ≠ ⊤ :=
        Ne.symm (Submodule.top_ne_ideal_smul_of_le_jacobson_annihilator
          (IsLocalRing.maximalIdeal_le_jacobson _))
      have hdepth_M_unfold :
          depth (IsLocalRing.maximalIdeal R) M
            = sSup { k : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = k ∧
              (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
              ∧ RingTheory.Sequence.IsRegular M rs } := by
        rw [depth, if_neg hne_M]
      -- Step 2: extract a regular sequence rs of length > n in 𝔪 on M.
      have hlt : (n : ℕ∞) < depth (IsLocalRing.maximalIdeal R) M := by
        calc (n : ℕ∞)
            < ((n + 1 : ℕ) : ℕ∞) := by exact_mod_cast Nat.lt_succ_self n
          _ ≤ _ := _hdepth
      rw [hdepth_M_unfold] at hlt
      obtain ⟨k, ⟨rs, hrs_len, hrs_mem, hrs_reg⟩, hk_lt⟩ := lt_sSup_iff.mp hlt
      have hrs_len_gt : n < rs.length := by
        rw [← hrs_len] at hk_lt
        exact_mod_cast hk_lt
      -- Step 3: rs is non-empty (length > n ≥ 0); decompose rs = x :: rs_tail.
      rcases rs with _ | ⟨x, rs_tail⟩
      · -- impossible: empty list has length 0, not > n.
        simp at hrs_len_gt
      have hxMem : x ∈ IsLocalRing.maximalIdeal R := hrs_mem x List.mem_cons_self
      have htail_mem : ∀ r ∈ rs_tail, r ∈ IsLocalRing.maximalIdeal R := fun r hr =>
        hrs_mem r (List.mem_cons_of_mem _ hr)
      have hcons := (RingTheory.Sequence.isRegular_cons_iff M x rs_tail).mp hrs_reg
      have hxReg : IsSMulRegular M x := hcons.1
      have hrs_tail_reg : RingTheory.Sequence.IsRegular (QuotSMulTop x M) rs_tail :=
        hcons.2
      have htail_len_ge : n ≤ rs_tail.length := by
        have h1 : n < (x :: rs_tail).length := hrs_len_gt
        simp [List.length_cons] at h1
        omega
      -- Step 4: `x ∈ Ann(κ)` via `Ideal.annihilator_quotient`.
      have hannih : Module.annihilator R (IsLocalRing.ResidueField R) =
          IsLocalRing.maximalIdeal R := Ideal.annihilator_quotient
      have hxAnnih : x ∈ Module.annihilator R (IsLocalRing.ResidueField R) :=
        hannih ▸ hxMem
      -- Step 5: build MxM and show depth MxM ≥ n via the prefix rs_tail.take n.
      let MxM : Type u := QuotSMulTop x M
      haveI : Nontrivial MxM :=
        nontrivial_quotSMulTop_of_mem_maximalIdeal M hxMem
      haveI : _root_.Module.Finite R MxM := inferInstance
      have hne_MxM : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R MxM) ≠ ⊤ :=
        Ne.symm (Submodule.top_ne_ideal_smul_of_le_jacobson_annihilator
          (IsLocalRing.maximalIdeal_le_jacobson _))
      let rs_n := rs_tail.take n
      have hrs_n_len : rs_n.length = n := by
        change (rs_tail.take n).length = n
        rw [List.length_take]
        omega
      have hrs_n_mem : ∀ r ∈ rs_n, r ∈ IsLocalRing.maximalIdeal R := fun r hr =>
        htail_mem r (List.mem_of_mem_take hr)
      have hrs_n_reg : RingTheory.Sequence.IsRegular MxM rs_n := by
        change RingTheory.Sequence.IsRegular MxM (rs_tail.take n)
        have hsplit : rs_tail = rs_tail.take n ++ rs_tail.drop n :=
          (List.take_append_drop _ _).symm
        have hwr : RingTheory.Sequence.IsWeaklyRegular MxM rs_tail :=
          hrs_tail_reg.toIsWeaklyRegular
        rw [hsplit] at hwr
        have hwr_n : RingTheory.Sequence.IsWeaklyRegular MxM (rs_tail.take n) :=
          ((RingTheory.Sequence.isWeaklyRegular_append_iff MxM _ _).mp hwr).1
        exact (IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal
          hrs_n_mem).mpr hwr_n
      have hdepth_MxM : (n : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) MxM := by
        rw [depth, if_neg hne_MxM]
        apply le_sSup
        refine ⟨rs_n, ?_, hrs_n_mem, hrs_n_reg⟩
        exact_mod_cast hrs_n_len
      -- Step 6: apply ih (M := MxM) at index n.
      have hMxM_vanish : ∀ j < n, ∀ e : Abelian.Ext.{u}
          (ModuleCat.of R (IsLocalRing.ResidueField R))
          (ModuleCat.of R MxM) j, e = 0 :=
        (ih (M := MxM)).mp hdepth_MxM
      -- Step 7: LES chase. Set up SES.
      let S : ShortComplex (ModuleCat.{u} R) :=
        ModuleCat.smulShortComplex (ModuleCat.of R M) x
      have hS : S.ShortExact := hxReg.smulShortComplex_shortExact
      -- `S.f = x • 𝟙_M` (definitional), hence `mk₀ S.f = x • mk₀ 𝟙`, hence
      -- `_e.comp (mk₀ S.f) (add_zero i) = x • _e = 0` (by helper at `x ∈ Ann κ`).
      have hSf_eq_smul : S.f = x • (𝟙 (ModuleCat.of R M) : _ ⟶ _) := rfl
      have hSf_kill :
          _e.comp (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero i) = 0 := by
        have hcomp :
            _e.comp (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero i) = x • _e := by
          rw [hSf_eq_smul]
          exact (CategoryTheory.Abelian.Ext.smul_eq_comp_mk₀ _e x).symm
        rw [hcomp]
        exact ext_smul_eq_zero_of_mem_annihilator _e hxAnnih
      -- Split on i = 0 vs i ≥ 1.
      rcases Nat.eq_zero_or_pos i with hi0 | hi_pos
      · subst hi0
        -- Use mono S.f (since hxReg) + postcomp_mk₀_injective_of_mono.
        haveI hmono : CategoryTheory.Mono S.f := by
          rw [ModuleCat.mono_iff_injective]
          exact hxReg
        have hinj := CategoryTheory.Abelian.Ext.postcomp_mk₀_injective_of_mono
          (ModuleCat.of R (IsLocalRing.ResidueField R)) S.f
        apply hinj
        change _e.comp (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero 0)
          = (0 : Abelian.Ext.{u} (ModuleCat.of R (IsLocalRing.ResidueField R))
              (ModuleCat.of R M) 0).comp (CategoryTheory.Abelian.Ext.mk₀ S.f)
              (add_zero 0)
        rw [CategoryTheory.Abelian.Ext.zero_comp]
        exact hSf_kill
      · -- i ≥ 1: write i = j + 1, then j < n and use covariant_sequence_exact₁.
        obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero
          (Nat.pos_iff_ne_zero.mp hi_pos)
        have hj : j < n := by omega
        obtain ⟨x₃, hx₃⟩ :=
          CategoryTheory.Abelian.Ext.covariant_sequence_exact₁
            (ModuleCat.of R (IsLocalRing.ResidueField R)) hS _e hSf_kill rfl
        have hx₃_zero : x₃ = 0 := hMxM_vanish j hj _
        rw [hx₃_zero] at hx₃
        simpa using hx₃.symm
    · -- (⇐) Backward direction: `(∀ i ≤ n, Ext^i(κ, M) = 0) → (n+1 : ℕ∞) ≤ depth M`.
      intro hext
      -- Step 1: From Ext^0(κ, M) = 0, extract `Subsingleton (κ →ₗ[R] M)`.
      -- For all R-linear maps `f g : κ →ₗ[R] M`, `mk₀ (ofHom f) = 0` in Ext^0
      -- (by `hext 0`), so via `mk₀_eq_zero_iff` the morphism `ofHom f = 0`,
      -- hence `f = 0`.  Both `f = 0 = g`.
      have hext0 : ∀ e : Abelian.Ext.{u}
          (ModuleCat.of R (IsLocalRing.ResidueField R))
          (ModuleCat.of R M) 0, e = 0 := hext 0 (Nat.succ_pos n)
      have hsubsing : Subsingleton (IsLocalRing.ResidueField R →ₗ[R] M) := by
        refine ⟨fun f g => ?_⟩
        have hf : (ModuleCat.ofHom f : ModuleCat.of R _ ⟶ ModuleCat.of R M) = 0 :=
          (CategoryTheory.Abelian.Ext.mk₀_eq_zero_iff (ModuleCat.ofHom f)).mp
            (hext0 _)
        have hg : (ModuleCat.ofHom g : ModuleCat.of R _ ⟶ ModuleCat.of R M) = 0 :=
          (CategoryTheory.Abelian.Ext.mk₀_eq_zero_iff (ModuleCat.ofHom g)).mp
            (hext0 _)
        have hf' : f = 0 := ModuleCat.hom_ext_iff.mp hf
        have hg' : g = 0 := ModuleCat.hom_ext_iff.mp hg
        rw [hf', hg']
      -- Step 2: Apply `subsingleton_linearMap_iff` to extract a regular element.
      -- The annihilator of `R ⧸ maximalIdeal R = ResidueField R` is `maximalIdeal R`
      -- by `Ideal.annihilator_quotient` (under the two-sided instance — automatic
      -- for commutative R).
      have hannih : Module.annihilator R (IsLocalRing.ResidueField R) =
          IsLocalRing.maximalIdeal R :=
        Ideal.annihilator_quotient
      have ⟨x, hxAnnih, hxReg⟩ :=
        IsSMulRegular.subsingleton_linearMap_iff.mp hsubsing
      have hxMem : x ∈ IsLocalRing.maximalIdeal R := hannih ▸ hxAnnih
      -- Step 3: Pass to `M/xM := QuotSMulTop x M` and apply IH at index n.
      -- iter-184+: the remaining LES chase to derive Ext-vanishing on M/xM,
      -- application of IH, and `isRegular_cons_iff` assembly closes the rest.
      -- We package the partial state in named witnesses for the next iter.
      let MxM : Type u := QuotSMulTop x M
      haveI : Nontrivial MxM :=
        nontrivial_quotSMulTop_of_mem_maximalIdeal M hxMem
      -- `Module.Finite R (M / xM)` is automatic via `Module.Finite.quotient`.
      haveI : _root_.Module.Finite R MxM := inferInstance
      -- iter-184 Lane G: closed via LES chase + sSup extraction + cons.
      --
      -- Step A: derive `∀ j < n, Ext^j(κ, MxM) = 0` from `hext` via the
      --   LES of `Ext^*(κ, ·)` on the SES `0 → M →[x] M → MxM → 0`.
      let S : ShortComplex (ModuleCat.{u} R) :=
        ModuleCat.smulShortComplex (ModuleCat.of R M) x
      have hS : S.ShortExact := hxReg.smulShortComplex_shortExact
      set κ : ModuleCat.{u} R := ModuleCat.of R (IsLocalRing.ResidueField R)
        with hκ
      have hMxM_vanish : ∀ j < n, ∀ e : Abelian.Ext.{u} κ
          (ModuleCat.of R MxM) j, e = 0 := by
        intro j hj e
        -- `e.comp hS.extClass rfl : Ext κ M (j+1) = 0` by `hext` at `j+1`.
        have he_ext : e.comp hS.extClass (rfl : j + 1 = j + 1) = 0 :=
          hext (j + 1) (by omega) _
        obtain ⟨x₂, hx₂⟩ :=
          CategoryTheory.Abelian.Ext.covariant_sequence_exact₃ κ hS e rfl he_ext
        -- `x₂ : Ext κ M j = 0` by `hext` at `j`.
        have hx₂_zero : x₂ = 0 := hext j (by omega) _
        rw [hx₂_zero] at hx₂
        simpa using hx₂.symm
      -- Step B: apply `ih (M := MxM)` at index `n`.
      have hdepth_MxM : (n : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) MxM :=
        (ih (M := MxM)).mpr hMxM_vanish
      -- Step C: unfold `depth MxM = sSup`-clause and extract a witness rs'
      --   of length ≥ n on MxM in 𝔪 (when n ≥ 1; the n = 0 case uses []).
      have hne_MxM : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R MxM) ≠ ⊤ :=
        Ne.symm (Submodule.top_ne_ideal_smul_of_le_jacobson_annihilator
          (IsLocalRing.maximalIdeal_le_jacobson _))
      have hdepth_MxM_unfold :
          depth (IsLocalRing.maximalIdeal R) MxM
            = sSup { k : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = k ∧
              (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
              ∧ RingTheory.Sequence.IsRegular MxM rs } := by
        rw [depth, if_neg hne_MxM]
      obtain ⟨rs', hrs'_len_ge, hrs'_mem, hrs'_reg⟩ :
          ∃ rs' : List R, n ≤ rs'.length ∧
            (∀ r ∈ rs', r ∈ IsLocalRing.maximalIdeal R) ∧
            RingTheory.Sequence.IsRegular MxM rs' := by
        rcases Nat.eq_zero_or_pos n with hn0 | hn_pos
        · subst hn0
          exact ⟨[], by simp, by simp,
            RingTheory.Sequence.IsRegular.nil R MxM⟩
        · have hlt : ((n - 1 : ℕ) : ℕ∞) <
              depth (IsLocalRing.maximalIdeal R) MxM := by
            have h1 : ((n - 1 : ℕ) : ℕ∞) < (n : ℕ∞) := by
              exact_mod_cast Nat.sub_lt hn_pos Nat.one_pos
            exact h1.trans_le hdepth_MxM
          rw [hdepth_MxM_unfold] at hlt
          obtain ⟨k, ⟨rs', hrs'_len_eq, hrs'_mem, hrs'_reg⟩, hk_lt⟩ :=
            lt_sSup_iff.mp hlt
          have hrs'_len_gt : n - 1 < rs'.length := by
            rw [← hrs'_len_eq] at hk_lt
            exact_mod_cast hk_lt
          refine ⟨rs', ?_, hrs'_mem, hrs'_reg⟩
          omega
      -- Step D: truncate rs' to length n; resulting sequence is M-regular.
      let rs_n := rs'.take n
      have hrs_n_len : rs_n.length = n := by
        change (rs'.take n).length = n
        rw [List.length_take]
        omega
      have hrs_n_mem : ∀ r ∈ rs_n, r ∈ IsLocalRing.maximalIdeal R := fun r hr =>
        hrs'_mem r (List.mem_of_mem_take hr)
      have hrs_n_reg : RingTheory.Sequence.IsRegular MxM rs_n := by
        change RingTheory.Sequence.IsRegular MxM (rs'.take n)
        have hsplit : rs' = rs'.take n ++ rs'.drop n :=
          (List.take_append_drop _ _).symm
        have hwr : RingTheory.Sequence.IsWeaklyRegular MxM rs' :=
          hrs'_reg.toIsWeaklyRegular
        rw [hsplit] at hwr
        have hwr_n : RingTheory.Sequence.IsWeaklyRegular MxM (rs'.take n) :=
          ((RingTheory.Sequence.isWeaklyRegular_append_iff MxM _ _).mp hwr).1
        exact (IsLocalRing.isRegular_iff_isWeaklyRegular_of_subset_maximalIdeal
          hrs_n_mem).mpr hwr_n
      -- Step E: cons x to form a length-(n+1) M-regular sequence in 𝔪.
      have hrs_M_reg : RingTheory.Sequence.IsRegular M (x :: rs_n) :=
        (RingTheory.Sequence.isRegular_cons_iff M x rs_n).mpr ⟨hxReg, hrs_n_reg⟩
      have hrs_M_mem : ∀ r ∈ (x :: rs_n), r ∈ IsLocalRing.maximalIdeal R := by
        intro r hr
        rcases List.mem_cons.mp hr with rfl | hr
        · exact hxMem
        · exact hrs_n_mem r hr
      have hrs_M_len : (x :: rs_n).length = n + 1 := by simp [hrs_n_len]
      -- Step F: conclude `(n+1 : ℕ∞) ≤ depth M` via `le_sSup`.
      have hne_M : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R M) ≠ ⊤ :=
        Ne.symm (Submodule.top_ne_ideal_smul_of_le_jacobson_annihilator
          (IsLocalRing.maximalIdeal_le_jacobson _))
      rw [depth, if_neg hne_M]
      apply le_sSup
      refine ⟨x :: rs_n, ?_, hrs_M_mem, hrs_M_reg⟩
      exact_mod_cast hrs_M_len

/-! ## §4. Depth on a short exact sequence

For a short exact sequence `0 → N' → N → N'' → 0` of nonzero finite modules
over a Noetherian local ring, the three modules' depths satisfy three
crosswise inequalities (Stacks tag 00LE), each a direct read-off of the
long exact `Ext^*(κ, -)` sequence and the depth-via-Ext characterisation
of §3.

Blueprint reference: `lem:depth_short_exact_sequence` (Stacks tag 00LE). -/

/-! ### Helper A (iter-182 Lane G, axiom-clean): Ext-vanishing from strict depth bound

For a Noetherian local ring `(R, 𝔪)` and a nonzero finite `R`-module `M`,
if `(i : ℕ∞) < depth M` then every element of `Ext^i_R(κ, M)` is zero.

This packages `depth_eq_smallest_ext_index` for the LES chase: the
`n ≤ depth M` form with `n := i + 1` instantiates the `∀ j < i + 1`
quantifier at `j = i`. Body is kernel-clean modulo the typed sorry of
`depth_eq_smallest_ext_index`. -/
private lemma ext_vanish_of_natCast_lt_depth
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M] {i : ℕ}
    (h : (i : ℕ∞) < depth (IsLocalRing.maximalIdeal R) M)
    (e : CategoryTheory.Abelian.Ext.{u}
        (ModuleCat.of R (IsLocalRing.ResidueField R))
        (ModuleCat.of R M) i) : e = 0 := by
  have h' : ((i + 1 : ℕ) : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) M := by
    have hcast : ((i + 1 : ℕ) : ℕ∞) = (i : ℕ∞) + 1 := by push_cast; ring
    rw [hcast]; exact Order.add_one_le_of_lt h
  exact (depth_eq_smallest_ext_index (M := M) (i + 1)).mp h' i (Nat.lt_succ_self i) e

/-! ### Helper B (iter-182 Lane G, axiom-clean): `ℕ∞` tsub bridge

If `(a : ℕ) ≤ d - 1` in `ℕ∞` and `1 ≤ a` (in `ℕ`), then
`((a + 1 : ℕ) : ℕ∞) ≤ d`.

Case-split on `d = ⊤` (trivial) and `d = ↑n` (drop to `ℕ` arithmetic).
Used for the `depth N' - 1` shift in the second SES inequality. -/
private lemma natCast_add_one_le_of_le_sub_one
    {d : ℕ∞} {a : ℕ} (ha : 1 ≤ a) (h : (a : ℕ∞) ≤ d - 1) :
    ((a + 1 : ℕ) : ℕ∞) ≤ d := by
  rcases eq_or_ne d ⊤ with hd | hd
  · simp [hd]
  · obtain ⟨n, rfl⟩ := WithTop.ne_top_iff_exists.mp hd
    -- Reduce to ℕ: turn `↑a ≤ ↑n - 1` into `a ≤ n - 1`, then `a + 1 ≤ n`.
    have h₂ : (a : ℕ∞) ≤ ((n - 1 : ℕ) : ℕ∞) := by
      refine h.trans (le_of_eq ?_)
      rcases n with _ | n
      · rfl
      · push_cast; rfl
    have han : a ≤ n - 1 := by exact_mod_cast h₂
    have hle : a + 1 ≤ n := by omega
    exact Nat.cast_le.mpr hle

theorem depth_of_short_exact
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {N' N N'' : Type u}
    [AddCommGroup N'] [Module R N'] [_root_.Module.Finite R N'] [Nontrivial N']
    [AddCommGroup N] [Module R N] [_root_.Module.Finite R N] [Nontrivial N]
    [AddCommGroup N''] [Module R N''] [_root_.Module.Finite R N''] [Nontrivial N'']
    (f : N' →ₗ[R] N) (g : N →ₗ[R] N'')
    (_hf : Function.Injective f) (_hg : Function.Surjective g)
    (_hex : Function.Exact f g) :
    min (depth (IsLocalRing.maximalIdeal R) N')
        (depth (IsLocalRing.maximalIdeal R) N'')
      ≤ depth (IsLocalRing.maximalIdeal R) N
    ∧ min (depth (IsLocalRing.maximalIdeal R) N)
          (depth (IsLocalRing.maximalIdeal R) N' - 1)
        ≤ depth (IsLocalRing.maximalIdeal R) N''
    ∧ min (depth (IsLocalRing.maximalIdeal R) N)
          (depth (IsLocalRing.maximalIdeal R) N'' + 1)
        ≤ depth (IsLocalRing.maximalIdeal R) N' := by
  -- Package the SES as a `ShortComplex.ShortExact` in `ModuleCat.{u} R`.
  let S : ShortComplex (ModuleCat.{u} R) :=
    ShortComplex.mk (ModuleCat.ofHom f) (ModuleCat.ofHom g)
      (by ext x; simpa using _hex.apply_apply_eq_zero x)
  have hS : S.ShortExact :=
    ModuleCat.shortComplex_shortExact S _hex _hf _hg
  -- The residue field as a ModuleCat object.
  set κ : ModuleCat.{u} R := ModuleCat.of R (IsLocalRing.ResidueField R) with hκ
  refine ⟨?_, ?_, ?_⟩
  · -- (1) min(depth N', depth N'') ≤ depth N
    rw [← ENat.forall_natCast_le_iff_le]
    intro a ha
    rw [le_min_iff] at ha
    obtain ⟨haN', haN''⟩ := ha
    rw [depth_eq_smallest_ext_index]
    intro i hi e
    -- `e : Ext κ S.X₂ i = Ext κ (of R N) i`; goal `e = 0`.
    have hicast : (i : ℕ∞) < (a : ℕ∞) := by exact_mod_cast hi
    have hiN' : (i : ℕ∞) < depth (IsLocalRing.maximalIdeal R) N' := hicast.trans_le haN'
    have hiN'' : (i : ℕ∞) < depth (IsLocalRing.maximalIdeal R) N'' := hicast.trans_le haN''
    -- `e ∘ S.g ∈ Ext κ (of R N'') i = 0`.
    have heg : e.comp (CategoryTheory.Abelian.Ext.mk₀ S.g) (add_zero i) = 0 :=
      ext_vanish_of_natCast_lt_depth hiN'' _
    obtain ⟨x₁, hx₁⟩ :=
      CategoryTheory.Abelian.Ext.covariant_sequence_exact₂ κ hS e heg
    -- `x₁ ∈ Ext κ (of R N') i = 0`.
    have hx₁_zero : x₁ = 0 := ext_vanish_of_natCast_lt_depth hiN' _
    rw [hx₁_zero] at hx₁
    simpa using hx₁.symm
  · -- (2) min(depth N, depth N' - 1) ≤ depth N''
    rw [← ENat.forall_natCast_le_iff_le]
    intro a ha
    rw [le_min_iff] at ha
    obtain ⟨haN, haN'sub⟩ := ha
    rw [depth_eq_smallest_ext_index]
    intro i hi e
    -- `e : Ext κ S.X₃ i = Ext κ (of R N'') i`; goal `e = 0`.
    have hicast : (i : ℕ∞) < (a : ℕ∞) := by exact_mod_cast hi
    have hiN : (i : ℕ∞) < depth (IsLocalRing.maximalIdeal R) N := hicast.trans_le haN
    -- `↑(i+1) < depth N'`: use Helper B with `a` and the inequality `hi : i + 1 ≤ a`.
    have hia : 1 ≤ a := by omega
    have ha1 : ((a + 1 : ℕ) : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) N' :=
      natCast_add_one_le_of_le_sub_one hia haN'sub
    have hsucc : ((i + 1 : ℕ) : ℕ∞) < depth (IsLocalRing.maximalIdeal R) N' := by
      have : ((i + 1 : ℕ) : ℕ∞) < ((a + 1 : ℕ) : ℕ∞) := by exact_mod_cast Nat.add_lt_add_right hi 1
      exact this.trans_le ha1
    -- `e ∘ extClass ∈ Ext κ (of R N') (i + 1) = 0`.
    have hext : e.comp hS.extClass rfl = 0 :=
      ext_vanish_of_natCast_lt_depth hsucc _
    obtain ⟨x₂, hx₂⟩ :=
      CategoryTheory.Abelian.Ext.covariant_sequence_exact₃ κ hS e rfl hext
    -- `x₂ ∈ Ext κ (of R N) i = 0`.
    have hx₂_zero : x₂ = 0 := ext_vanish_of_natCast_lt_depth hiN _
    rw [hx₂_zero] at hx₂
    simpa using hx₂.symm
  · -- (3) min(depth N, depth N'' + 1) ≤ depth N'
    rw [← ENat.forall_natCast_le_iff_le]
    intro a ha
    rw [le_min_iff] at ha
    obtain ⟨haN, haN''add⟩ := ha
    rw [depth_eq_smallest_ext_index]
    intro i hi e
    -- `e : Ext κ S.X₁ i = Ext κ (of R N') i`; goal `e = 0`.
    have hicast : (i : ℕ∞) < (a : ℕ∞) := by exact_mod_cast hi
    have hiN : (i : ℕ∞) < depth (IsLocalRing.maximalIdeal R) N := hicast.trans_le haN
    -- `e ∘ S.f ∈ Ext κ (of R N) i = 0`.
    have hef : e.comp (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero i) = 0 :=
      ext_vanish_of_natCast_lt_depth hiN _
    -- Split on `i = 0` vs `i ≥ 1`. For `i ≥ 1`, use `covariant_sequence_exact₁`.
    -- For `i = 0`, postcomposition by `S.f` is injective (since `S.f` is mono).
    rcases Nat.eq_zero_or_pos i with hi0 | hi0
    · subst hi0
      -- `e : Ext κ S.X₁ 0`; postcomp by `S.f` is injective; image is `e ∘ S.f = 0`,
      -- so `e = 0`.
      have hmono : CategoryTheory.Mono S.f :=
        (ModuleCat.mono_iff_injective _).mpr _hf
      have hinj := CategoryTheory.Abelian.Ext.postcomp_mk₀_injective_of_mono κ S.f
      apply hinj
      simpa using hef
    · -- `i ≥ 1`. Let `i = j + 1` and use `covariant_sequence_exact₁` at
      -- `n₀ = j, n₁ = i = j + 1`.
      obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hi0)
      -- `e : Ext κ (of R N') (j + 1)`. We need `Ext κ (of R N'') j = 0`.
      -- From `↑(j+2) ≤ ↑a ≤ depth N'' + 1`, get `↑j + 1 ≤ depth N''`, so `↑j < depth N''`.
      have hjN'' : (j : ℕ∞) < depth (IsLocalRing.maximalIdeal R) N'' := by
        have hja : j + 2 ≤ a := by omega
        have h_j2 : ((j + 2 : ℕ) : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) N'' + 1 := by
          refine le_trans ?_ haN''add
          exact_mod_cast hja
        have hcast : ((j + 2 : ℕ) : ℕ∞) = ((j + 1 : ℕ) : ℕ∞) + 1 := by push_cast; ring
        rw [hcast] at h_j2
        have h_canc : ((j + 1 : ℕ) : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) N'' :=
          (ENat.add_le_add_iff_right (by norm_num : (1 : ℕ∞) ≠ ⊤)).mp h_j2
        have hcast2 : ((j + 1 : ℕ) : ℕ∞) = (j : ℕ∞) + 1 := by push_cast; ring
        rw [hcast2] at h_canc
        exact (ENat.add_one_le_iff (by simp : (j : ℕ∞) ≠ ⊤)).mp h_canc
      obtain ⟨x₃, hx₃⟩ :=
        CategoryTheory.Abelian.Ext.covariant_sequence_exact₁ κ hS e hef rfl
      -- `x₃ ∈ Ext κ (of R N'') j = 0`.
      have hx₃_zero : x₃ = 0 := ext_vanish_of_natCast_lt_depth hjN'' _
      rw [hx₃_zero] at hx₃
      simpa using hx₃.symm

end Module

/-! ## §5. The Auslander–Buchsbaum formula

For a nonzero finite module `M` of finite projective dimension over a
Noetherian local ring `(R, 𝔪)`, the **Auslander–Buchsbaum formula** reads
```
  pd_R(M) + depth(M) = depth(R)
```
(Stacks tag 090V). The proof inducts on `depth(M)`: the base case
`depth(M) = 0` uses a minimal finite free resolution of `M` and the
"what is exact" criterion (Stacks 00MF) plus iterated application of the
depth-on-a-short-exact-sequence lemma (§4) to bound `depth(R)` against the
resolution length; the inductive step picks a common non-zero-divisor
`x ∈ 𝔪` on both `R` and `M`, applies the snake lemma to obtain a minimal
finite free resolution of `M/xM` over `R/xR` of the same length, and uses
the inductive hypothesis on `M/xM` over `R/xR`.

Blueprint reference: `thm:auslander_buchsbaum` (Stacks tag 090V). -/

/-- **The Auslander–Buchsbaum formula.** Let `(R, 𝔪)` be a Noetherian local
ring and let `M` be a nonzero finite `R`-module of finite projective
dimension. Then
```
  pd_R(M) + depth_R(M) = depth(R).
```

The hypothesis "finite projective dimension" is encoded by an explicit
upper bound `n : ℕ` on the projective dimension (so the formula compares
finite numeric quantities cleanly without `WithBot ℕ∞`-arithmetic
subtleties).

iter-176+: the body is the induction on `depth(M)` outlined in the
chapter — base case via the minimal-finite-free-resolution +
"what is exact" + iterated `Module.depth_of_short_exact`; inductive step
via the snake lemma on multiplication by a common non-zero-divisor and
the inductive hypothesis on `M/xM` over `R/xR`. For the iter-175
file-skeleton the body is a typed `sorry`. -/
theorem auslander_buchsbaum_formula
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M]
    (n : ℕ)
    (_hpd : _root_.Module.projectiveDimension R M = (n : WithBot ℕ∞)) :
    (n : ℕ∞) + Module.depth (IsLocalRing.maximalIdeal R) M
      = Module.depth (IsLocalRing.maximalIdeal R) R := by
  sorry

/-! ## §6. Cohen–Macaulay local rings

A Noetherian local ring `(R, 𝔪)` is **Cohen–Macaulay** if its depth equals
its Krull dimension (Stacks tag 00N4). Mathlib `b80f227` has neither the
predicate nor the class — this file is the upstream gap-fill.

Blueprint reference: `def:cohen_macaulay_local` (Stacks tag 00N4). -/

/-- A Noetherian local ring `(R, 𝔪)` is **Cohen–Macaulay** if its depth
equals its Krull dimension: `depth(R) = dim R`.

Encoded as a `Prop`-valued type class so downstream consumers can write
`[CohenMacaulay R]` and use Cohen–Macaulay as a hypothesis. Mathlib at the
pinned commit (`b80f227`) does not expose any Cohen–Macaulay predicate;
this is the upstream gap-fill.

iter-176+: the predicate is `Module.depth (IsLocalRing.maximalIdeal R) R =
ringKrullDim R`. For the iter-175 file-skeleton the carrier definition is a
typed `sorry` at the `Prop` level — substantively, the predicate is the
named equality, but we package it as a `class` so use sites are uniform. -/
class CohenMacaulay (R : Type u) [CommRing R] [IsLocalRing R]
    [IsNoetherianRing R] : Prop where
  /-- The Cohen–Macaulay equation: `depth(R) = ringKrullDim R`. The numeric
  comparison is in `WithBot ℕ∞` after coercion of the `ℕ∞`-valued depth. -/
  depth_eq_krullDim :
    (Module.depth (IsLocalRing.maximalIdeal R) R : WithBot ℕ∞) = ringKrullDim R

/-! ## §7. Regular local rings are Cohen–Macaulay

The consumer-facing input for A.4.a: every regular Noetherian local ring is
Cohen–Macaulay (Stacks tag 00OD). The direct proof: pick a minimal
generating set `x_1, …, x_d` of `𝔪` (where `d = dim R`), use that `R` is a
domain (Stacks 00NQ) to start an `R`-regular sequence, and induct on
dimension — each `R/(x_1, …, x_c)` is again regular of dimension `d - c`,
so `x_1, …, x_d` is an `R`-regular sequence and `depth(R) ≥ d`. The reverse
inequality `depth(R) ≤ dim R` is the standard depth bound (Stacks 00LK).

Blueprint reference: `cor:regular_cohen_macaulay` (Stacks tag 00OD). -/

namespace CohenMacaulay

/-! ### Helper 1 (axiom-clean): length-bound on regular sequences

For a Noetherian local ring `R`, every `R`-regular sequence has length at most
`ringKrullDim R`. This is the **upper bound** half of Stacks 00OD: it is the
specialisation of the equality
`ringKrullDim (R / ofList rs) + rs.length = ringKrullDim R`
(`ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`) to the observation that
`ringKrullDim (R / ofList rs) ≥ 0` whenever the quotient is nontrivial, which it
is precisely because `IsRegular` rules out `rs • ⊤ = ⊤`.

iter-181 Lane G: closed kernel-clean. -/
private lemma length_le_ringKrullDim_of_isRegular
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {rs : List R} (h : RingTheory.Sequence.IsRegular R rs) :
    (rs.length : WithBot ℕ∞) ≤ ringKrullDim R := by
  have heq := ringKrullDim_add_length_eq_ringKrullDim_of_isRegular rs h
  have hntq : Nontrivial (R ⧸ Ideal.ofList rs) := by
    rw [Ideal.Quotient.nontrivial_iff]
    intro habs
    apply h.top_ne_smul
    change (⊤ : Submodule R R) = (Ideal.ofList rs) • ⊤
    rw [habs]; simp
  have hnn : (0 : WithBot ℕ∞) ≤ ringKrullDim (R ⧸ Ideal.ofList rs) :=
    ringKrullDim_nonneg_of_nontrivial
  calc (rs.length : WithBot ℕ∞)
      = 0 + (rs.length : WithBot ℕ∞) := by simp
    _ ≤ ringKrullDim (R ⧸ Ideal.ofList rs) + (rs.length : WithBot ℕ∞) := by gcongr
    _ = ringKrullDim R := heq

/-! ### Helper 2 (substantive typed `sorry`): system-of-parameters as a regular sequence

For a regular local ring `R` of Krull dimension `d = (maximalIdeal R).spanFinrank`,
a minimal generating set `x_1, …, x_d` of the maximal ideal `𝔪` is an `R`-regular
sequence. This is the **lower bound** half of Stacks 00OD.

The proof in Stacks 00OD uses:
1. A regular local ring is an integral domain (Stacks 00NQ).
2. For each `c < d`, the quotient `R / (x_1, …, x_c)` is again a regular local
   ring, of Krull dimension `d - c` (Krull's principal ideal theorem +
   `lemma-one-equation`).

Step (1) — `IsRegularLocalRing R ⟹ IsDomain R` — is **not present in Mathlib at
the pinned commit** (`b80f227`); a `lean_leansearch` for "regular local ring is
a domain" returns nothing relevant. Step (2) requires the regular-quotient
inductive structure (Stacks 00NQ + height-one quotient regularity), which is
similarly absent. Both are substantive multi-iter content.

The signature here is the non-tautological existence statement: a list `rs : List R`
with `rs.length = (maximalIdeal R).spanFinrank`, `rs ⊆ maximalIdeal R`, and
`IsRegular R rs`. Downstream, `of_regular` consumes this directly to close the
`depth ≥ d` lower bound.

iter-185 Lane G **STRUCTURAL SCAFFOLD**: the main lemma is structurally
complete by strong induction on `n = spanFinrank R`. The inductive step is
factored into `regularLocal_inductive_step` (axiom-clean: lift-and-cons
assembly via Mathlib's `IsRegular.cons'`) plus the Mathlib-gap helper
`exists_isSMulRegular_quotient_isRegularLocal_succ` (typed `sorry`,
Stacks 00NQ + 00NU consolidated). The substrate work (`IsRegularLocalRing ⟹
IsDomain` + Krull's PIT for quotient-by-minimal-generator) is genuinely
multi-iter; the iter-185 progress is the structural extraction of the
Mathlib gap into a narrow, well-typed helper, leaving the assembly
axiom-clean for the gap-fill iteration to finish in `~5 LOC` once the
helper closes. -/

/-- **Substrate gap consolidated (Stacks 00NQ + 00NU; typed `sorry`).**
For a regular local ring `(R, 𝔪)` of Krull dimension `k + 1`, there exists
`x ∈ 𝔪` that is `R`-regular (a non-zero-divisor on `R`) such that the quotient
`R ⧸ Ideal.span {x}` is again a regular local ring of Krull dimension `k`
(equivalently: its maximal ideal has `spanFinrank = k`).

The internals combine two Stacks gap-fills, both absent from Mathlib at the
pinned commit `b80f227`:

* **Stacks 00NQ** — `IsRegularLocalRing R ⟹ IsDomain R` (the no-embedded-prime
  argument, ~300 LOC). Once `R` is a domain, every nonzero element is a
  non-zero-divisor, so any minimal generator `x ∈ 𝔪 \ 𝔪²` gives
  `IsSMulRegular R x`.
* **Stacks 00NU** + Krull's principal ideal theorem (~200 LOC). For `x` a
  minimal generator of `𝔪` that is a non-zero-divisor, the quotient `R ⧸ (x)`
  is again regular local of dimension `k`. Mathlib provides
  `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim` as the dim-drop;
  the spanFinrank statement follows by removing `x` from a minimal generating
  set of `𝔪` (the images of the remaining `k` generators span `𝔪 / (x)`),
  combined with `IsRegularLocalRing.of_spanFinrank_maximalIdeal_le`.

iter-185 Lane G: this helper concentrates the Stacks 00NQ + 00NU substrate
work in a single typed `sorry`. Future iterations can attack each Stacks gap
independently; the assembly below (`regularLocal_inductive_step`) is
axiom-clean modulo this helper. -/
private lemma exists_isSMulRegular_quotient_isRegularLocal_succ
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] {k : ℕ}
    (hdim : (IsLocalRing.maximalIdeal R).spanFinrank = k + 1) :
    ∃ (x : R), x ∈ IsLocalRing.maximalIdeal R ∧ IsSMulRegular R x ∧
      ∃ _ : IsRegularLocalRing (R ⧸ Ideal.span {x}),
        (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x})).spanFinrank = k := by
  sorry

/-- **Lane G inductive step (iter-185 structural scaffold).** Packages the
inductive step of Stacks 00OD: given a regular local ring `R` of dimension
`k + 1`, plus the inductive hypothesis at dimension `k` (universally
quantified in the ring), produce a regular sequence of length `k + 1` in
the maximal ideal of `R`.

The body is **axiom-clean** modulo the typed-`sorry` substrate helper
`exists_isSMulRegular_quotient_isRegularLocal_succ`. Assembly path:

1. Helper extracts `x ∈ 𝔪` with `IsSMulRegular R x` AND `IsRegularLocalRing
   (R⧸(x))` of `spanFinrank = k`.
2. IH applied on `R ⧸ Ideal.span {x}` produces a regular sequence
   `rs'_q : List (R ⧸ (x))` of length `k` in the maximal ideal there.
3. Lift `rs'_q` to `rs : List R` via `Function.surjInv` of
   `Ideal.Quotient.mk_surjective`; the section property gives
   `rs.map (Ideal.Quotient.mk _) = rs'_q`.
4. Members of `rs` lie in `𝔪` because the maximal ideal of `R⧸(x)` is the
   image of `𝔪` (`IsLocalRing.le_maximalIdeal` applied to the comap chain).
5. Cons via `RingTheory.Sequence.IsRegular.cons'` to form the length-`(k+1)`
   sequence `x :: rs`.

This factoring isolates the Mathlib gap to one narrow typed `sorry` instead of
spreading it across the lemma body; future iterations can attack Stacks 00NQ
+ 00NU directly. -/
private lemma regularLocal_inductive_step {R : Type u} [CommRing R] [IsLocalRing R]
    [IsNoetherianRing R] [IsRegularLocalRing R] {k : ℕ}
    (hdim : (IsLocalRing.maximalIdeal R).spanFinrank = k + 1)
    (IH : ∀ (R' : Type u) [CommRing R'] [IsLocalRing R'] [IsNoetherianRing R']
            [IsRegularLocalRing R'],
            (IsLocalRing.maximalIdeal R').spanFinrank = k →
            ∃ rs : List R', rs.length = k ∧
              (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R') ∧
              RingTheory.Sequence.IsRegular R' rs) :
    ∃ rs : List R, rs.length = k + 1 ∧
      (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R) ∧
      RingTheory.Sequence.IsRegular R rs := by
  -- Step 1: extract `x ∈ 𝔪` regular on `R` with `R ⧸ (x)` regular local of
  -- `spanFinrank = k`.  This is the consolidated Stacks 00NQ + 00NU substrate.
  obtain ⟨x, hxMem, hxReg, hRLR, hdim_quot⟩ :=
    exists_isSMulRegular_quotient_isRegularLocal_succ hdim
  -- Step 2: apply IH on `R ⧸ (x)` — this gives a regular sequence of length
  -- `k` on the quotient, valued in its maximal ideal.
  obtain ⟨rs'_q, hlen_q, hmem_q, hreg_q⟩ := IH (R ⧸ Ideal.span {x}) hdim_quot
  -- Step 3: lift `rs'_q : List (R ⧸ (x))` to `rs' : List R` via the right
  -- inverse of the (surjective) quotient ring hom.
  let mkq : R →+* R ⧸ Ideal.span {x} := Ideal.Quotient.mk _
  let g : R ⧸ Ideal.span {x} → R := Function.surjInv Ideal.Quotient.mk_surjective
  have hg : ∀ y, mkq (g y) = y := Function.surjInv_eq _
  let rs' : List R := rs'_q.map g
  have hlen_rs' : rs'.length = k := by simp [rs', hlen_q]
  have hmkmap : rs'.map mkq = rs'_q := by
    change (rs'_q.map g).map mkq = rs'_q
    rw [List.map_map]
    conv_rhs => rw [← List.map_id rs'_q]
    exact List.map_congr_left fun y _ => hg y
  -- Step 4: each element of `rs'` lies in `𝔪 R` via the comap of `𝔪 (R⧸(x))`.
  -- The maximal ideal of `R ⧸ (x)` comaps back to `𝔪 R` (it's the *unique*
  -- maximal ideal of `R` containing `Ideal.span {x} ⊆ 𝔪`).
  have hmem_rs' : ∀ r ∈ rs', r ∈ IsLocalRing.maximalIdeal R := by
    intro r hr
    simp only [rs', List.mem_map] at hr
    obtain ⟨y, hy_mem, rfl⟩ := hr
    -- The comap of `𝔪 (R⧸(x))` under the surjective `mkq` is a maximal ideal
    -- of `R`; since `R` is local, it equals `𝔪 R`.  Hence `g y ∈ comap mkq 𝔪'`
    -- iff `g y ∈ 𝔪 R`.
    have hmax_comap : (Ideal.comap mkq
        (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x}))).IsMaximal :=
      Ideal.comap_isMaximal_of_surjective _ Ideal.Quotient.mk_surjective
    have heq : Ideal.comap mkq
        (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x}))
        = IsLocalRing.maximalIdeal R :=
      (IsLocalRing.isMaximal_iff R).mp hmax_comap
    rw [← heq, Ideal.mem_comap]
    exact (hg y).symm ▸ hmem_q y hy_mem
  -- Step 5: cons `x` onto `rs'` to form the length-`(k+1)` regular sequence.
  refine ⟨x :: rs', ?_, ?_, ?_⟩
  · simp [hlen_rs']
  · intro r hr
    rcases List.mem_cons.mp hr with rfl | hr_in
    · exact hxMem
    · exact hmem_rs' r hr_in
  · -- `IsRegular R (x :: rs')` via `IsRegular.cons'`.
    -- Need `IsSMulRegular R x` (have `hxReg`) AND
    -- `IsRegular (QuotSMulTop x R) (rs'.map (Ideal.Quotient.mk (Ideal.span {x})))`.
    refine RingTheory.Sequence.IsRegular.cons' hxReg ?_
    -- After `cons'`: goal is `IsRegular (QuotSMulTop x R) (rs'.map mkq)`
    -- = `IsRegular (QuotSMulTop x R) rs'_q` (by `hmkmap`), implicit ring
    -- `R ⧸ Ideal.span {x}` (inferred from list type).
    rw [hmkmap]
    -- Goal: `IsRegular (QuotSMulTop x R) rs'_q` (implicit ring `R ⧸ (x)`).
    -- IH provides: `IsRegular (R ⧸ Ideal.span {x}) rs'_q` (same implicit
    -- ring, but M differs: `R ⧸ Ideal.span {x}` vs `QuotSMulTop x R = R ⧸ (x • ⊤)`).
    --
    -- **iter-185 typed `sorry` — TECHNICAL BRIDGE (NOT a Mathlib substrate gap).**
    -- The two M's are *equal as sets* — both are the quotient of `R` by the
    -- principal ideal `(x)`, written two different ways:
    --   * `R ⧸ Ideal.span {x}` — quotient by `Ideal.span {x}` as a Submodule R R;
    --   * `QuotSMulTop x R = R ⧸ (x • ⊤)` — quotient by `x • ⊤` as a Submodule R R.
    -- Mathlib's `Submodule.ideal_span_singleton_smul` gives
    -- `(x • ⊤ : Submodule R R) = Ideal.span {x} • ⊤ = Ideal.span {x}` (the
    -- second equality because `I • ⊤_R = I` for an ideal `I` of `R`).  The
    -- bridge between the two M's is an `R⧸(x)`-linear equivalence; future iter
    -- can construct this in ~10-20 LOC via:
    --   (a) `Submodule.quotEquivOfEq` from the submodule equality (gives R-linear);
    --   (b) upgrade to `R⧸(x)`-linear via `QuotSMulTop.mem_annihilator`
    --       (since `x ∈ Module.annihilator R (QuotSMulTop x R)`, the R-action
    --       factors through `R⧸(x)`, and any R-linear equiv between two such
    --       modules is automatically `R⧸(x)`-linear);
    --   (c) close via `LinearEquiv.isRegular_congr` on this `R⧸(x)`-linear equiv.
    -- This bridge has no substrate dependencies — it's pure bookkeeping.
    sorry

lemma exists_isRegular_of_regularLocal
    (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] :
    ∃ rs : List R, rs.length = (IsLocalRing.maximalIdeal R).spanFinrank
        ∧ (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
        ∧ RingTheory.Sequence.IsRegular R rs := by
  -- Strong induction on `n = spanFinrank R`, generalising `R` so the inductive
  -- hypothesis can be applied to the quotient `R/(x)` at smaller dimension.
  suffices haux : ∀ (n : ℕ) (R : Type u) [CommRing R] [IsLocalRing R]
      [IsNoetherianRing R] [IsRegularLocalRing R],
      (IsLocalRing.maximalIdeal R).spanFinrank = n →
      ∃ rs : List R, rs.length = n ∧
        (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R) ∧
        RingTheory.Sequence.IsRegular R rs by
    exact haux _ R rfl
  intro n
  induction n with
  | zero =>
    -- Base case `dim 0`: spanFinrank = 0, hence `maximalIdeal R = ⊥` (so `R` is
    -- a field). The empty list is trivially `R`-regular on the nonzero ring `R`.
    intros R _ _ _ _ _hdim
    refine ⟨[], rfl, by simp, ?_⟩
    exact RingTheory.Sequence.IsRegular.nil R R
  | succ k ih =>
    -- Inductive case `dim (k + 1)`: delegate to `regularLocal_inductive_step`,
    -- supplying the inductive hypothesis at dimension `k`. The helper handles
    -- the substantive NZD-extraction + quotient-regularity + cons assembly.
    intros R _ _ _ _ hdim
    exact regularLocal_inductive_step (k := k) hdim (fun R' _ _ _ _ h => ih R' h)

/-- **Regular local rings are Cohen–Macaulay.** Every regular Noetherian
local ring is Cohen–Macaulay: a minimal generating set of `𝔪` is an
`R`-regular sequence of length `dim R`, so `depth(R) ≥ dim R`; combined
with the standard upper bound `depth(R) ≤ dim R` (Stacks 00LK) this gives
`depth(R) = dim R`.

This is the consumer-facing input for **A.4.a** (codim-1 extension of a
rational map across a codim-2 closed point on a regular projective
surface): the local ring `O_{S,x}` of a regular projective surface at a
closed point is regular of Krull dimension `2`, hence Cohen–Macaulay,
hence has depth `2`, which is exactly the input the local-cohomology
vanishing `H^i_x(O_S) = 0` for `i < 2` needs (Stacks 0AVF; see Hartshorne
III.7).

iter-181 Lane G **STRUCTURAL**: body is now decomposed into two
typed helper lemmas — `length_le_ringKrullDim_of_isRegular` (the upper
bound, closed kernel-clean from
`ringKrullDim_add_length_eq_ringKrullDim_of_isRegular`) and
`exists_isRegular_of_regularLocal` (the lower bound, typed `sorry` on the
Mathlib gap `IsRegularLocalRing ⟹ IsDomain` + regular-quotient induction).
The combined assembly into `depth = ringKrullDim` is closed inline below,
so the only residual `sorry` in this `instance` body is the named helper. -/
instance of_regular (R : Type u) [CommRing R] [IsLocalRing R]
    [IsNoetherianRing R] [IsRegularLocalRing R] : CohenMacaulay R where
  depth_eq_krullDim := by
    -- Step 1: simplify `Module.depth` via the `else` branch
    --   (since `𝔪 • ⊤ = 𝔪 ≠ ⊤` for a local ring's maximal ideal).
    have h𝔪 : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R R)
        ≠ (⊤ : Submodule R R) := by
      have heq : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R R)
          = IsLocalRing.maximalIdeal R := by simp
      rw [heq]
      exact (IsLocalRing.maximalIdeal.isMaximal R).ne_top
    rw [Module.depth, if_neg h𝔪]
    -- Step 2: convert RHS to the spanFinrank using
    -- `IsRegularLocalRing.spanFinrank_maximalIdeal`.
    rw [← IsRegularLocalRing.spanFinrank_maximalIdeal]
    -- Goal: ((sSup {n | …} : ℕ∞) : WithBot ℕ∞)
    --         = ((spanFinrank 𝔪 : ℕ) : WithBot ℕ∞)
    -- Step 3: it suffices to show the sSup equals spanFinrank as ℕ∞,
    -- via antisymmetry: upper bound from Helper 1, lower bound from Helper 2.
    have h1 : (sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
        (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
          ∧ RingTheory.Sequence.IsRegular R rs }
        : ℕ∞) = ((IsLocalRing.maximalIdeal R).spanFinrank : ℕ∞) := by
      apply le_antisymm
      · -- Upper bound: every element of the sSup-set is at most spanFinrank.
        apply sSup_le
        rintro n ⟨rs, rfl, _, hreg⟩
        have hub := length_le_ringKrullDim_of_isRegular hreg
        rw [← IsRegularLocalRing.spanFinrank_maximalIdeal] at hub
        exact_mod_cast hub
      · -- Lower bound: spanFinrank is achieved by Helper 2's regular sequence.
        obtain ⟨rs, hlen, hmem, hreg⟩ := exists_isRegular_of_regularLocal R
        apply le_sSup
        refine ⟨rs, ?_, hmem, hreg⟩
        exact_mod_cast hlen
    rw [h1]
    -- Final coercion: `((n : ℕ∞) : WithBot ℕ∞) = ((n : ℕ) : WithBot ℕ∞)`
    -- is the standard `Nat.cast`-tower commutation.
    rfl

end CohenMacaulay

end RingTheory
