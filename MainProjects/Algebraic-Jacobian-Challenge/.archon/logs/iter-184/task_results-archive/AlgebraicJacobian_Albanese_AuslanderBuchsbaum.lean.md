# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

**Lane G — `depth_eq_smallest_ext_index` (Stacks 00LP inductive chase)**

## Headline

- 1 NEW axiom-clean helper (`ext_smul_eq_zero_of_mem_annihilator`, ~25 LOC).
- Base case `n = 0` of the main theorem closed kernel-clean.
- Inductive step `n+1` structurally decomposed: forward + backward branches
  separated; backward branch's **regular-element extraction stage** closed
  (subsingleton-from-Ext^0 → `subsingleton_linearMap_iff` → `x ∈ 𝔪` with
  `IsSMulRegular M x`).
- File-level sorry count: **3 → 3 (declarations)**; inline sorry tokens:
  **3 → 4** (the single bare `sorry` for `depth_eq_smallest_ext_index`
  became 2 structurally-located sorries inside a meaningful proof body).
- `lake build` GREEN. No new axioms.

## depth_eq_smallest_ext_index (line 268, signature unchanged)

### Attempt 1
- **Approach:** Stacks 00LP induction on `n` with `M` generalized so the
  inductive hypothesis is universally quantified over the module (lets the
  step recurse onto `M / xM = QuotSMulTop x M`).
- **Result:** PARTIAL (structural, branch closed).
- **Key insight:** Use `induction n generalizing M` to thread the
  parametric quantification through Lean's induction principle. The
  step-case IH `ih` then comes out with the right shape for recursive use.

#### Sub-progress

1. **Base case `n = 0`** (line 281, both directions) — CLOSED.
   - LHS `(0 : ℕ∞) ≤ depth M` is `bot_le`.
   - RHS `∀ i < 0, …` is `absurd hi (Nat.not_lt_zero i)`.

2. **New axiom-clean helper** `ext_smul_eq_zero_of_mem_annihilator`
   (line 229) — CLOSED.
   - Type: for any `R`-modules `N, M`, `e : Ext^i(N, M)`, and
     `x ∈ Module.annihilator R N`, we have `x • e = 0`.
   - Proof: `x • 𝟙_N = 0` in ModuleCat (since `x ∈ Ann N`), then
     `(mk₀ (x • 𝟙_N)).comp e _ = x • e` via R-linearity chain
     `mk₀_smul + smul_comp + mk₀_id_comp`, then `mk₀ 0 = 0` and
     `zero_comp` collapse.
   - `lean_verify` axioms: `propext, Classical.choice, Quot.sound`
     (kernel-only).
   - This is the precise statement of the Stacks-00LP "x annihilates
     `Ext^*(κ, ·)`" trick, generalised to arbitrary `x ∈ Ann(N)` so it
     also covers e.g. `N = R/(x_1, …, x_k)`.

3. **Inductive step `n+1`, backward direction's Step 1+2**
   (lines ~376-403) — CLOSED.
   - From `∀ i < n+1, ∀ e : Ext^i(κ, M), e = 0` (the hypothesis), specialise
     at `i = 0` to get `∀ e : Ext^0(κ, M), e = 0`.
   - For any `f g : κ →ₗ[R] M`, `mk₀ (ofHom f) = 0` (by `hext0` applied to
     `mk₀ (ofHom f)`); apply `mk₀_eq_zero_iff` to extract `ofHom f = 0`;
     apply `ModuleCat.hom_ext_iff` to get `f = 0`. Same for `g`. Conclude
     `Subsingleton (κ →ₗ[R] M)`.
   - Apply `IsSMulRegular.subsingleton_linearMap_iff` to get
     `∃ x ∈ Module.annihilator R κ, IsSMulRegular M x`.
   - Use `Ideal.annihilator_quotient` to rewrite
     `Module.annihilator R (R ⧸ maximalIdeal R) = maximalIdeal R`.
   - Conclude `x ∈ maximalIdeal R` with `IsSMulRegular M x` — packaged as
     witnesses for the next iter's IH-on-`M/xM` step.

### Residual sorries (2 named, inside the inductive step body)

1. **Forward direction** `(n+1 : ℕ∞) ≤ depth M → ∀ i ≤ n, Ext^i(κ, M) = 0`
   (line 346): the substantive supremum-extraction + LES chase. Needs:
   - Extract regular sequence of length `n+1` from
     `(n+1 : ℕ∞) ≤ sSup {seq lengths}`. The `⊤` case is impossible under
     `Nontrivial M` (Nakayama rules out `𝔪 • ⊤ = ⊤`); the finite case
     gives a sequence directly.
   - Cons-decompose via `RingTheory.Sequence.isRegular_cons_iff`:
     `IsRegular M (x :: rs') ↔ IsSMulRegular M x ∧ IsRegular (M/xM) rs'`.
   - For `i = 0`: `Hom(κ, M) = 0` from `x` annihilating Hom (`x ∈ Ann κ`,
     `x` regular on `M`, so `Hom(κ, M) = 0`). Pass to `Ext^0` via
     `addEquiv₀`/`mk₀_eq_zero_iff`.
   - For `i ≥ 1`: LES of `Ext^*(κ, ·)` on the SES from
     `IsSMulRegular.smulShortComplex_shortExact`; use the new helper
     `ext_smul_eq_zero_of_mem_annihilator` to kill the `[x]_*` maps;
     recurse via `ih` on `M/xM` (which has the shorter regular sequence).

2. **Backward direction, final assembly** (line 432): regular-element `x`,
   `Nontrivial (QuotSMulTop x M)`, and `Module.Finite R (QuotSMulTop x M)`
   are already in scope (the Finite instance is `inferInstance`-derivable).
   Needs:
   - LES chase: for `j < n`, `Ext^j(κ, M/xM) = 0` follows from
     `Ext^j(κ, M) = 0`, `Ext^{j+1}(κ, M) = 0` (both hypotheses), and the
     fact that `[x]_*` on `Ext^j(κ, M)` is zero (helper). Uses
     `Abelian.Ext.covariant_sequence_exact₁/₂/₃` similar to `depth_of_short_exact`.
   - Apply `ih` at index `n` on `MxM` to get
     `∃ rs', length rs' = n, … IsRegular MxM rs'`.
   - Cons `x :: rs'` to form a regular sequence of length `n+1` on `M`
     via `isRegular_cons_iff`.
   - Conclude `(n+1 : ℕ∞) ≤ depth M` via `le_sSup`.

- **Dead-end avoided:** I did not attempt to derive
  `Module.Finite R (QuotSMulTop x M)` as a separate helper — it is in fact
  Mathlib-automatic (`inferInstance` succeeds, verified via
  `lean_multi_attempt`).
- **Lemmas found:**
  `RingTheory.Sequence.isRegular_cons_iff`,
  `IsSMulRegular.subsingleton_linearMap_iff`,
  `Ideal.annihilator_quotient`,
  `nontrivial_quotSMulTop_of_mem_maximalIdeal`,
  `IsSMulRegular.smulShortComplex_shortExact`,
  `Abelian.Ext.mk₀_smul/smul_comp/mk₀_id_comp/mk₀_zero/zero_comp`,
  `Abelian.Ext.mk₀_eq_zero_iff`,
  `ModuleCat.hom_ext_iff`.

### Disclosure tier

- **Helper `ext_smul_eq_zero_of_mem_annihilator`**: **Tier-1 axiom-clean**
  (`lean_verify` ⇒ `propext, Classical.choice, Quot.sound` only).
- **Base case `n = 0` (within `depth_eq_smallest_ext_index`)**: kernel-clean
  in isolation.
- **Backward direction Step 1+2**: kernel-clean modulo the `sorry` on the
  final assembly.
- **Forward direction**: structural sorry only.
- The whole `depth_eq_smallest_ext_index` declaration remains a **Tier-3
  typed sorry** (proof body contains explicit `sorry`s) — its closure is
  multi-iter.

## Blueprint marker readiness

- `RingTheory.Module.depth_eq_smallest_ext_index` (lem:depth_via_ext): no
  marker change — still has `sorry` in the proof. `\leanok` should not be
  applied; the deterministic `sync_leanok` will keep it off.
- `RingTheory.Module.ext_smul_eq_zero_of_mem_annihilator`: not pinned in
  the blueprint (this is a private helper internal to the proof). No marker.

## Notes for iter-184+

The path forward is concrete:
- The backward direction is now close to closable: `ih (M := MxM)` on the
  Ext-pullback gives a regular sequence of length `n`, cons with `x` gives
  one of length `n+1`. Estimated +50-80 LOC.
- The forward direction is the heavier piece: needs to handle the supremum
  carefully (Nakayama for `⊤`, truncation for the finite case). Estimated
  +80-120 LOC.
- Both directions share the new helper `ext_smul_eq_zero_of_mem_annihilator`
  for the "x kills Ext" step — that piece is now reusable across the LES
  chase work.

## Helper budget

- **Used 1 of 2** (`ext_smul_eq_zero_of_mem_annihilator`).
- Reserved 1 slot for the iter-184 LES-pullback helper that derives
  `Ext^j(κ, M/xM) = 0` for `j < n` from `Ext^*(κ, M) = 0` + the new helper.

## Tooling note

- `private lemma h𝟙 :` fails to parse — Lean's parser treats `𝟙` as a
  reserved token in some contexts. Renamed to `hkill`. Saves the next
  prover one search.
- `Abelian.Ext.mk₀_smul` needs explicit `(R := R)` for type-class resolution
  even when `R` is in scope; `Lean` can't infer the implicit `R` from the
  `mk₀ (x • _)` pattern alone.
