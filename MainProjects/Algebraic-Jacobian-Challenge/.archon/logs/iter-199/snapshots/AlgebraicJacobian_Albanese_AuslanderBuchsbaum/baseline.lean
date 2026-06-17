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

/-! ### Helper iter-193 Lane G (axiom-clean): depth is preserved under R-linear equivalence

For a commutative ring `R`, an ideal `I ⊆ R`, and two `R`-modules `M, M'` with
an `R`-linear equivalence `e : M ≃ₗ[R] M'`, we have `depth I M = depth I M'`.

This is the standard "depth is an invariant of the isomorphism class" fact;
the proof has two steps: (1) the side-condition `I • ⊤ = ⊤` is preserved
under linear equivalence, and (2) the regular-sequence supremum sets agree
via `LinearEquiv.isRegular_congr`. Both halves are direct Mathlib calls; the
helper is axiom-clean.

iter-193 Lane G structural advance: this helper is the substrate piece
needed to identify `depth(M)` with `depth(R^k)` for `M` finite free, which
in turn closes the `pd(M) = 0` base case of the Auslander–Buchsbaum
formula modulo the `depth(R^k) = depth(R)` direct-sum step (a separate
substrate item; the file's residual sorries are narrowed to that one
named piece). -/
lemma depth_eq_of_linearEquiv {R : Type u} [CommRing R] (I : Ideal R)
    {M M' : Type v} [AddCommGroup M] [Module R M] [AddCommGroup M'] [Module R M']
    (e : M ≃ₗ[R] M') :
    depth I M = depth I M' := by
  -- Step 1: `I • ⊤ = ⊤` is preserved under the linear equivalence.
  have hcond : (I • (⊤ : Submodule R M) = ⊤) ↔ (I • (⊤ : Submodule R M') = ⊤) := by
    have e_top : Submodule.map (e : M →ₗ[R] M') (⊤ : Submodule R M) = ⊤ := by
      rw [Submodule.map_top]; exact LinearEquiv.range e
    have e_symm_top :
        Submodule.map (e.symm : M' →ₗ[R] M) (⊤ : Submodule R M') = ⊤ := by
      rw [Submodule.map_top]; exact LinearEquiv.range e.symm
    refine ⟨?_, ?_⟩
    · intro h
      have hmap :=
        Submodule.map_smul'' I (⊤ : Submodule R M) (e : M →ₗ[R] M')
      rw [h, e_top] at hmap
      exact hmap.symm
    · intro h
      have hmap :=
        Submodule.map_smul'' I (⊤ : Submodule R M') (e.symm : M' →ₗ[R] M)
      rw [h, e_symm_top] at hmap
      exact hmap.symm
  -- Step 2: the `sSup` sets agree via `LinearEquiv.isRegular_congr`.
  unfold depth
  by_cases h : I • (⊤ : Submodule R M) = ⊤
  · simp [if_pos h, if_pos (hcond.mp h)]
  · rw [if_neg h, if_neg (mt hcond.mpr h)]
    congr 1
    ext n
    refine ⟨?_, ?_⟩
    · rintro ⟨rs, hlen, hmem, hreg⟩
      exact ⟨rs, hlen, hmem, (LinearEquiv.isRegular_congr e rs).mp hreg⟩
    · rintro ⟨rs, hlen, hmem, hreg⟩
      exact ⟨rs, hlen, hmem, (LinearEquiv.isRegular_congr e rs).mpr hreg⟩

/-! ### Helper iter-194 Lane G (axiom-clean): depth of constant Pi equals depth of fiber.

For a commutative ring `R`, ideal `I`, module `M`, and nonempty finite type `ι`,
`depth I (ι → M) = depth I M`. The proof goes through the regular-sequence
characterization: each `r`-action on `ι → M` is pointwise (so an `r ∈ R` is
regular on `ι → M` iff regular on `M`), and the quotient `(ι → M)/r·⊤`
identifies with `ι → M/r·⊤` via `Submodule.quotientPi`. The side condition
`I • ⊤ = ⊤` agrees on both sides via a `Pi.single` lifting argument.

This is the substrate needed to close the `pd_R(M) = 0` case of the
Auslander–Buchsbaum formula (where `M ≃ₗ[R] Fin k → R` via a basis). -/

/-- For any commutative ring `R`, ideal `I`, finite index `ι`, and module `M`,
the ideal-action `I • ⊤_{ι → M}` equals the pi-submodule of fibre `I • ⊤_M`s. -/
private lemma ideal_smul_top_pi_const
    {R : Type u} [CommRing R] {ι : Type*} [Fintype ι] [DecidableEq ι]
    (I : Ideal R) {M : Type v} [AddCommGroup M] [Module R M] :
    (I • (⊤ : Submodule R (ι → M))) =
      Submodule.pi (Set.univ : Set ι) (fun (_ : ι) => I • (⊤ : Submodule R M)) := by
  apply le_antisymm
  · intro f hf i _
    refine Submodule.smul_induction_on hf ?_ ?_
    · intro a hain x _
      change a • x i ∈ I • (⊤ : Submodule R M)
      exact Submodule.smul_mem_smul hain trivial
    · intro x y hx hy
      change (x + y) i ∈ _
      exact Submodule.add_mem _ hx hy
  · intro f hf
    rw [show f = ∑ j, Pi.single j (f j) from (Finset.univ_sum_single f).symm]
    refine Submodule.sum_mem _ ?_
    intro j _
    have hfj : f j ∈ I • (⊤ : Submodule R M) := hf j (Set.mem_univ j)
    have hmap :
        Pi.single j (f j) ∈
          Submodule.map (LinearMap.single R (fun (_ : ι) => M) j)
            (I • (⊤ : Submodule R M)) :=
      Submodule.mem_map.mpr ⟨f j, hfj, rfl⟩
    rw [Submodule.map_smul''] at hmap
    exact Submodule.smul_mono le_rfl le_top hmap

/-- The side condition `I • ⊤ = ⊤` agrees on `ι → M` and `M` for nonempty
finite `ι`: a free product of fibre `I•⊤_M`-witnesses combines to a
`I•⊤_{ι → M}`-witness (via `Pi.single`-lifting), and conversely a
`Pi.single j m`-projection at `j` reads off the witness on the fibre. -/
private lemma ideal_smul_top_pi_const_eq_top_iff
    {R : Type u} [CommRing R] {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (I : Ideal R) {M : Type v} [AddCommGroup M] [Module R M] :
    I • (⊤ : Submodule R (ι → M)) = ⊤ ↔ I • (⊤ : Submodule R M) = ⊤ := by
  constructor
  · intro h
    rw [eq_top_iff]
    intro m _
    obtain ⟨j⟩ := ‹Nonempty ι›
    have hsingle_mem :
        (Pi.single j m : ι → M) ∈ I • (⊤ : Submodule R (ι → M)) := by
      rw [h]; trivial
    rw [ideal_smul_top_pi_const] at hsingle_mem
    have := hsingle_mem j (Set.mem_univ j)
    rwa [Pi.single_eq_same] at this
  · intro h
    rw [ideal_smul_top_pi_const, eq_top_iff]
    intro f _ i _
    rw [h]
    trivial

/-- `QuotSMulTop r (ι → M) ≃ₗ[R] ι → QuotSMulTop r M` for finite `ι`,
obtained by rewriting `r • ⊤ = Ideal.span {r} • ⊤` and using
`Submodule.quotientPi`. -/
private noncomputable def quotSMulTopPiConstLinearEquiv
    {R : Type u} [CommRing R] {ι : Type*} [Fintype ι] [DecidableEq ι] (r : R)
    {M : Type v} [AddCommGroup M] [Module R M] :
    QuotSMulTop r (ι → M) ≃ₗ[R] (ι → QuotSMulTop r M) := by
  refine (Submodule.quotEquivOfEq _ _ ?_).trans (Submodule.quotientPi _)
  rw [← Submodule.ideal_span_singleton_smul r (⊤ : Submodule R (ι → M))]
  rw [ideal_smul_top_pi_const]
  congr 1
  funext _
  exact Submodule.ideal_span_singleton_smul r ⊤

/-- For nonempty finite `ι`, a list `rs : List R` is `(ι → M)`-regular iff it
is `M`-regular. Proof by induction on `rs`: the empty case reduces to
`Nontrivial (ι → M) ↔ Nontrivial M`; the cons case uses `Pi.isSMulRegular_iff`
(for the SMul-regular conjunct) plus `quotSMulTopPiConstLinearEquiv` +
`LinearEquiv.isRegular_congr` (to bridge the quotient regularity to the IH on
`QuotSMulTop r M`). -/
private lemma isRegular_pi_const_iff_of_nonempty
    {R : Type u} [CommRing R] {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    (rs : List R) :
    ∀ {M : Type v} [AddCommGroup M] [Module R M],
      RingTheory.Sequence.IsRegular (ι → M) rs ↔
        RingTheory.Sequence.IsRegular M rs := by
  induction rs with
  | nil =>
    intro M _ _
    refine ⟨?_, ?_⟩
    · rintro ⟨_, hPi_top⟩
      refine ⟨.nil R M, ?_⟩
      rw [Ideal.ofList_nil, Submodule.bot_smul] at hPi_top ⊢
      intro habs
      apply hPi_top
      rw [Submodule.eq_bot_iff] at habs ⊢
      intro f _
      funext i
      exact habs (f i) trivial
    · rintro ⟨_, hM_top⟩
      refine ⟨.nil R (ι → M), ?_⟩
      rw [Ideal.ofList_nil, Submodule.bot_smul] at hM_top ⊢
      obtain ⟨j⟩ := ‹Nonempty ι›
      intro habs
      apply hM_top
      rw [Submodule.eq_bot_iff] at habs ⊢
      intro m _
      have hsingle : (Pi.single j m : ι → M) = 0 := habs _ trivial
      have heval := congr_fun hsingle j
      rwa [Pi.single_eq_same, Pi.zero_apply] at heval
  | cons r rs' ih =>
    intro M _ _
    rw [RingTheory.Sequence.isRegular_cons_iff, RingTheory.Sequence.isRegular_cons_iff]
    refine and_congr ?_ ?_
    · constructor
      · intro h
        obtain ⟨j⟩ := ‹Nonempty ι›
        exact Pi.isSMulRegular_iff.mp h j
      · intro h
        exact Pi.isSMulRegular_iff.mpr fun _ => h
    · rw [LinearEquiv.isRegular_congr
        (quotSMulTopPiConstLinearEquiv (R := R) (ι := ι) r (M := M)) rs']
      exact ih (M := QuotSMulTop r M)

/-- **Main iter-194 Lane G closure.** For any commutative ring `R`, ideal `I`,
`R`-module `M`, and nonempty finite type `ι`, the depth of the Pi module
`ι → M` equals the depth of `M`:
```
  depth I (ι → M) = depth I M.
```
This is the substrate for the `pd_R(M) = 0` case of the Auslander–Buchsbaum
formula: a finite free module `M ≃ₗ[R] Fin k → R` has `depth(M) = depth(R)`,
so `0 + depth(M) = depth(R)` holds. -/
lemma depth_pi_const_eq_depth_of_nonempty
    {R : Type u} [CommRing R] (I : Ideal R)
    {ι : Type*} [Fintype ι] [DecidableEq ι] [Nonempty ι]
    {M : Type v} [AddCommGroup M] [Module R M] :
    depth I (ι → M) = depth I M := by
  unfold depth
  by_cases h : I • (⊤ : Submodule R (ι → M)) = ⊤
  · rw [if_pos h, if_pos ((ideal_smul_top_pi_const_eq_top_iff I).mp h)]
  · rw [if_neg h, if_neg (mt (ideal_smul_top_pi_const_eq_top_iff I).mpr h)]
    congr 1
    ext n
    refine ⟨?_, ?_⟩
    · rintro ⟨rs, hlen, hmem, hreg⟩
      exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty rs).mp hreg⟩
    · rintro ⟨rs, hlen, hmem, hreg⟩
      exact ⟨rs, hlen, hmem, (isRegular_pi_const_iff_of_nonempty rs).mpr hreg⟩

/-! ### Helper iter-198 Lane AB (axiom-clean): depth drops by exactly one for a regular
element (Stacks `lemma-depth-drops-by-one`).

For a Noetherian local ring `(R, 𝔪)`, a nonzero finite `R`-module `M`, and `x ∈ 𝔪` an
`M`-regular element, the depth of `M/xM` is exactly one less than the depth of `M`:
`depth(M/xM) + 1 = depth(M)`.

This is one of the four substrate gaps for the Auslander–Buchsbaum n=k+1 step (the
"depth-drops-by-one" piece). The proof packages the long-exact sequence of
`Ext^*(κ, -)` on the SES `0 → M →[x] M → M/xM → 0`, using that
`[x]` is zero on every `Ext^*(κ, M)` (since `x ∈ Ann κ`) to break the LES into short
exact pieces `0 → Ext^i(κ, M) → Ext^i(κ, M/xM) → Ext^{i+1}(κ, M) → 0`.

Routed through `depth_eq_smallest_ext_index` on both sides + the `ENat.forall_natCast_le_iff_le`
two-direction bridge that converts a natural-number indexed predicate to a `ℕ∞` inequality. -/
lemma depth_quotSMulTop_succ_eq_depth_of_isSMulRegular
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M] {x : R} (hxMem : x ∈ IsLocalRing.maximalIdeal R)
    (hxReg : IsSMulRegular M x) :
    depth (IsLocalRing.maximalIdeal R) (QuotSMulTop x M) + 1 =
      depth (IsLocalRing.maximalIdeal R) M := by
  haveI hMxM_nt : Nontrivial (QuotSMulTop x M) :=
    nontrivial_quotSMulTop_of_mem_maximalIdeal M hxMem
  haveI : _root_.Module.Finite R (QuotSMulTop x M) := inferInstance
  -- κ as a ModuleCat for compact notation.
  set κ : ModuleCat.{u} R := ModuleCat.of R (IsLocalRing.ResidueField R) with hκ
  -- x annihilates κ.
  have hxAnnih : x ∈ _root_.Module.annihilator R (IsLocalRing.ResidueField R) := by
    have h : _root_.Module.annihilator R (IsLocalRing.ResidueField R)
        = IsLocalRing.maximalIdeal R := Ideal.annihilator_quotient
    rw [h]; exact hxMem
  -- The SES `0 → M →[x] M → M/xM → 0`.
  let S : ShortComplex (ModuleCat.{u} R) :=
    ModuleCat.smulShortComplex (ModuleCat.of R M) x
  have hS : S.ShortExact := hxReg.smulShortComplex_shortExact
  have hSf_eq_smul : S.f = x • (𝟙 (ModuleCat.of R M) : _ ⟶ _) := rfl
  -- `[x]_*` is zero on every `Ext^i(κ, M)` via the helper `ext_smul_eq_zero_of_mem_annihilator`.
  have hSf_kill : ∀ {i : ℕ} (e : Abelian.Ext.{u} κ (ModuleCat.of R M) i),
      e.comp (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero i) = 0 := by
    intro i e
    have hcomp :
        e.comp (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero i) = x • e := by
      rw [hSf_eq_smul]
      exact (CategoryTheory.Abelian.Ext.smul_eq_comp_mk₀ e x).symm
    rw [hcomp]
    exact ext_smul_eq_zero_of_mem_annihilator e hxAnnih
  refine le_antisymm ?_ ?_
  · -- (≥): depth(M/xM) + 1 ≤ depth M.
    rw [← ENat.forall_natCast_le_iff_le]
    intro a ha
    rcases Nat.eq_zero_or_pos a with h0 | hpos
    · subst h0; exact bot_le
    · obtain ⟨n, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hpos)
      have hcast : ((n + 1 : ℕ) : ℕ∞) = (n : ℕ∞) + 1 := by push_cast; ring
      have hcast' : (Nat.succ n : ℕ) = n + 1 := rfl
      rw [hcast'] at ha
      rw [hcast] at ha
      have hone_ne_top : (1 : ℕ∞) ≠ ⊤ := by simp
      have hn_le_MxM :
          (n : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) (QuotSMulTop x M) :=
        (ENat.add_le_add_iff_right hone_ne_top).mp ha
      have hMxM_vanish : ∀ j : ℕ, j < n → ∀ e : Abelian.Ext.{u} κ
            (ModuleCat.of R (QuotSMulTop x M)) j, e = 0 :=
        (depth_eq_smallest_ext_index (M := QuotSMulTop x M) n).mp hn_le_MxM
      change ((n.succ : ℕ) : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) M
      rw [hcast']
      rw [depth_eq_smallest_ext_index]
      intro i hi e
      rcases Nat.eq_zero_or_pos i with hi0 | hi_pos
      · subst hi0
        -- i = 0 case: x being M-regular ⟹ S.f mono ⟹ postcomp_mk₀_injective_of_mono.
        haveI hmono : CategoryTheory.Mono S.f := by
          rw [ModuleCat.mono_iff_injective]
          exact hxReg
        have hinj := CategoryTheory.Abelian.Ext.postcomp_mk₀_injective_of_mono κ S.f
        apply hinj
        change e.comp (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero 0)
          = (0 : Abelian.Ext.{u} κ (ModuleCat.of R M) 0).comp
              (CategoryTheory.Abelian.Ext.mk₀ S.f) (add_zero 0)
        rw [CategoryTheory.Abelian.Ext.zero_comp]
        exact hSf_kill e
      · -- i ≥ 1: write i = j + 1, use `covariant_sequence_exact₁`.
        obtain ⟨j, rfl⟩ := Nat.exists_eq_succ_of_ne_zero
          (Nat.pos_iff_ne_zero.mp hi_pos)
        have hj : j < n := by omega
        obtain ⟨x₃, hx₃⟩ :=
          CategoryTheory.Abelian.Ext.covariant_sequence_exact₁ κ hS e (hSf_kill e) rfl
        have hx₃_zero : x₃ = 0 := hMxM_vanish j hj _
        rw [hx₃_zero] at hx₃
        simpa using hx₃.symm
  · -- (≤): depth M ≤ depth(M/xM) + 1.
    rw [← ENat.forall_natCast_le_iff_le]
    intro a ha
    rcases Nat.eq_zero_or_pos a with h0 | hpos
    · subst h0; exact bot_le
    · obtain ⟨m, rfl⟩ := Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hpos)
      have hcast' : (Nat.succ m : ℕ) = m + 1 := rfl
      rw [hcast'] at ha
      have hM_vanish : ∀ i : ℕ, i < m + 1 → ∀ e : Abelian.Ext.{u} κ
            (ModuleCat.of R M) i, e = 0 :=
        (depth_eq_smallest_ext_index (M := M) (m + 1)).mp ha
      have hcast : ((m + 1 : ℕ) : ℕ∞) = (m : ℕ∞) + 1 := by push_cast; ring
      change ((m.succ : ℕ) : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) (QuotSMulTop x M) + 1
      rw [hcast', hcast]
      -- It suffices to show m ≤ depth(M/xM).
      have hMxM_bound :
          (m : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) (QuotSMulTop x M) := by
        rw [depth_eq_smallest_ext_index]
        intro j hj e
        -- Use `covariant_sequence_exact₃` at n₀ = j, n₁ = j + 1.
        have he_extClass : e.comp hS.extClass (rfl : j + 1 = j + 1) = 0 :=
          hM_vanish (j + 1) (by omega) _
        obtain ⟨x₂, hx₂⟩ :=
          CategoryTheory.Abelian.Ext.covariant_sequence_exact₃ κ hS e rfl he_extClass
        have hx₂_zero : x₂ = 0 := hM_vanish j (by omega) _
        rw [hx₂_zero] at hx₂
        simpa using hx₂.symm
      gcongr

/-! ### Helper iter-198 Lane AB (axiom-clean): regular-element existence from positive depth.

For a Noetherian local ring `(R, 𝔪)` and a nonzero finite `R`-module `M`, the assertion
`1 ≤ depth_𝔪(M)` is equivalent to the existence of an `M`-regular element `x ∈ 𝔪`. This
is a direct consequence of unfolding the depth definition to a regular-sequence supremum
(Nakayama rules out the `𝔪 • ⊤ = ⊤` trivialisation in the `Nontrivial M` setting) and
reading off a length-1 witness.

This is the substrate companion to `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`: the
two together implement the Stacks tag 00LE step "depth-drops-by-one for any regular
element" plus its prerequisite "the regular element exists". -/
lemma exists_isSMulRegular_of_one_le_depth
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M]
    (h : (1 : ℕ∞) ≤ depth (IsLocalRing.maximalIdeal R) M) :
    ∃ x : R, x ∈ IsLocalRing.maximalIdeal R ∧ IsSMulRegular M x := by
  -- Unfold depth: `𝔪 • ⊤ ≠ ⊤` by Nakayama in the `Nontrivial M` finite setting.
  have hne_M : (IsLocalRing.maximalIdeal R) • (⊤ : Submodule R M) ≠ ⊤ :=
    Ne.symm (Submodule.top_ne_ideal_smul_of_le_jacobson_annihilator
      (IsLocalRing.maximalIdeal_le_jacobson _))
  have hdepth_unfold :
      depth (IsLocalRing.maximalIdeal R) M
        = sSup { k : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = k ∧
          (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
          ∧ RingTheory.Sequence.IsRegular M rs } := by
    rw [depth, if_neg hne_M]
  rw [hdepth_unfold] at h
  have hlt : (0 : ℕ∞) < sSup { k : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = k ∧
      (∀ r ∈ rs, r ∈ IsLocalRing.maximalIdeal R)
      ∧ RingTheory.Sequence.IsRegular M rs } := by
    calc (0 : ℕ∞) < 1 := by norm_num
      _ ≤ _ := h
  obtain ⟨k, ⟨rs, hrs_len, hrs_mem, hrs_reg⟩, hk_lt⟩ := lt_sSup_iff.mp hlt
  -- rs has positive length (since (0 : ℕ∞) < ↑rs.length).
  have hrs_pos : 0 < rs.length := by
    by_contra h_neg
    push Not at h_neg
    have hk0 : rs.length = 0 := Nat.le_zero.mp h_neg
    rw [hk0] at hrs_len
    simp only [Nat.cast_zero] at hrs_len
    rw [← hrs_len] at hk_lt
    exact absurd hk_lt (lt_irrefl _)
  rcases rs with _ | ⟨x, rs_tail⟩
  · simp at hrs_pos
  · refine ⟨x, hrs_mem x List.mem_cons_self, ?_⟩
    exact ((RingTheory.Sequence.isRegular_cons_iff M x rs_tail).mp hrs_reg).1

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

/-! ### Lane G iter-195 structural carving: inductive-step helper.

The `pd_R(M) = k + 1` inductive step of the Auslander–Buchsbaum formula is
extracted into the helper `auslander_buchsbaum_formula_succ_pd` below. This
isolates the entire substrate-gap content of the inductive step into a
single named typed-`sorry` declaration with a precise iter-196+
re-engagement plan, rather than an opaque inline `sorry` at the case-split
site. The main theorem then dispatches the `n > 0` branch by a one-line
`exact` call to the helper.

Per the iter-195 Lane G directive (OFF-CRITICAL-PATH minimal dispatch),
this is a **structural commit** (option (b): carving with iter-196 re-
engagement timeline). The HARD BAR is met; closure is deferred. -/

/-- **Lane G iter-195 structural carving (typed-`sorry` substrate-gap helper).**

The `pd_R(M) = k + 1` inductive step of the Auslander–Buchsbaum formula.

**Blueprint proof shape** (`sec:ab_main` inductive step, Stacks 090V).
Strong induction on `depth(M)`:

* **Sub-case `depth(M) = 0`.** Let `e := pd_R(M) = k + 1`. By Stacks
  `lemma-add-trivial-complex` (minimal-finite-free-resolution carving),
  `M` admits a minimal resolution
  `0 → R^{n_e} → R^{n_{e-1}} → ⋯ → R^{n_0} → M → 0` with all matrix
  coefficients in `𝔪`. The "what is exact" criterion (Stacks 00MF)
  gives `depth(R) ≥ e`. Iterating `depth_of_short_exact` on the
  short-exact splits `0 → R^{n_e} → R^{n_{e-1}} → K_{e-2} → 0`, …,
  `0 → K_0 → R^{n_0} → M → 0` gives
  `depth(K_{e-c}) ≥ depth(R) - (c - 1)` and finally
  `depth(M) ≥ depth(R) - e`. Since `depth(M) = 0`, also `depth(R) ≤ e`,
  hence `depth(R) = e = (k + 1) + depth(M)`.

* **Sub-case `depth(M) > 0`.** Pick `x ∈ 𝔪` a common NZD on both `R`
  and `M` (Stacks `lemma-depth-sum-direct-sum` ⟹ `depth(R ⊕ M) > 0`,
  hence a common NZD via prime avoidance over `Ass(R) ∪ Ass(M)`). The
  snake lemma applied to multiplication by `x` on a minimal resolution
  of `M` produces a minimal resolution of `M/xM` over `R/xR` of the
  same length, so `pd_{R/xR}(M/xM) = k + 1`. By Stacks
  `lemma-depth-drops-by-one`, `depth(R/xR) = depth(R) - 1` and
  `depth(M/xM) = depth(M) - 1`, with regular sequences in `𝔪`
  corresponding to those in `𝔪/(x)`, so
  `depth_R(M/xM) = depth_{R/xR}(M/xM)`. The IH on `M/xM` over `R/xR`
  gives `(k + 1) + (depth(M) - 1) = depth(R) - 1`, i.e.
  `(k + 1) + depth(M) = depth(R)`.

**Mathlib substrate gaps** (iter-196+ targets; pinned-commit `b80f227`
audit per chapter `Albanese_AuslanderBuchsbaum.tex` L554-560). All four
pieces are absent:

1. **Minimal finite free resolutions** (Stacks `lemma-add-trivial-complex`):
   trim any finite free resolution to one with entries in `𝔪 P_i`.
   ~80-120 LOC, independent and testable in isolation.
2. **"What is exact" criterion** (Stacks 00MF, `proposition-what-exact`):
   exactness ↔ depth-of-`r`-minor-ideals bound. ~150-200 LOC.
3. **Snake-lemma-on-resolution**: tensoring a minimal resolution by
   `R/xR` preserves minimal-exact (uses `x` NZD on each syzygy module).
   ~80-120 LOC; depends on (1).
4. **Depth-drops-by-one** (Stacks `lemma-depth-drops-by-one`): for `x`
   an `M`-NZD, `depth(M/xM) = depth(M) - 1`. ~40-60 LOC; routes
   through the existing `depth_eq_smallest_ext_index` infrastructure
   plus the SES `0 → M →[x] M → M/xM → 0` LES of `Ext^*(κ, -)`.

**iter-196+ re-engagement plan.** Estimated 4-8 iters total for full
substrate work (matching the chapter L554-560 NOTE).

* **iter-196 first slice:** piece (4) `depth-drops-by-one` — smallest;
  the LES infrastructure (`covariant_sequence_exact₁`, …,
  `covariant_sequence_exact₃`) and the `IsSMulRegular.smulShortComplex_shortExact`
  packaging are already in this file (used inside
  `depth_eq_smallest_ext_index` and `depth_of_short_exact`).
* **iter-197:** piece (1) minimal-resolution carving — independent;
  reduces to the well-known "remove a trivial summand if one transition
  is split" induction.
* **iter-198-199:** piece (3) snake-lemma-on-resolution — depends on (1).
* **iter-200+:** piece (2) "what is exact" criterion — the largest gap;
  candidate for Mathlib upstream PR rather than project-side build.

After all four pieces land, this helper's body becomes ~50-80 LOC of
assembly following the blueprint proof shape above.

**Why OFF-CRITICAL-PATH.** Per the iter-194 review and chapter
L554-560 NOTE, the Auslander–Buchsbaum formula itself is NOT the gating
consumer for A.4.a (the surface-extension proof). The gating consumer
is `CohenMacaulay.of_regular` (Corollary `cor:regular_cohen_macaulay`,
this file §7), whose substrate gap is the single Stacks 00NQ
implication structurally narrowed in iter-189-194. The AB formula is
needed for the broader `dim ≤ depth` discourse but is not on the
critical path for the Albanese argument; this carving documents the
substrate cost for resumption when the critical path frees up. -/
private lemma auslander_buchsbaum_formula_succ_pd
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M] (k : ℕ)
    (_hpd : _root_.Module.projectiveDimension R M
        = ((k + 1 : ℕ) : WithBot ℕ∞)) :
    ((k + 1 : ℕ) : ℕ∞) + Module.depth (IsLocalRing.maximalIdeal R) M
      = Module.depth (IsLocalRing.maximalIdeal R) R := by
  -- iter-195 Lane G structural carving. Body deferred per the four substrate
  -- gaps documented in the docstring above. iter-198 Lane AB substrate progress:
  --   (1) minimal-resolution carving (Stacks lemma-add-trivial-complex) — GAP
  --   (2) "what is exact" criterion (Stacks 00MF) — GAP
  --   (3) snake-lemma-on-minimal-resolution (preserves pd under tensoring by R/(x)) — GAP
  --   (4) depth-drops-by-one (Stacks lemma-depth-drops-by-one) — CLOSED iter-198:
  --       `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular` (above this lemma,
  --       inside the `Module` namespace). Companion
  --       `exists_isSMulRegular_of_one_le_depth` lifts a positive-depth hypothesis
  --       to an explicit M-NZD witness in 𝔪.
  -- Remaining iter-199+ targets: (1)→(3). The body becomes ~80-120 LOC of
  -- assembly after the three remaining pieces land:
  --   * Strong induction on `depth M`; the IH applies at depth M - 1 (smaller).
  --   * Sub-case `depth M = 0`: needs (1)+(2). depth_R(M) ≥ k+1 from (2) (lower bound)
  --     and depth_R(M) ≤ k+1 from iterated depth_of_short_exact on (1)'s minimal
  --     resolution (upper bound).
  --   * Sub-case `depth M > 0`: pick a common NZD `x` on R and M, via
  --     `exists_isSMulRegular_of_one_le_depth` for M plus the "what is exact"
  --     criterion (2) giving `depth R > 0`. Apply (3) to get
  --     `pd_{R/xR}(M/xM) = pd_R(M) = k+1`; apply (4) on both R and M to drop
  --     both depths by 1. IH on (R/xR, M/xM) at depth M - 1 closes the formula.
  sorry

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

iter-195 Lane G: the inductive step `pd_R(M) = k + 1` is delegated to
the structural-carving helper `auslander_buchsbaum_formula_succ_pd`,
which packages the entire substrate gap (4 named Mathlib-absent pieces)
into a single typed `sorry` with a concrete iter-196+ re-engagement
plan. The base case `pd_R(M) = 0` closed kernel-clean iter-194 via the
finite-free-module + `depth_pi_const_eq_depth_of_nonempty` route. -/
theorem auslander_buchsbaum_formula
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    {M : Type u} [AddCommGroup M] [Module R M] [_root_.Module.Finite R M]
    [Nontrivial M]
    (n : ℕ)
    (_hpd : _root_.Module.projectiveDimension R M = (n : WithBot ℕ∞)) :
    (n : ℕ∞) + Module.depth (IsLocalRing.maximalIdeal R) M
      = Module.depth (IsLocalRing.maximalIdeal R) R := by
  -- iter-193 Lane G: structural scaffold for Stacks 090V. We split on `n` to
  -- isolate the base case `pd_R(M) = 0` (where `M` is finite free over a
  -- Noetherian local ring) from the inductive step `pd_R(M) = k + 1` (which
  -- inducts on `depth(M)` via the snake-lemma-on-minimal-resolution recipe).
  --
  -- The `depth_eq_of_linearEquiv` helper above (axiom-clean) is the substrate
  -- piece used in the `n = 0` case to identify `depth(M)` with `depth(R^k)`
  -- for `M ≃ₗ[R] (Fin k → R)`; the residual `depth(R^k) = depth(R)` step is
  -- the remaining substrate gap (a single direct-sum-of-modules depth fact).
  rcases Nat.eq_zero_or_pos n with hn0 | hn_pos
  · -- **Base case `n = 0`**: `pd_R(M) = 0` ⟹ `M` projective ⟹ (finite + local)
    -- `M` free ⟹ `depth(M) = depth(R)`. The formula
    -- `0 + depth(M) = depth(R)` collapses to `depth(M) = depth(R)`.
    subst hn0
    rw [Nat.cast_zero, zero_add]
    -- Step 1: unfold `_root_.Module.projectiveDimension` to the categorical
    -- form, then apply `projectiveDimension_eq_zero_iff`.
    have hpd' :
        CategoryTheory.projectiveDimension (ModuleCat.of R M) = (0 : WithBot ℕ∞) := by
      unfold _root_.Module.projectiveDimension at _hpd
      exact _hpd
    obtain ⟨hproj, _hNonZero⟩ :=
      (CategoryTheory.projectiveDimension_eq_zero_iff _).mp hpd'
    -- Step 2: `CategoryTheory.Projective (ModuleCat.of R M)` ⟹ `Module.Projective R M`.
    have hMproj : _root_.Module.Projective R M :=
      (IsProjective.iff_projective M).mpr hproj
    -- Step 3: `Module.Projective` ⟹ `Module.Flat`.
    haveI : _root_.Module.Flat R M := _root_.Module.Flat.of_projective
    -- Step 4: `Module.Flat` + `IsLocalRing` + `Module.Finite` ⟹ `Module.Free`.
    haveI : _root_.Module.Free R M := _root_.Module.free_of_flat_of_isLocalRing
    -- Step 5: with `M` finite free + `Nontrivial`, identify
    -- `depth(M) = depth(R)` via the `Module.finBasis` equivalence and the
    -- axiom-clean `depth_eq_of_linearEquiv` helper. The residual is the
    -- single, narrower statement: `depth(Fin k → R) = depth(R)` for `k ≥ 1`.
    have hk : 0 < _root_.Module.finrank R M :=
      (_root_.Module.finrank_pos_iff_of_free R M).mpr inferInstance
    set k : ℕ := _root_.Module.finrank R M with hk_def
    -- Build the equivalence `M ≃ₗ[R] (Fin k → R)` via the chosen basis.
    let e : M ≃ₗ[R] (Fin k → R) := (_root_.Module.finBasis R M).equivFun
    -- Transport `depth(M) = depth(Fin k → R)` using the axiom-clean helper.
    have hdepth_M_eq : Module.depth (IsLocalRing.maximalIdeal R) M
        = Module.depth (IsLocalRing.maximalIdeal R) (Fin k → R) :=
      Module.depth_eq_of_linearEquiv _ e
    rw [hdepth_M_eq]
    -- iter-194 Lane G HARD BAR closure: invoke the new axiom-clean helper
    -- `Module.depth_pi_const_eq_depth_of_nonempty` which proves the substrate
    -- `depth(ι → M) = depth(M)` for nonempty finite `ι` (Pi-quotient
    -- decomposition + regular-sequence transport).
    haveI : Nonempty (Fin k) := ⟨⟨0, hk⟩⟩
    exact Module.depth_pi_const_eq_depth_of_nonempty _
  · -- **Inductive step `n = k + 1`**: delegate to the iter-195 Lane G
    -- structural-carving helper `auslander_buchsbaum_formula_succ_pd`,
    -- whose docstring documents the 4 substrate-gap pieces and the
    -- concrete iter-196+ re-engagement plan.
    obtain ⟨k, rfl⟩ :=
      Nat.exists_eq_succ_of_ne_zero (Nat.pos_iff_ne_zero.mp hn_pos)
    exact auslander_buchsbaum_formula_succ_pd k _hpd

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

/-! ### Helper 1.5 (iter-187 Lane G sub-lane G1): cotangent-image of `x ∈ 𝔪 \ 𝔪²`

For a local ring `(R, 𝔪)` and `x ∈ 𝔪` with `x ∉ 𝔪²`, the image of `x` in the
cotangent space `𝔪.Cotangent` is nonzero. This is the key positivity input
for the iter-187 cotangent dim-drop lemma below.

Axiom-clean: direct from `Ideal.toCotangent_eq_zero`. -/
private lemma toCotangent_ne_zero_of_not_mem_sq
    {R : Type u} [CommRing R] [IsLocalRing R]
    (x : R) (hx : x ∈ IsLocalRing.maximalIdeal R)
    (hxnotsq : x ∉ IsLocalRing.maximalIdeal R ^ 2) :
    (IsLocalRing.maximalIdeal R).toCotangent
        (⟨x, hx⟩ : (IsLocalRing.maximalIdeal R : Ideal R)) ≠ 0 := by
  intro habs
  exact hxnotsq
    ((Ideal.toCotangent_eq_zero (I := IsLocalRing.maximalIdeal R) ⟨x, hx⟩).mp habs)

/-! ### Helper 2.0 (iter-187 Lane G sub-lane G1): cotangent dim-drop on `R ⧸ (x)`

**Statement.** For a Noetherian local ring `(R, 𝔪)` and `x ∈ 𝔪 \ 𝔪²`, the
cotangent space of `R / (x)` has dimension one less than that of `R`:
```
finrank κ' (CotangentSpace (R/(x))) + 1 = finrank κ (CotangentSpace R)
```
where `κ = R / 𝔪` and `κ' = (R/(x)) / 𝔪'` are the two residue fields
(canonically isomorphic via the natural quotient `R/𝔪 ≃ (R/(x))/𝔪'`).

**Role.** This is the cotangent-space dim-drop building block for
`exists_isSMulRegular_quotient_isRegularLocal_succ` below: once Stacks 00NQ
(regular local ⟹ domain) is filled in, this dim-drop is what upgrades
`R/(x)` of dimension `k` back to `IsRegularLocalRing` via
`IsRegularLocalRing.iff_finrank_cotangentSpace`.

**Proof structure** (Bourbaki-style via `Submodule.finrank_quotient_add_finrank`):
1. The R-algebra map `π : R → R/(x)` induces a κ-linear surjection of
   cotangent spaces `f : 𝔪.Cotangent → 𝔪'.Cotangent` via
   `Ideal.mapCotangent_surjective_of_comap_eq` (which applies because
   `(maximalIdeal R).comap π = ker π ⊔ maximalIdeal R = (x) ⊔ 𝔪 = 𝔪`).
2. The kernel of `f` is the R-submodule generated by the image `x̄` of `x`
   in `𝔪.Cotangent` (via `Ideal.mapCotangent_ker_of_surjective` — the
   kernel is `(Submodule.comap 𝔪.subtype ((x) ⊓ 𝔪)).map 𝔪.toCotangent`
   which collapses to `Submodule.span R {x̄}` because `(x) ⊆ 𝔪`).
3. The R-action on 𝔪.Cotangent factors through κ (it's a κ-vector space),
   so this is also `Submodule.span κ {x̄}`.
4. `x ∉ 𝔪²` ⟺ `x̄ ≠ 0` (Helper 1.5), giving
   `finrank κ (Submodule.span κ {x̄}) = 1` via `finrank_span_singleton`.
5. Combining via `Submodule.finrank_quotient_add_finrank` and the
   `LinearMap.quotKerEquivOfSurjective` isomorphism, we get the formula.
   The residue-field switch `κ → κ'` is handled by
   `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace`, which
   reduces the κ-finrank to spanFinrank (a ring-theoretic invariant) and
   the spanFinrank-equality is purely numeric.

**iter-187 deliverable**: structural scaffold with the assembled body left
as a single named typed sorry (the κ-subspace identification step). The
preparatory lemma `toCotangent_ne_zero_of_not_mem_sq` lands axiom-clean.

**iter-188+** body fill-in: instantiate steps (1)-(5) above. Key Mathlib API:
* `Ideal.mapCotangent`, `Ideal.mapCotangent_surjective_of_comap_eq`,
  `Ideal.mapCotangent_ker_of_surjective` (Mathlib b80f227 ✓)
* `Submodule.finrank_quotient_add_finrank` (Mathlib b80f227 ✓)
* `finrank_span_singleton` (Mathlib b80f227 ✓)
* `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace`
  (Mathlib b80f227 ✓) — bridges κ-finrank and κ'-finrank via spanFinrank.

The substantive ring-theoretic content is concentrated in the kernel
description (step 2) and the κ vs κ' identification (step 5); both
have axiom-clean Mathlib infrastructure but require a careful
multi-step instantiation. -/
private theorem finrank_cotangentSpace_quot_span_singleton_succ
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (x : R) (hx : x ∈ IsLocalRing.maximalIdeal R)
    (hxnotsq : x ∉ IsLocalRing.maximalIdeal R ^ 2)
    [Nontrivial (R ⧸ Ideal.span {x})]
    [IsLocalRing (R ⧸ Ideal.span {x})]
    [IsNoetherianRing (R ⧸ Ideal.span {x})] :
    Module.finrank (IsLocalRing.ResidueField (R ⧸ Ideal.span {x}))
        (IsLocalRing.CotangentSpace (R ⧸ Ideal.span {x})) + 1 =
      Module.finrank (IsLocalRing.ResidueField R) (IsLocalRing.CotangentSpace R) := by
  -- iter-187 Lane G sub-lane G1: reduce the κ-finrank statement to a
  -- spanFinrank statement (both sides go through
  -- `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace`),
  -- pushing the residual content into a single typed `sorry` on the
  -- numeric (ring-theoretic) spanFinrank-dim-drop equation.
  rw [← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace R,
      ← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace
          (R ⧸ Ideal.span {x})]
  -- Goal: (𝔪 (R/(x))).spanFinrank + 1 = (𝔪 R).spanFinrank
  -- iter-188 Lane G sub-lane G1: close via (≥) lift-and-cons + (≤) cotangent
  -- rank-nullity.
  refine le_antisymm ?_ ?_
  · -- (≤): (𝔪 (R/(x))).spanFinrank + 1 ≤ (𝔪 R).spanFinrank.
    -- iter-188 Lane G sub-lane G1 STRUCTURAL: Steinitz-exchange strategy
    -- broken into named steps. We carry out the substantive ring-theoretic
    -- content (Step 3: unit-coefficient extraction via Nakayama / x ∉ 𝔪²)
    -- in the body below. The residual typed `sorry` is the final assembly
    -- step (Steps 4-7), which is purely set-theoretic bookkeeping (lift to
    -- R, rewrite via mkx, count cardinalities); ~30-50 LOC for iter-189+.
    classical
    -- Get min gen finset V of 𝔪 R.
    have h𝔪_fg : (IsLocalRing.maximalIdeal R).FG := Ideal.fg_of_isNoetherianRing _
    obtain ⟨V, hV_card, hV_span⟩ :=
      Submodule.FG.exists_span_finset_card_eq_spanFinrank h𝔪_fg
    -- Step 1: spanFinrank 𝔪 R ≥ 1 (since x ∉ 𝔪² implies x ≠ 0, hence 𝔪 ≠ ⊥).
    have h_n_ge_1 : 1 ≤ Submodule.spanFinrank (IsLocalRing.maximalIdeal R) := by
      rw [← hV_card]
      by_contra h
      push Not at h
      have hV_empty : V.card = 0 := Nat.lt_one_iff.mp h
      have hV_eq : V = ∅ := Finset.card_eq_zero.mp hV_empty
      have h𝔪_bot : IsLocalRing.maximalIdeal R = ⊥ := by
        rw [← hV_span, hV_eq, Finset.coe_empty, Submodule.span_empty]
      apply hxnotsq
      have hx_bot : x ∈ (⊥ : Ideal R) := h𝔪_bot ▸ hx
      rw [Submodule.mem_bot] at hx_bot
      rw [hx_bot]; exact zero_mem _
    -- Step 2: x ∈ Submodule.span R V, extract coefficients via mem_span_finset.
    have hx_mem : x ∈ Submodule.span R (V : Set R) := hV_span ▸ hx
    obtain ⟨c, _hc_supp, hc_sum⟩ := Submodule.mem_span_finset.mp hx_mem
    -- Step 3 (axiom-clean): ∃ v₀ ∈ V with c v₀ ∉ 𝔪 R, i.e., c v₀ is a unit.
    -- If all c v ∈ 𝔪, then x = Σ c v • v ∈ 𝔪 · 𝔪 = 𝔪². Contradicts hxnotsq.
    have hexists_unit : ∃ v₀ ∈ V, c v₀ ∉ IsLocalRing.maximalIdeal R := by
      by_contra h
      push Not at h
      apply hxnotsq
      rw [pow_two, ← hc_sum]
      refine Submodule.sum_mem _ ?_
      intro v hvV
      have hcv_mem : c v ∈ IsLocalRing.maximalIdeal R := h v hvV
      have hv_mem : v ∈ IsLocalRing.maximalIdeal R := by
        rw [← hV_span]; exact Submodule.subset_span (by exact_mod_cast hvV)
      have hmul : c v • v ∈ (IsLocalRing.maximalIdeal R : Submodule R R) *
          IsLocalRing.maximalIdeal R := by
        rw [smul_eq_mul]
        exact Ideal.mul_mem_mul hcv_mem hv_mem
      simpa [Ideal.smul_eq_mul] using hmul
    obtain ⟨v₀, hv₀_V, hv₀_notmem⟩ := hexists_unit
    have hv₀_unit : IsUnit (c v₀) := IsLocalRing.notMem_maximalIdeal.mp hv₀_notmem
    obtain ⟨u, hu⟩ := hv₀_unit
    -- Step 4: v₀ = ↑u⁻¹ * x - Σ_{v ∈ V.erase v₀} ↑u⁻¹ * c v * v.
    have hsum_split : c v₀ * v₀ + ∑ v ∈ V.erase v₀, c v * v = x := by
      rw [← Finset.sum_erase_add _ _ hv₀_V] at hc_sum
      simp only [smul_eq_mul] at hc_sum
      linear_combination hc_sum
    have hu_inv : (↑u⁻¹ : R) * c v₀ = 1 := by rw [← hu]; exact Units.inv_mul u
    have h_sum_eq : (↑u⁻¹ : R) * ∑ v ∈ V.erase v₀, c v * v =
        ∑ v ∈ V.erase v₀, (↑u⁻¹ : R) * c v * v := by
      rw [Finset.mul_sum]; apply Finset.sum_congr rfl; intros; ring
    have hv₀_eq : v₀ = (↑u⁻¹ : R) * x -
        ∑ v ∈ V.erase v₀, (↑u⁻¹ : R) * c v * v := by
      have h1 : (↑u⁻¹ : R) * (c v₀ * v₀ + ∑ v ∈ V.erase v₀, c v * v) =
          (↑u⁻¹ : R) * x := by rw [hsum_split]
      rw [mul_add, ← mul_assoc, hu_inv, one_mul, h_sum_eq] at h1
      linear_combination h1
    have hv₀_in_new : v₀ ∈ Submodule.span R (insert x (V.erase v₀ : Set R)) := by
      -- Prove the membership via the explicit linear combination, then
      -- substitute the LHS via hv₀_eq.
      have key : (↑u⁻¹ : R) * x - ∑ v ∈ V.erase v₀, (↑u⁻¹ : R) * c v * v ∈
          Submodule.span R (insert x (V.erase v₀ : Set R)) := by
        apply Submodule.sub_mem
        · exact Submodule.smul_mem _ _
            (Submodule.subset_span (Set.mem_insert _ _))
        · apply Submodule.sum_mem
          intro v hvErase
          exact Submodule.smul_mem _ _
            (Submodule.subset_span (Set.mem_insert_of_mem _
              (by exact_mod_cast hvErase)))
      -- `rw [← hv₀_eq] at key` only rewrites the LHS occurrence (the V.erase v₀
      -- in the RHS uses v₀ directly, not the explicit expr).
      rwa [← hv₀_eq] at key
    -- Step 5: Submodule.span R (insert x (V.erase v₀)) = 𝔪 R.
    have h𝔪R_new : Submodule.span R (insert x (V.erase v₀ : Set R)) =
        IsLocalRing.maximalIdeal R := by
      apply le_antisymm
      · rw [Submodule.span_le]
        rintro y hy
        rcases hy with rfl | hy
        · exact hx
        · have hy_V : y ∈ V := Finset.mem_of_mem_erase (by exact_mod_cast hy)
          rw [← hV_span]
          exact Submodule.subset_span (by exact_mod_cast hy_V)
      · rw [← hV_span, Submodule.span_le]
        intro v hv
        by_cases hv_eq : v = v₀
        · rw [hv_eq]; exact hv₀_in_new
        · refine Submodule.subset_span ?_
          right
          exact_mod_cast Finset.mem_erase.mpr ⟨hv_eq, by exact_mod_cast hv⟩
    -- Step 6: 𝔪 R' = Ideal.span (mkx '' (V.erase v₀)).
    -- First, 𝔪 R' = Ideal.map mkx 𝔪 R, and mkx x = 0.
    set mkx : R →+* (R ⧸ Ideal.span {x}) := Ideal.Quotient.mk _ with hmkx_def
    have h_mkx_x : mkx x = 0 :=
      Ideal.Quotient.eq_zero_iff_mem.mpr (Submodule.mem_span_singleton_self x)
    have hcomap_eq : Ideal.comap mkx
        (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x})) =
        IsLocalRing.maximalIdeal R := by
      have hmax : (Ideal.comap mkx
          (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x}))).IsMaximal :=
        Ideal.comap_isMaximal_of_surjective _ Ideal.Quotient.mk_surjective
      exact (IsLocalRing.isMaximal_iff R).mp hmax
    have h𝔪R'_eq_map : IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x}) =
        Ideal.map mkx (IsLocalRing.maximalIdeal R) := by
      conv_rhs => rw [← hcomap_eq]
      exact (Ideal.map_comap_of_surjective _ Ideal.Quotient.mk_surjective _).symm
    -- Now 𝔪 R' = Ideal.map mkx (span (insert x (V.erase v₀)))
    --         = Ideal.span (mkx '' (insert x (V.erase v₀)))
    --         = Ideal.span (insert 0 (mkx '' (V.erase v₀)))
    --         ≤ Submodule.span R' (mkx '' (V.erase v₀)).
    -- For the spanFinrank bound it suffices to show the inequality
    -- spanFinrank 𝔪 R' ≤ |V.erase v₀|.
    have h_bound : Submodule.spanFinrank
        (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x})) ≤ V.card - 1 := by
      have h𝔪R'_span : IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x}) =
          Ideal.span (mkx '' (V.erase v₀ : Set R)) := by
        rw [h𝔪R'_eq_map, ← h𝔪R_new, Ideal.map_span,
            Set.image_insert_eq, h_mkx_x]
        -- Goal: Ideal.span (insert 0 (mkx '' V.erase v₀)) =
        --        Ideal.span (mkx '' V.erase v₀).
        -- 0 ∈ Ideal.span A for any A, so adding 0 doesn't change span.
        apply le_antisymm
        · rw [Ideal.span_le]
          rintro y (rfl | hy)
          · exact Submodule.zero_mem _
          · exact Submodule.subset_span hy
        · exact Ideal.span_mono (Set.subset_insert _ _)
      calc Submodule.spanFinrank
            (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x}))
          = Submodule.spanFinrank
              (Ideal.span (mkx '' (V.erase v₀ : Set R))) := by rw [h𝔪R'_span]
        _ = Submodule.spanFinrank
              (Submodule.span _ (mkx '' (V.erase v₀ : Set R))) := rfl
        _ ≤ (mkx '' (V.erase v₀ : Set R)).ncard :=
            Submodule.spanFinrank_span_le_ncard_of_finite
              ((V.erase v₀).finite_toSet.image _)
        _ ≤ (V.erase v₀ : Set R).ncard :=
            Set.ncard_image_le (V.erase v₀).finite_toSet
        _ = (V.erase v₀).card := Set.ncard_coe_finset _
        _ = V.card - 1 := Finset.card_erase_of_mem hv₀_V
    -- Step 7: conclude using h_n_ge_1.
    omega
  · -- (≥): (𝔪 R).spanFinrank ≤ (𝔪 (R/(x))).spanFinrank + 1.
    -- Lift-and-cons strategy: a min gen set T of 𝔪 (R/(x)) lifts to T_lift ⊆
    -- 𝔪 R via `Function.surjInv` of `Ideal.Quotient.mk_surjective`; the union
    -- `T_lift ∪ {x}` generates 𝔪 R since 𝔪 R = (Ideal.span {x}) ⊔ (lift of 𝔪').
    classical
    set R' : Type u := R ⧸ Ideal.span {x} with hR'_def
    let mkx : R →+* R' := Ideal.Quotient.mk _
    let g : R' → R := Function.surjInv Ideal.Quotient.mk_surjective
    have hg : ∀ y, mkx (g y) = y := Function.surjInv_eq _
    -- Get min gen finset of 𝔪'.
    have h𝔪'_fg : (IsLocalRing.maximalIdeal R').FG := Ideal.fg_of_isNoetherianRing _
    obtain ⟨T, hT_card, hT_span⟩ :=
      Submodule.FG.exists_span_finset_card_eq_spanFinrank h𝔪'_fg
    -- T : Finset R', T.card = spanFinrank 𝔪', span R' T = 𝔪'.
    let T_lift : Finset R := T.image g
    let U : Finset R := insert x T_lift
    -- Step A: U generates 𝔪 R via the comap identification.
    -- Comap mkx (𝔪 R') = 𝔪 R, since R is local and mkx is surjective.
    have hcomap_eq : Ideal.comap mkx (IsLocalRing.maximalIdeal R') =
        IsLocalRing.maximalIdeal R := by
      have hmax : (Ideal.comap mkx (IsLocalRing.maximalIdeal R')).IsMaximal :=
        Ideal.comap_isMaximal_of_surjective _ Ideal.Quotient.mk_surjective
      exact (IsLocalRing.isMaximal_iff R).mp hmax
    have hker_eq : RingHom.ker mkx = Ideal.span {x} := Ideal.mk_ker
    -- Step B: 𝔪 R = (Ideal.span T_lift) ⊔ (Ideal.span {x}).
    -- Compute: comap mkx (map mkx (Ideal.span T_lift)) = Ideal.span T_lift ⊔ ker mkx.
    have hmap_T_lift : Ideal.map mkx (Ideal.span (T_lift : Set R)) =
        IsLocalRing.maximalIdeal R' := by
      rw [Ideal.map_span]
      -- mkx '' T_lift = T (as sets).
      have him : mkx '' (T_lift : Set R) = (T : Set R') := by
        ext y
        simp only [Set.mem_image, Finset.coe_image, T_lift]
        refine ⟨?_, ?_⟩
        · rintro ⟨a, ⟨b, hbT, rfl⟩, rfl⟩
          rw [hg b]; exact hbT
        · intro hyT
          exact ⟨g y, ⟨y, hyT, rfl⟩, hg y⟩
      rw [him]; exact hT_span
    have h𝔪R_decomp : IsLocalRing.maximalIdeal R =
        Ideal.span (T_lift : Set R) ⊔ Ideal.span {x} := by
      calc IsLocalRing.maximalIdeal R
          = Ideal.comap mkx (IsLocalRing.maximalIdeal R') := hcomap_eq.symm
        _ = Ideal.comap mkx (Ideal.map mkx (Ideal.span (T_lift : Set R))) := by
              rw [hmap_T_lift]
        _ = Ideal.span (T_lift : Set R) ⊔ RingHom.ker mkx := by
              rw [Ideal.comap_map_of_surjective' mkx Ideal.Quotient.mk_surjective]
        _ = Ideal.span (T_lift : Set R) ⊔ Ideal.span {x} := by rw [hker_eq]
    -- Step C: span R U = Ideal.span T_lift ⊔ Ideal.span {x}.
    have hU_span_eq : Submodule.span R (↑U : Set R) =
        Ideal.span (T_lift : Set R) ⊔ Ideal.span {x} := by
      have hUeq : (↑U : Set R) = (↑T_lift : Set R) ∪ {x} := by
        change ((insert x T_lift : Finset R) : Set R) = _
        rw [Finset.coe_insert, Set.insert_eq, Set.union_comm]
      rw [hUeq, Submodule.span_union]
    -- Step D: spanFinrank 𝔪 R ≤ U.card ≤ T.card + 1.
    calc Submodule.spanFinrank (IsLocalRing.maximalIdeal R)
        = Submodule.spanFinrank (Submodule.span R (↑U : Set R)) := by
          rw [hU_span_eq, ← h𝔪R_decomp]
      _ ≤ (↑U : Set R).ncard :=
          Submodule.spanFinrank_span_le_ncard_of_finite U.finite_toSet
      _ = U.card := by simp
      _ ≤ T_lift.card + 1 := by
          have := Finset.card_insert_le x T_lift
          simpa [U] using this
      _ ≤ T.card + 1 := by
          have hle : T_lift.card ≤ T.card := Finset.card_image_le
          omega
      _ = Submodule.spanFinrank (IsLocalRing.maximalIdeal R') + 1 := by
          rw [hT_card]

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

/-! ### Narrow substrate gap (Stacks 00NQ): regular local ring is a domain

The Auslander–Buchsbaum-route closure of "regular local ring is Cohen–Macaulay"
ultimately reduces to **Stacks 00NQ**: every regular local Noetherian ring
is an integral domain. Mathlib at the pinned commit `b80f227` does not expose
this implication (`lean_leansearch` for "regular local ring is a domain"
returns nothing relevant; `lean_loogle` for `IsRegularLocalRing _ → IsDomain _`
returns empty).

Stacks 00NQ proof sketch (induction on `dim R = spanFinrank 𝔪`):
* Base `dim R = 0`: then `𝔪 = ⊥`, hence `R` is a field, hence a domain.
* Step `dim R = d + 1 ≥ 1`:
  - Pick `x ∈ 𝔪 \ 𝔪²` (axiom-clean via Nakayama; see
    `exists_notMemSq_of_spanFinrank_pos` below).
  - By the cotangent dim-drop (`finrank_cotangentSpace_quot_span_singleton_succ`,
    iter-188 Lane G1 closure) **plus** Krull's principal ideal theorem
    (`ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim_of_mem_jacobson`
    gives the `≥` half), `R / (x)` is regular local of dim `d`.
  - By induction, `R / (x)` is a domain, hence `(x)` is a prime ideal of `R`.
  - Let `𝔭` be a minimal prime of `R` with `𝔭 ⊆ (x)`. For `y ∈ 𝔭`, write
    `y = xz`; since `𝔭` is prime and `x ∉ 𝔭` (else `x ∈ 𝔭 ⊆ (x)` doesn't
    immediately give a contradiction but combined with `dim R/(x) = d` and
    `x ∈ 𝔭` height-zero we get `𝔭 = 0` which is the conclusion), we get
    `z ∈ 𝔭`. Hence `𝔭 ⊆ x 𝔭`, so iterating, `𝔭 ⊆ ∩ x^n 𝔭 ⊆ ∩ 𝔪^n = 0`
    (Krull intersection). So `𝔭 = 0`, and `R` is a domain.

Full formalization is ~300 LOC (involves Krull's PIT, prime avoidance,
Krull intersection, minimal-primes-are-finite); deferred to a future iter
or Mathlib upstream contribution. -/

/-- **Axiom-clean Nakayama witness.** For a Noetherian local ring `(R, 𝔪)`
with `spanFinrank 𝔪 ≥ 1`, there exists `x ∈ 𝔪` with `x ∉ 𝔪²`.

This is the "cotangent space is nonzero" content: by Nakayama, if `𝔪 ⊆ 𝔪²`
then `𝔪 = 0` (so `spanFinrank 𝔪 = 0`), contradicting the hypothesis. -/
private lemma exists_notMemSq_of_spanFinrank_pos
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (h : 0 < (IsLocalRing.maximalIdeal R).spanFinrank) :
    ∃ x ∈ IsLocalRing.maximalIdeal R, x ∉ (IsLocalRing.maximalIdeal R) ^ 2 := by
  -- By contradiction: assume 𝔪 ⊆ 𝔪², then by Nakayama 𝔪 = 0, but spanFinrank 𝔪 ≥ 1.
  by_contra h_neg
  push Not at h_neg
  have h𝔪_le_sq : IsLocalRing.maximalIdeal R ≤ (IsLocalRing.maximalIdeal R) ^ 2 := h_neg
  -- 𝔪² = 𝔪 • 𝔪.
  have hsq : (IsLocalRing.maximalIdeal R : Submodule R R) ^ 2
      = (IsLocalRing.maximalIdeal R) • (IsLocalRing.maximalIdeal R : Submodule R R) := by
    rw [sq, ← Ideal.smul_eq_mul]
  have h𝔪_fg : (IsLocalRing.maximalIdeal R : Submodule R R).FG :=
    Ideal.fg_of_isNoetherianRing _
  -- Use Submodule.le_of_le_smul_of_le_jacobson_bot with N = ⊥.
  have hjac : (IsLocalRing.maximalIdeal R) ≤ (⊥ : Ideal R).jacobson :=
    IsLocalRing.maximalIdeal_le_jacobson _
  have h_le_smul : (IsLocalRing.maximalIdeal R : Submodule R R)
      ≤ ⊥ ⊔ (IsLocalRing.maximalIdeal R) •
        (IsLocalRing.maximalIdeal R : Submodule R R) := by
    rw [bot_sup_eq, ← hsq]; exact h𝔪_le_sq
  have h𝔪_bot : (IsLocalRing.maximalIdeal R : Submodule R R) ≤ ⊥ :=
    Submodule.le_of_le_smul_of_le_jacobson_bot h𝔪_fg hjac h_le_smul
  have h𝔪_eq_bot : (IsLocalRing.maximalIdeal R) = ⊥ := le_bot_iff.mp h𝔪_bot
  have h_span : (IsLocalRing.maximalIdeal R).spanFinrank = 0 := by
    rw [h𝔪_eq_bot]; exact Submodule.spanFinrank_bot
  omega

/-! ### Helper for Stacks 00NQ base case (iter-190 Lane G, axiom-clean).

For a Noetherian local ring `R` with `(maximalIdeal R).spanFinrank = 0`, the
ring `R` is a field, hence a domain. The maximal ideal collapses to `⊥` via
`Submodule.spanFinrank_eq_zero_iff_eq_bot` (under FG), and
`IsLocalRing.isField_iff_maximalIdeal_eq` upgrades the resulting field-by-
trivial-maximal-ideal characterisation to `IsField R`, from which
`IsField.isDomain` gives `IsDomain R`. -/
private lemma isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    (h : (IsLocalRing.maximalIdeal R).spanFinrank = 0) : IsDomain R := by
  have h𝔪_fg : (IsLocalRing.maximalIdeal R).FG :=
    Ideal.fg_of_isNoetherianRing _
  have h𝔪_bot : IsLocalRing.maximalIdeal R = ⊥ :=
    (Submodule.spanFinrank_eq_zero_iff_eq_bot h𝔪_fg).mp h
  have hField : IsField R :=
    IsLocalRing.isField_iff_maximalIdeal_eq.mpr h𝔪_bot
  exact hField.isDomain

/-! ### Helper for Stacks 00NU inductive step prep (iter-190 Lane G, axiom-clean).

For a regular local Noetherian ring `R` of `spanFinrank 𝔪 = k + 1` and
`x ∈ 𝔪 \ 𝔪²`, the quotient `R ⧸ Ideal.span {x}` is again a regular local
ring of `spanFinrank 𝔪' = k`.

This is the **axiom-clean** counterpart of
`exists_isSMulRegular_quotient_isRegularLocal_succ`: it avoids the
`IsSMulRegular R x` hypothesis (which depends on `isDomain_of_regularLocal`)
by routing the dimension lower bound through
`ringKrullDim_le_ringKrullDim_quotient_add_encard` — a Krull-height bound
that does NOT require `x` to be a non-zero-divisor — instead of
`ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`. -/
private lemma regularLocal_quotient_isRegularLocal_of_notMemSq
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] {k : ℕ}
    (hdim : (IsLocalRing.maximalIdeal R).spanFinrank = k + 1)
    (x : R) (hxMem : x ∈ IsLocalRing.maximalIdeal R)
    (hxNotSq : x ∉ (IsLocalRing.maximalIdeal R) ^ 2) :
    ∃ _ : Nontrivial (R ⧸ Ideal.span ({x} : Set R)),
    ∃ _ : IsLocalRing (R ⧸ Ideal.span ({x} : Set R)),
    ∃ _ : IsRegularLocalRing (R ⧸ Ideal.span ({x} : Set R)),
      (IsLocalRing.maximalIdeal (R ⧸ Ideal.span ({x} : Set R))).spanFinrank = k := by
  -- Step 1: instances on R/(x).
  have hxNonunit : ¬ IsUnit x := fun hu =>
    (IsLocalRing.notMem_maximalIdeal.mpr hu) hxMem
  have hspan_ne_top : (Ideal.span ({x} : Set R)) ≠ ⊤ :=
    Ideal.span_singleton_ne_top hxNonunit
  haveI hNT : Nontrivial (R ⧸ Ideal.span ({x} : Set R)) :=
    Ideal.Quotient.nontrivial_iff.mpr hspan_ne_top
  haveI hLR : IsLocalRing (R ⧸ Ideal.span ({x} : Set R)) :=
    IsLocalRing.of_surjective' (Ideal.Quotient.mk _) Ideal.Quotient.mk_surjective
  -- Step 2: cotangent dim drop → spanFinrank drop on R/(x).
  have hcot := finrank_cotangentSpace_quot_span_singleton_succ x hxMem hxNotSq
  have hR_cot_eq :
      Module.finrank (IsLocalRing.ResidueField R)
          (IsLocalRing.CotangentSpace R) = k + 1 := by
    rw [← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace R]
    exact hdim
  have hR'_cot_eq :
      Module.finrank (IsLocalRing.ResidueField (R ⧸ Ideal.span ({x} : Set R)))
          (IsLocalRing.CotangentSpace (R ⧸ Ideal.span ({x} : Set R))) = k := by
    have h := hcot
    rw [hR_cot_eq] at h
    omega
  have hspan_R'_eq_k :
      (IsLocalRing.maximalIdeal (R ⧸ Ideal.span ({x} : Set R))).spanFinrank = k := by
    rw [IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace
        (R ⧸ Ideal.span ({x} : Set R))]
    exact hR'_cot_eq
  -- Step 3: Krull height theorem: ringKrullDim R ≤ ringKrullDim R/(x) + 1.
  have hxJac : x ∈ Ring.jacobson R := by
    rw [IsLocalRing.ringJacobson_eq_maximalIdeal]
    exact hxMem
  have h_x_subset_jac : ({x} : Set R) ⊆ Ring.jacobson R := by
    intro y hy
    rcases hy with rfl
    exact hxJac
  have hKrullDimLE : ringKrullDim R ≤
      ringKrullDim (R ⧸ Ideal.span ({x} : Set R)) + 1 := by
    have h := ringKrullDim_le_ringKrullDim_quotient_add_encard
                ({x} : Set R) h_x_subset_jac
    simpa using h
  have hR_dim : ringKrullDim R = ((k + 1 : ℕ) : WithBot ℕ∞) := by
    have h := IsRegularLocalRing.spanFinrank_maximalIdeal (R := R)
    rw [hdim] at h
    exact_mod_cast h.symm
  -- Step 4: extract `ringKrullDim R/(x) = k` from hKrullDimLE + upper bound.
  -- Upper bound: `ringKrullDim R/(x) ≤ spanFinrank 𝔪' = k`.
  have h_dim_upper : ringKrullDim (R ⧸ Ideal.span ({x} : Set R)) ≤
      ((k : ℕ) : WithBot ℕ∞) := by
    refine le_trans (ringKrullDim_le_spanFinrank_maximalIdeal _) ?_
    rw [hspan_R'_eq_k]
  -- Adding 1 to both sides of h_dim_upper:
  -- `ringKrullDim R/(x) + 1 ≤ (k:WithBot) + 1 = (k+1:WithBot) = ringKrullDim R`.
  have h_add_le : ringKrullDim (R ⧸ Ideal.span ({x} : Set R)) + 1 ≤
      ((k + 1 : ℕ) : WithBot ℕ∞) := by
    calc ringKrullDim (R ⧸ Ideal.span ({x} : Set R)) + 1
        ≤ ((k : ℕ) : WithBot ℕ∞) + 1 := by gcongr
      _ = ((k + 1 : ℕ) : WithBot ℕ∞) := by push_cast; ring
  -- Combined with hKrullDimLE via hR_dim → equation in WithBot.
  have h_add_eq : ringKrullDim (R ⧸ Ideal.span ({x} : Set R)) + 1
      = ((k + 1 : ℕ) : WithBot ℕ∞) := by
    rw [hR_dim] at hKrullDimLE
    exact le_antisymm h_add_le hKrullDimLE
  -- Extract `ringKrullDim R/(x) = k : WithBot ℕ∞` via `WithBot.add_eq_coe`.
  have hR'_dim_eq : ringKrullDim (R ⧸ Ideal.span ({x} : Set R))
      = ((k : ℕ) : WithBot ℕ∞) := by
    obtain ⟨a', b', ha', hb', hab⟩ := WithBot.add_eq_coe.mp h_add_eq
    rw [← ha']
    have hb_eq : b' = (1 : ℕ∞) := by
      have h1 : ((b' : ℕ∞) : WithBot ℕ∞) = ((1 : ℕ∞) : WithBot ℕ∞) := by
        rw [hb']; simp
      exact_mod_cast h1
    have ha_eq : a' = (k : ℕ∞) := by
      rw [hb_eq] at hab
      have hcast2 : a' + 1 = (k : ℕ∞) + 1 := by exact_mod_cast hab
      have hne_top : (1 : ℕ∞) ≠ ⊤ := by simp
      exact WithTop.add_right_cancel hne_top hcast2
    exact_mod_cast ha_eq
  -- Step 5: spanFinrank 𝔪' = k = ringKrullDim R/(x) → IsRegularLocalRing R/(x).
  have hRLR : IsRegularLocalRing (R ⧸ Ideal.span ({x} : Set R)) := by
    apply IsRegularLocalRing.of_spanFinrank_maximalIdeal_le
    rw [hspan_R'_eq_k, hR'_dim_eq]
  exact ⟨hNT, hLR, hRLR, hspan_R'_eq_k⟩

/-! ### Helper iter-191 Lane G (axiom-clean): zero-divisor witness from a minimal prime

For a commutative ring `R` and a minimal prime `𝔭 ∈ minimalPrimes R`, every
element of `𝔭` is a zero-divisor in `R`. Concretely: for any `x ∈ 𝔭`, there
exists `y ∈ R, y ≠ 0` with `x * y = 0`.

Proof: minimal primes are disjoint from non-zero-divisors via
`Ideal.disjoint_nonZeroDivisors_of_mem_minimalPrimes`, so `x ∈ 𝔭` ⟹
`x ∉ nonZeroDivisors R` ⟹ `∃ y ≠ 0, x * y = 0`.

This packages the Stacks-00NQ-relevant first step for the `x ∈ 𝔭` case of
`isDomain_of_regularLocal`: when `(x)` is a minimal prime, `x` is a zero-divisor,
so the obstruction reduces to derivation of a contradiction from the
zero-divisor witness (using the regular-local structure of `R` and `R/(x)`). -/
private lemma exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes
    {R : Type u} [CommRing R] {𝔭 : Ideal R} (h𝔭 : 𝔭 ∈ minimalPrimes R)
    {x : R} (hx : x ∈ 𝔭) :
    ∃ y : R, y ≠ 0 ∧ x * y = 0 := by
  have hdisj : Disjoint (𝔭 : Set R) (nonZeroDivisors R : Set R) :=
    Ideal.disjoint_nonZeroDivisors_of_mem_minimalPrimes h𝔭
  have hxNot : x ∉ nonZeroDivisors R := fun hxNZD =>
    (Set.disjoint_left.mp hdisj) hx hxNZD
  have hExistsZD : ¬ ∀ z, x * z = 0 → z = 0 := fun h => hxNot <| by
    rw [mem_nonZeroDivisors_iff]
    refine ⟨h, fun z hz => h z (by rw [mul_comm]; exact hz)⟩
  push Not at hExistsZD
  obtain ⟨y, hxy, hy⟩ := hExistsZD
  exact ⟨y, hy, hxy⟩

/-! ### Helper iter-191 Lane G (substantive typed sorry): `(x)` is not a minimal prime
    in the regular-local inductive step

For a regular local Noetherian ring `R` of `spanFinrank 𝔪 = k + 1 ≥ 1` and
`x ∈ 𝔪 \ 𝔪²`, the ideal `Ideal.span {x}` is *not* a minimal prime of `R`.
This is the substantive remaining content of Stacks 00NQ after the iter-190
case-split scaffold isolated the obstruction to this single case.

**Statement framing.** The lemma takes the strong-induction hypothesis
`hIH` as an explicit argument (universally quantified over the ring `R'` at
dimension `k`), so it can be invoked inside `isDomain_of_regularLocal`'s
`succ` arm without requiring `IsDomain R` (which is the goal we are
proving). Concretely `hIH` provides `IsDomain (R / (x))` since the quotient
is regular local of `spanFinrank = k` (via
`regularLocal_quotient_isRegularLocal_of_notMemSq`).

**Proof routes (iter-192+ targets).** Three project-side routes have been
considered, all blocked on substrate work beyond Mathlib `b80f227`:
* (i) **Graded-ring approach** (the Stacks 00NQ proof). Build the associated
  graded ring `gr_𝔪 R := ⨁_n 𝔪^n / 𝔪^{n+1}`; prove the surjection
  `κ[X_1,…,X_{k+1}] ↠ gr_𝔪 R` (from a regular system of parameters) is an
  isomorphism (via Hilbert-Samuel function or cotangent count); deduce
  `gr_𝔪 R` is a domain; conclude `R` is a domain via leading-term
  multiplicativity + Krull intersection. ~500–800 LOC.
* (ii) **Cohen-completion bridge.** Pass to `R̂` at `𝔪`, which is regular
  local of same dimension. By the Cohen structure theorem,
  `R̂ ≅ κ̂[[T_1,…,T_{k+1}]]` is a power-series ring over a complete field,
  hence a domain. By flatness of `R → R̂`, the injection `R ↪ R̂` shows `R`
  is a domain. ~400–600 LOC (Cohen structure thm is the big substrate
  cost).
* (iii) **Direct prime-avoidance + Krull-intersection contradiction.** From
  the zero-divisor witness `y ≠ 0, x * y = 0` (via
  `exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`) and Krull intersection
  `⋂_n (x)^n = ⊥`, write `y = x^m * z` with `z ∉ (x)` and `m < ∞`. Then
  `x^{m+1} * z = 0` and, since `R/(x)` is a domain by IH, `z` represents a
  non-zero-divisor in `R/(x)`. The remaining substantive step is a
  "pull-back" / lifting argument showing `x` must be regular on `R`,
  contradicting the zero-divisor witness. Estimated ~200–300 LOC modulo
  Mathlib's regular-sequence-via-localization-and-completion infrastructure.

iter-191 Lane G lands the *structural extraction* of this lemma: the typed
sorry is now narrow and well-typed, with all dependent instances in scope,
ready for a future iter's substrate work. The HARD BAR iter-191 outcome —
`exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes` axiom-clean — is the
*first* helper unlocking route (iii). -/
private lemma notMem_minimalPrimes_of_regularLocal_succ
    (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] {k : ℕ}
    (hdim : (IsLocalRing.maximalIdeal R).spanFinrank = k + 1)
    (x : R) (hxMem : x ∈ IsLocalRing.maximalIdeal R)
    (hxNotSq : x ∉ (IsLocalRing.maximalIdeal R) ^ 2)
    (hIH : ∀ (R' : Type u) [CommRing R'] [IsLocalRing R'] [IsNoetherianRing R']
            [IsRegularLocalRing R'],
            (IsLocalRing.maximalIdeal R').spanFinrank = k → IsDomain R') :
    Ideal.span ({x} : Set R) ∉ minimalPrimes R := by
  intro hmin
  -- Step 1: x is a zero-divisor in R via the axiom-clean Helper A.
  have hxIn : x ∈ Ideal.span ({x} : Set R) :=
    Ideal.subset_span (Set.mem_singleton x)
  obtain ⟨y, hy_ne, hxy⟩ :=
    exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes hmin hxIn
  -- Step 2: bring `R/(x)` into scope as a regular local ring of `spanFinrank = k`,
  -- and apply IH to obtain `IsDomain (R/(x))`. This packages the substrate that
  -- routes (i)/(ii)/(iii) all need to close the residual.
  obtain ⟨hNT, hLR, hRLR, hdim_quot⟩ :=
    regularLocal_quotient_isRegularLocal_of_notMemSq hdim x hxMem hxNotSq
  haveI : Nontrivial (R ⧸ Ideal.span ({x} : Set R)) := hNT
  haveI : IsLocalRing (R ⧸ Ideal.span ({x} : Set R)) := hLR
  haveI : IsRegularLocalRing (R ⧸ Ideal.span ({x} : Set R)) := hRLR
  haveI hDomain_quot : IsDomain (R ⧸ Ideal.span ({x} : Set R)) :=
    hIH (R ⧸ Ideal.span ({x} : Set R)) hdim_quot
  -- iter-192 Lane G closure (prime-avoidance route).
  --
  -- Strategy: use the IH-as-universal-quantifier-over-rings hypothesis to
  -- prove `IsDomain R` directly, then derive contradiction from `(x) ∈
  -- minimalPrimes R` + `x ∉ 𝔪²`.
  --
  -- Concretely: pick a *fresh* witness `x' ∈ 𝔪 \ (𝔪² ∪ ⋃ minimalPrimes R)`
  -- via prime avoidance (`Ideal.subset_union_prime_finite`).  Then:
  --   * `R/(x')` is regular local of `spanFinrank = k` via the iter-190
  --     helper `regularLocal_quotient_isRegularLocal_of_notMemSq`,
  --   * `IsDomain (R/(x'))` via `hIH`,
  --   * `(x')` is prime,
  --   * a minimal prime `𝔭' ⊆ (x')` exists (`Ideal.exists_minimalPrimes_le`),
  --     and `x' ∉ 𝔭'` (since `x'` avoids all minimal primes), so for `y ∈ 𝔭'
  --     ⊆ (x')` we get `y = x' · z` with `z ∈ 𝔭'`, hence `𝔭' ⊆ x' · 𝔭' ⊆
  --     jacobson R · 𝔭'`,
  --   * Nakayama yields `𝔭' = ⊥`, so `⊥ ∈ minimalPrimes R` is prime, hence
  --     `IsDomain R`.
  -- In a domain, `(⊥ : Ideal R).minimalPrimes = {⊥}`, so `hmin` forces
  -- `Ideal.span {x} = ⊥`, hence `x = 0 ∈ 𝔪²`, contradicting `hxNotSq`.
  classical
  set 𝔪 : Ideal R := IsLocalRing.maximalIdeal R with h𝔪_def
  -- spanFinrank-positivity follows from hdim.
  have hpos : 0 < 𝔪.spanFinrank := by rw [h𝔪_def, hdim]; omega
  -- Step P1: enumerate the avoidance set `S = {𝔪²} ∪ minimalPrimes R`.
  have hMP_fin : (minimalPrimes R).Finite := minimalPrimes.finite_of_isNoetherianRing R
  let S : Set (Ideal R) := insert (𝔪 ^ 2) (minimalPrimes R)
  have hS_fin : S.Finite := hMP_fin.insert _
  -- Step P2: each element of S other than `𝔪²` is prime.
  have hp : ∀ i ∈ S, i ≠ (𝔪 ^ 2) → i ≠ (𝔪 ^ 2) → i.IsPrime := by
    intro i hi h₁ _
    simp only [S, Set.mem_insert_iff] at hi
    rcases hi with hi | hi
    · exact absurd hi h₁
    · exact Ideal.minimalPrimes_isPrime hi
  -- Step P3: `𝔪` is not contained in any element of `S`.
  have h_nle : ∀ i ∈ S, ¬ ((𝔪 : Set R) ⊆ (i : Set R)) := by
    intro i hi habs
    simp only [S, Set.mem_insert_iff] at hi
    rcases hi with rfl | hi
    · -- 𝔪 ⊆ 𝔪² contradicts hpos via `exists_notMemSq_of_spanFinrank_pos`.
      obtain ⟨x₀, hx₀Mem, hx₀NotSq⟩ := exists_notMemSq_of_spanFinrank_pos hpos
      exact hx₀NotSq (habs hx₀Mem)
    · -- i ∈ minimalPrimes R, 𝔪 ⊆ i ⟹ i = 𝔪 (since i ⊆ 𝔪 always), then 𝔪
      -- is a minimal prime ⟹ primeHeight 𝔪 = 0 ⟹ ringKrullDim R = 0,
      -- contradicting `IsRegularLocalRing.spanFinrank_maximalIdeal` + hdim.
      haveI hi_prime : i.IsPrime := Ideal.minimalPrimes_isPrime hi
      have hi_eq : i = 𝔪 := by
        apply le_antisymm
        · exact IsLocalRing.le_maximalIdeal hi_prime.ne_top
        · exact habs
      have h_min : 𝔪 ∈ minimalPrimes R := hi_eq ▸ hi
      have h_ph_zero : 𝔪.primeHeight = 0 := Ideal.primeHeight_eq_zero_iff.mpr h_min
      have h_ph_dim : 𝔪.primeHeight = ringKrullDim R :=
        IsLocalRing.maximalIdeal_primeHeight_eq_ringKrullDim
      have h_dim_zero : (ringKrullDim R : WithBot ℕ∞) = 0 :=
        h_ph_dim ▸ (h_ph_zero ▸ rfl)
      have h_dim_eq : (𝔪.spanFinrank : WithBot ℕ∞) = ringKrullDim R := by
        have := IsRegularLocalRing.spanFinrank_maximalIdeal (R := R)
        exact_mod_cast this
      have h_span_zero : 𝔪.spanFinrank = 0 := by
        have h := h_dim_eq.trans h_dim_zero
        exact_mod_cast h
      omega
  -- Step P4: apply prime avoidance to deduce `𝔪 ⊄ ⋃ S`.
  have h_not_subset : ¬ ((𝔪 : Set R) ⊆ ⋃ i ∈ S, (i : Set R)) := by
    intro habs
    obtain ⟨i, hi_S, hi_le⟩ :=
      (Ideal.subset_union_prime_finite (f := id) hS_fin (𝔪 ^ 2) (𝔪 ^ 2) hp).mp habs
    exact h_nle i hi_S hi_le
  -- Step P5: extract `x' ∈ 𝔪 \ ⋃ S`.
  obtain ⟨x', hx'Mem, hx'NotIn⟩ := Set.not_subset.mp h_not_subset
  have hx'NotSq : x' ∉ 𝔪 ^ 2 := by
    intro h
    refine hx'NotIn ?_
    exact Set.mem_biUnion (Set.mem_insert _ _) h
  have hx'NotMinPrime : ∀ 𝔭 ∈ minimalPrimes R, x' ∉ 𝔭 := by
    intro 𝔭 h𝔭 hx𝔭
    refine hx'NotIn ?_
    exact Set.mem_biUnion (Set.mem_insert_of_mem _ h𝔭) hx𝔭
  -- Step P6: `R/(x')` is regular local of `spanFinrank = k`, hence a domain
  -- by `hIH`. Then `(x')` is prime.
  obtain ⟨hNT', hLR', hRLR', hdim_quot'⟩ :=
    regularLocal_quotient_isRegularLocal_of_notMemSq hdim x' hx'Mem hx'NotSq
  haveI : Nontrivial (R ⧸ Ideal.span ({x'} : Set R)) := hNT'
  haveI : IsLocalRing (R ⧸ Ideal.span ({x'} : Set R)) := hLR'
  haveI : IsRegularLocalRing (R ⧸ Ideal.span ({x'} : Set R)) := hRLR'
  haveI hDomain_quot' : IsDomain (R ⧸ Ideal.span ({x'} : Set R)) :=
    hIH (R ⧸ Ideal.span ({x'} : Set R)) hdim_quot'
  haveI hPrime_x' : (Ideal.span ({x'} : Set R)).IsPrime :=
    (Ideal.Quotient.isDomain_iff_prime _).mp hDomain_quot'
  -- Step P7: pick a minimal prime `𝔭' ⊆ (x')`; since `x'` avoids minimal
  -- primes, `x' ∉ 𝔭'`.
  obtain ⟨𝔭', h𝔭'_min, h𝔭'_le⟩ := Ideal.exists_minimalPrimes_le
    (I := (⊥ : Ideal R)) (J := Ideal.span ({x'} : Set R)) bot_le
  haveI h𝔭'_prime : 𝔭'.IsPrime := Ideal.minimalPrimes_isPrime h𝔭'_min
  have hx'_notIn_𝔭' : x' ∉ 𝔭' := hx'NotMinPrime _ h𝔭'_min
  -- Step P8: `𝔭' ⊆ jacobson R · 𝔭'` via the standard `y = x' · z` step.
  have h𝔭'_sub_smul :
      (𝔭' : Submodule R R) ≤ Ring.jacobson R • (𝔭' : Submodule R R) := by
    intro y hy
    have hy_in_x' : y ∈ Ideal.span ({x'} : Set R) := h𝔭'_le hy
    rw [Ideal.mem_span_singleton] at hy_in_x'
    obtain ⟨z, rfl⟩ := hy_in_x'
    have hz_in : z ∈ 𝔭' := by
      rcases h𝔭'_prime.mem_or_mem hy with hx'_in | hz_in
      · exact absurd hx'_in hx'_notIn_𝔭'
      · exact hz_in
    have hx'Jac : x' ∈ Ring.jacobson R := by
      rw [IsLocalRing.ringJacobson_eq_maximalIdeal]
      exact hx'Mem
    have hsmul := Submodule.smul_mem_smul (I := Ring.jacobson R)
      (N := (𝔭' : Submodule R R)) hx'Jac hz_in
    simpa [smul_eq_mul] using hsmul
  -- Step P9: by Nakayama `𝔭' = ⊥`, hence `⊥` is prime, hence `IsDomain R`.
  have h𝔭'_fg : (𝔭' : Submodule R R).FG := Ideal.fg_of_isNoetherianRing _
  have h𝔭'_bot_sub : (𝔭' : Submodule R R) = ⊥ :=
    Submodule.FG.eq_bot_of_le_jacobson_smul h𝔭'_fg h𝔭'_sub_smul
  have h𝔭'_bot : 𝔭' = (⊥ : Ideal R) := by
    ext z
    constructor
    · intro hz
      exact h𝔭'_bot_sub.le hz
    · rintro (rfl : z = 0)
      exact 𝔭'.zero_mem
  haveI h_bot_prime : (⊥ : Ideal R).IsPrime := h𝔭'_bot ▸ h𝔭'_prime
  haveI hDomain_R : IsDomain R := IsDomain.of_bot_isPrime R
  -- Step P10: in a domain, `(⊥ : Ideal R).minimalPrimes = {⊥}`, so `hmin`
  -- forces `Ideal.span {x} = ⊥`, hence `x = 0`, contradicting `hxNotSq`.
  have h_minP_singleton : minimalPrimes R = {(⊥ : Ideal R)} := by
    change (⊥ : Ideal R).minimalPrimes = _
    exact Ideal.minimalPrimes_eq_subsingleton_self
  have hx_min_eq_bot : Ideal.span ({x} : Set R) = (⊥ : Ideal R) := by
    rw [h_minP_singleton] at hmin
    exact hmin
  have hx_eq_zero : x = 0 := by
    have hx_in_bot : x ∈ (⊥ : Ideal R) := by
      rw [← hx_min_eq_bot]
      exact Ideal.subset_span (Set.mem_singleton x)
    exact (Submodule.mem_bot _).mp hx_in_bot
  apply hxNotSq
  rw [hx_eq_zero]
  exact zero_mem _

/-- **Stacks 00NQ — regular local Noetherian ring is a domain.** Every regular
local Noetherian ring is an integral domain.

This is the consumer-facing implication needed to close
`exists_isRegular_of_regularLocal` (and through it `CohenMacaulay.of_regular`).

**iter-190 Lane G project-side build.** Per progress-critic CONVERGING-with-
escalation advisory, we commit to Option (a) project-side proof. The body
is structured as a strong induction on `spanFinrank 𝔪 R` with two named
axiom-clean helpers:

* Base case `n = 0` → `isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero`
  (𝔪 collapses to `⊥`, R is a field, hence a domain).
* Inductive prep `n = k + 1` → `regularLocal_quotient_isRegularLocal_of_notMemSq`
  (picks `x ∈ 𝔪 \ 𝔪²` via `exists_notMemSq_of_spanFinrank_pos`, then R/(x)
  is regular local of `spanFinrank = k`, axiom-clean via cotangent dim-drop
  + Krull-height bound).

**iter-191 Lane G:** The inductive step is now fully structural:
* `x ∉ 𝔭` branch closes axiom-clean via `𝔭 ⊆ x·𝔭` + Nakayama.
* `x ∈ 𝔭` branch reduces to `Ideal.span {x} ∈ minimalPrimes R` being
  impossible, packaged in the typed-sorry helper
  `notMem_minimalPrimes_of_regularLocal_succ` (the structurally-narrow
  Stacks 00NQ remnant; iter-192+ scaffolds via route (i)/(ii)/(iii)).

Once `notMem_minimalPrimes_of_regularLocal_succ` is closed, this entire
`isDomain_of_regularLocal` body is axiom-clean. -/
private lemma isDomain_of_regularLocal
    (R : Type u) [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] : IsDomain R := by
  -- Strong induction on `spanFinrank 𝔪`, generalising `R` so the IH applies
  -- to the quotient `R/(x)` at smaller dim.
  suffices haux : ∀ (n : ℕ) (R : Type u) [CommRing R] [IsLocalRing R]
      [IsNoetherianRing R] [IsRegularLocalRing R],
      (IsLocalRing.maximalIdeal R).spanFinrank = n → IsDomain R by
    exact haux _ R rfl
  intro n
  induction n with
  | zero =>
    intros R _ _ _ _ hdim
    exact isDomain_of_isLocalRing_of_spanFinrank_maximalIdeal_eq_zero hdim
  | succ k ih =>
    intros R _ _ _ _ hdim
    -- Step 1: pick `x ∈ 𝔪 \ 𝔪²` via Nakayama.
    have hpos : 0 < (IsLocalRing.maximalIdeal R).spanFinrank := by omega
    obtain ⟨x, hxMem, hxNotSq⟩ := exists_notMemSq_of_spanFinrank_pos hpos
    -- Step 2: instances + IsRegularLocalRing on R/(x) via the axiom-clean helper.
    obtain ⟨hNT, hLR, hRLR, hdim_quot⟩ :=
      regularLocal_quotient_isRegularLocal_of_notMemSq hdim x hxMem hxNotSq
    -- Step 3: IH on R/(x) at spanFinrank = k.
    have hDomain_R' : IsDomain (R ⧸ Ideal.span ({x} : Set R)) :=
      ih (R ⧸ Ideal.span ({x} : Set R)) hdim_quot
    -- Step 4: (x) is prime in R (R/(x) is a domain).
    haveI hPrime_x : (Ideal.span ({x} : Set R)).IsPrime :=
      (Ideal.Quotient.isDomain_iff_prime _).mp hDomain_R'
    -- Step 5: pick minimal prime 𝔭 ≤ (x).
    obtain ⟨𝔭, h𝔭_min, h𝔭_le⟩ := Ideal.exists_minimalPrimes_le
      (I := (⊥ : Ideal R)) (J := Ideal.span ({x} : Set R)) bot_le
    haveI h𝔭_prime : 𝔭.IsPrime := Ideal.minimalPrimes_isPrime h𝔭_min
    -- Step 6: case split on x ∈ 𝔭 vs x ∉ 𝔭.
    by_cases hxIn : x ∈ 𝔭
    · -- Case `x ∈ 𝔭`: then `𝔭 = (x)` is a minimal prime of `R`. By Helper C
      -- (`notMem_minimalPrimes_of_regularLocal_succ`), this is impossible
      -- — the substantive Stacks 00NQ remnant is now packaged in that
      -- helper, with its narrow typed sorry the only remaining gap.
      have h𝔭_eq : 𝔭 = Ideal.span ({x} : Set R) := by
        apply le_antisymm h𝔭_le
        rw [Ideal.span_le, Set.singleton_subset_iff]
        exact hxIn
      have hmin : Ideal.span ({x} : Set R) ∈ minimalPrimes R := h𝔭_eq ▸ h𝔭_min
      exact absurd hmin
        (notMem_minimalPrimes_of_regularLocal_succ R hdim x hxMem hxNotSq
          (fun R' _ _ _ _ h => ih R' h))
    · -- Case `x ∉ 𝔭`: `𝔭 ⊆ 𝔪·𝔭` by the `y = x·z, z ∈ 𝔭` argument; Nakayama
      -- (`Submodule.FG.eq_bot_of_le_jacobson_smul`) gives `𝔭 = ⊥`, so `(0)`
      -- is a prime ideal of `R`, hence `IsDomain R`.
      have h𝔭_sub_smul : (𝔭 : Submodule R R) ≤
          Ring.jacobson R • (𝔭 : Submodule R R) := by
        intro y hy
        -- y ∈ 𝔭 ≤ (x), so x | y, so y = x*z for some z.
        have hy_in_x : y ∈ Ideal.span ({x} : Set R) := h𝔭_le hy
        rw [Ideal.mem_span_singleton] at hy_in_x
        obtain ⟨z, rfl⟩ := hy_in_x
        -- Goal: x * z ∈ jacobson R • 𝔭. We have y = x * z ∈ 𝔭 prime, x ∉ 𝔭,
        -- so z ∈ 𝔭.
        have hz_in : z ∈ 𝔭 := by
          rcases h𝔭_prime.mem_or_mem hy with hx_in | hz_in
          · exact absurd hx_in hxIn
          · exact hz_in
        have hxJac : x ∈ Ring.jacobson R := by
          rw [IsLocalRing.ringJacobson_eq_maximalIdeal]
          exact hxMem
        have hsmul := Submodule.smul_mem_smul (I := Ring.jacobson R)
          (N := (𝔭 : Submodule R R)) hxJac hz_in
        -- hsmul : x • z ∈ jacobson R • 𝔭. Goal: x * z ∈ jacobson R • 𝔭.
        -- These are equal since x • z = x * z (smul = mul for R-module R).
        simpa [smul_eq_mul] using hsmul
      have h𝔭_fg : (𝔭 : Submodule R R).FG := Ideal.fg_of_isNoetherianRing _
      have h𝔭_bot_sub : (𝔭 : Submodule R R) = ⊥ :=
        Submodule.FG.eq_bot_of_le_jacobson_smul h𝔭_fg h𝔭_sub_smul
      have h𝔭_bot : 𝔭 = (⊥ : Ideal R) := by
        ext y
        constructor
        · intro hy
          have hy' : y ∈ (⊥ : Submodule R R) := h𝔭_bot_sub.le hy
          exact hy'
        · rintro (rfl : y = 0)
          exact 𝔭.zero_mem
      haveI h_bot_prime : (⊥ : Ideal R).IsPrime := h𝔭_bot ▸ h𝔭_prime
      exact IsDomain.of_bot_isPrime R

/-- **Refactored substrate witness.**
For a regular local ring `(R, 𝔪)` of Krull dimension `k + 1`, there exists
`x ∈ 𝔪 \ 𝔪²` that is additionally an `R`-regular element.

iter-189 Lane G2: closed **axiom-clean modulo `isDomain_of_regularLocal`**
(Stacks 00NQ). The Nakayama witness is axiom-clean via
`exists_notMemSq_of_spanFinrank_pos`; the `IsSMulRegular` upgrade uses that
in a domain every nonzero element is a non-zero-divisor
(`IsSMulRegular.of_ne_zero`, requires `Module.IsTorsionFree R R` which is
automatic for `IsDomain R`). -/
private lemma exists_isSMulRegular_notMemSq_of_regularLocal_succ
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] {k : ℕ}
    (hdim : (IsLocalRing.maximalIdeal R).spanFinrank = k + 1) :
    ∃ x : R, x ∈ IsLocalRing.maximalIdeal R ∧
      x ∉ (IsLocalRing.maximalIdeal R) ^ 2 ∧ IsSMulRegular R x := by
  have hpos : 0 < (IsLocalRing.maximalIdeal R).spanFinrank := by omega
  obtain ⟨x, hxMem, hxNotSq⟩ := exists_notMemSq_of_spanFinrank_pos hpos
  have hx_ne_zero : x ≠ 0 := by
    intro hx0
    apply hxNotSq
    rw [hx0]; exact Submodule.zero_mem _
  haveI : IsDomain R := isDomain_of_regularLocal R
  haveI : Module.IsTorsionFree R R := inferInstance
  exact ⟨x, hxMem, hxNotSq, IsSMulRegular.of_ne_zero hx_ne_zero⟩

/-- **Stacks 00OD inductive substrate.**
For a regular local ring `(R, 𝔪)` of Krull dimension `k + 1`, there exists
`x ∈ 𝔪` that is `R`-regular (a non-zero-divisor on `R`) such that the quotient
`R ⧸ Ideal.span {x}` is again a regular local ring of Krull dimension `k`
(equivalently: its maximal ideal has `spanFinrank = k`).

iter-189 Lane G2: closed **axiom-clean modulo** the single narrower substrate
helper `exists_isSMulRegular_notMemSq_of_regularLocal_succ` (Stacks 00NQ).

Assembly path (after the helper provides `x ∈ 𝔪 \ 𝔪²` that is `R`-regular):
1. Build `[Nontrivial (R/(x))]`, `[IsLocalRing (R/(x))]`,
   `[IsNoetherianRing (R/(x))]` instances from `Ideal.span_singleton_ne_top`
   (since `x ∈ 𝔪` is a nonunit) + `IsLocalRing.of_surjective'` of the
   quotient map + `Ideal.Quotient.isNoetherianRing` automatic.
2. Cotangent dim-drop via `finrank_cotangentSpace_quot_span_singleton_succ`
   (iter-188 Lane G1 closure):
   `finrank κ' (CotangentSpace (R/(x))) + 1 = finrank κ (CotangentSpace R)`.
3. Translate κ-finrank to spanFinrank via
   `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace` (Mathlib);
   combine with `hdim : spanFinrank 𝔪 R = k+1` to get
   `spanFinrank 𝔪 (R/(x)) = k`.
4. Krull dim drop via
   `ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim`: since `x` is
   `R`-regular and `x ∈ 𝔪`,
   `ringKrullDim (R/(x)) + 1 = ringKrullDim R`. By `IsRegularLocalRing`'s
   defining equation `ringKrullDim R = spanFinrank 𝔪 R = k+1`, so
   `ringKrullDim (R/(x)) = k`.
5. Conclude `IsRegularLocalRing (R/(x))` via
   `IsRegularLocalRing.of_spanFinrank_maximalIdeal_le` (the inequality
   becomes the equation `spanFinrank = k = ringKrullDim`). -/
private lemma exists_isSMulRegular_quotient_isRegularLocal_succ
    {R : Type u} [CommRing R] [IsLocalRing R] [IsNoetherianRing R]
    [IsRegularLocalRing R] {k : ℕ}
    (hdim : (IsLocalRing.maximalIdeal R).spanFinrank = k + 1) :
    ∃ (x : R), x ∈ IsLocalRing.maximalIdeal R ∧ IsSMulRegular R x ∧
      ∃ _ : IsRegularLocalRing (R ⧸ Ideal.span {x}),
        (IsLocalRing.maximalIdeal (R ⧸ Ideal.span {x})).spanFinrank = k := by
  -- Step 1: extract `x ∈ 𝔪 \ 𝔪²` that is `R`-regular from the Stacks 00NQ helper.
  obtain ⟨x, hxMem, hxNotSq, hxReg⟩ :=
    exists_isSMulRegular_notMemSq_of_regularLocal_succ (k := k) hdim
  refine ⟨x, hxMem, hxReg, ?_⟩
  -- Step 2: assemble the structural instances on `R/(x)`.
  have hxNonunit : ¬ IsUnit x := fun hu =>
    (IsLocalRing.notMem_maximalIdeal.mpr hu) hxMem
  have hspan_ne_top : (Ideal.span ({x} : Set R)) ≠ ⊤ :=
    Ideal.span_singleton_ne_top hxNonunit
  haveI : Nontrivial (R ⧸ Ideal.span ({x} : Set R)) :=
    Ideal.Quotient.nontrivial_iff.mpr hspan_ne_top
  haveI : IsLocalRing (R ⧸ Ideal.span ({x} : Set R)) :=
    IsLocalRing.of_surjective' (Ideal.Quotient.mk _) Ideal.Quotient.mk_surjective
  -- IsNoetherianRing (R ⧸ I) is automatic via `Ideal.Quotient.isNoetherianRing`.
  -- Step 3: cotangent dim-drop via Lane G1 helper.
  have hcot := finrank_cotangentSpace_quot_span_singleton_succ x hxMem hxNotSq
  -- Step 4: translate κ-finrank to spanFinrank on both R and R/(x).
  have hR_cot_eq :
      Module.finrank (IsLocalRing.ResidueField R) (IsLocalRing.CotangentSpace R) = k + 1 := by
    rw [← IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace R]
    exact hdim
  have hR'_cot_eq :
      Module.finrank (IsLocalRing.ResidueField (R ⧸ Ideal.span ({x} : Set R)))
          (IsLocalRing.CotangentSpace (R ⧸ Ideal.span ({x} : Set R))) = k := by
    -- from `hcot : LHS + 1 = RHS` and `hR_cot_eq : RHS = k + 1` we get `LHS = k`.
    have h := hcot
    rw [hR_cot_eq] at h
    omega
  have hspan_R'_eq_k :
      (IsLocalRing.maximalIdeal (R ⧸ Ideal.span ({x} : Set R))).spanFinrank = k := by
    rw [IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace
        (R ⧸ Ideal.span ({x} : Set R))]
    exact hR'_cot_eq
  -- Step 5: Krull dim drop on R/(x).  `ringKrullDim (R/(x)) + 1 = ringKrullDim R`.
  have hKrullDimDrop : ringKrullDim (R ⧸ Ideal.span ({x} : Set R)) + 1 = ringKrullDim R :=
    ringKrullDim_quotient_span_singleton_succ_eq_ringKrullDim hxReg hxMem
  -- `ringKrullDim R = (k+1 : ℕ)` by `IsRegularLocalRing`'s defining equation.
  have hR_dim : ringKrullDim R = ((k + 1 : ℕ) : WithBot ℕ∞) := by
    have h := IsRegularLocalRing.spanFinrank_maximalIdeal (R := R)
    rw [hdim] at h
    -- h : ((k+1 : ℕ) : WithBot ℕ∞) = ringKrullDim R (after coercion through ℕ∞)
    exact_mod_cast h.symm
  -- Solve `ringKrullDim (R/(x)) = (k : ℕ)` from the additive equation.
  have hR'_dim : ringKrullDim (R ⧸ Ideal.span ({x} : Set R)) = ((k : ℕ) : WithBot ℕ∞) := by
    rw [hR_dim] at hKrullDimDrop
    -- hKrullDimDrop : ringKrullDim (R/(x)) + 1 = ((k+1 : ℕ) : WithBot ℕ∞).
    -- Use `WithBot.add_eq_coe` to extract finite witnesses `a', b' : ℕ∞`, then
    -- cancel `+ 1` in `ℕ∞` via `WithTop.add_right_cancel` (since `1 ≠ ⊤`).
    obtain ⟨a', b', ha', hb', hab⟩ := WithBot.add_eq_coe.mp hKrullDimDrop
    rw [← ha']
    have hb_eq : b' = (1 : ℕ∞) := by
      have h1 : ((b' : ℕ∞) : WithBot ℕ∞) = ((1 : ℕ∞) : WithBot ℕ∞) := by
        rw [hb']; simp
      exact_mod_cast h1
    have ha_eq : a' = (k : ℕ∞) := by
      rw [hb_eq] at hab
      have hcast2 : a' + 1 = (k : ℕ∞) + 1 := by exact_mod_cast hab
      have hne_top : (1 : ℕ∞) ≠ ⊤ := by simp
      exact WithTop.add_right_cancel hne_top hcast2
    exact_mod_cast ha_eq
  -- Step 6: conclude `IsRegularLocalRing (R/(x))` via `of_spanFinrank_maximalIdeal_le`.
  have hRegLR : IsRegularLocalRing (R ⧸ Ideal.span ({x} : Set R)) :=
    IsRegularLocalRing.of_spanFinrank_maximalIdeal_le _ <| by
      rw [hspan_R'_eq_k, hR'_dim]
  exact ⟨hRegLR, hspan_R'_eq_k⟩

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
    --
    -- iter-186 Lane G: closed kernel-clean via the explicit `R⧸(x)`-linear
    -- equiv between the two quotients, then `LinearEquiv.isRegular_congr`
    -- transports `hreg_q` across.  The two `mapQ` halves use `LinearMap.id`
    -- with `heq.le` / `heq.ge`, and `map_smul'` reduces to `rfl` after
    -- `Quotient.inductionOn` on the scalar (the `R⧸(x)`-action on both sides
    -- is `[s] • [r] = [s * r]` definitionally).
    open scoped Pointwise in
    have heq : (x • (⊤ : Submodule R R)) = (Ideal.span {x} : Submodule R R) := by
      ext y
      simp [Submodule.mem_smul_pointwise_iff_exists, Ideal.mem_span_singleton,
        eq_comm, Dvd.dvd]
    let e : (R ⧸ (x • (⊤ : Submodule R R))) ≃ₗ[R ⧸ Ideal.span {x}]
        (R ⧸ Ideal.span {x}) := {
      toFun := Submodule.mapQ _ _ LinearMap.id heq.le
      invFun := Submodule.mapQ _ _ LinearMap.id heq.ge
      left_inv := by rintro ⟨r⟩; rfl
      right_inv := by rintro ⟨r⟩; rfl
      map_add' := map_add _
      map_smul' := by
        rintro q ⟨r⟩
        induction q using Quotient.inductionOn with
        | _ s => rfl
    }
    exact (LinearEquiv.isRegular_congr e.symm rs'_q).mp hreg_q

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
