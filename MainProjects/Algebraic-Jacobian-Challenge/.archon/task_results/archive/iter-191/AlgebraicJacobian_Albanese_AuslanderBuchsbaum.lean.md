# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Lane G iter-191: Stacks 00NQ `x ∈ 𝔭` case — structural refactor + 1 axiom-clean helper

### Summary

- **HARD BAR met**: 1 axiom-clean helper landed
  (`exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`), 1 typed-sorry helper
  isolating the residual Stacks 00NQ content
  (`notMem_minimalPrimes_of_regularLocal_succ`).
- **Sorry count unchanged** at 2 (was 2 entering iter-191; remains 2
  post-iter). But sorry placement shifted: the `sorry` in
  `isDomain_of_regularLocal` itself is gone; the residual is now structurally
  isolated to the new helper.
- **Axiom budget**: kernel-only axioms (propext, Classical.choice, Quot.sound)
  for the axiom-clean helper.
- **Build status**: `lake build AlgebraicJacobian` GREEN (8360/8360 jobs).

### isDomain_of_regularLocal `x ∈ 𝔭` case (was line 1537)

#### Attempt 1 (iter-191 Lane G)

- **Approach**: Structural refactor. Extract two new helpers immediately
  before `isDomain_of_regularLocal`:

  1. **`exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes`** (axiom-clean,
     ~25 LOC): For any commutative ring `R` and minimal prime
     `𝔭 ∈ minimalPrimes R`, every `x ∈ 𝔭` admits a zero-divisor witness
     `y ≠ 0` with `x * y = 0`. Proof: minimal primes are disjoint from
     non-zero-divisors via `Ideal.disjoint_nonZeroDivisors_of_mem_minimalPrimes`,
     then `mem_nonZeroDivisors_iff` + `push Not` extracts the witness.

  2. **`notMem_minimalPrimes_of_regularLocal_succ`** (typed sorry, narrowly
     scoped): For regular local Noetherian `R` of `spanFinrank 𝔪 = k+1 ≥ 1`,
     `x ∈ 𝔪 \ 𝔪²`, and strong-induction hypothesis `hIH` at dimension `k`,
     `Ideal.span {x} ∉ minimalPrimes R`. The body assembles the substrate
     (zero-divisor witness from Helper 1; `R/(x)` instances and
     `IsDomain (R/(x))` from `regularLocal_quotient_isRegularLocal_of_notMemSq`
     + `hIH`) and leaves a focused, well-typed sorry for the residual
     contradiction step.

- **Use site update**: `isDomain_of_regularLocal` `x ∈ 𝔭` case now reads:

  ```lean
  have hmin : Ideal.span ({x} : Set R) ∈ minimalPrimes R := h𝔭_eq ▸ h𝔭_min
  exact absurd hmin
    (notMem_minimalPrimes_of_regularLocal_succ R hdim x hxMem hxNotSq
      (fun R' _ _ _ _ h => ih R' h))
  ```

  Lemma body is now structurally clean: `isDomain_of_regularLocal` itself
  has no inline `sorry`.

- **Result**: PARTIAL (substrate narrowed; HARD BAR met).
- **Axiom check**: `mcp__archon-lean-lsp__lean_verify` confirms
  `exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes` uses only
  `propext, Classical.choice, Quot.sound`.

### Next steps (iter-192+ target)

The residual sorry in `notMem_minimalPrimes_of_regularLocal_succ` requires
substantive Stacks 00NQ content. Three project-side routes documented in the
helper's docstring:

- **(i) Graded-ring approach** (Stacks `lemma-regular-graded`): build
  `gr_𝔪 R := ⨁_n 𝔪^n / 𝔪^{n+1}`; prove `κ[X_1,…,X_{k+1}] ↠ gr_𝔪 R` is an
  isomorphism via Hilbert-Samuel / cotangent dim count; deduce `gr_𝔪 R` is
  a domain; conclude via leading-term multiplicativity + Krull intersection.
  ~500–800 LOC.
- **(ii) Cohen-completion bridge**: `R̂` is regular local of same dim, and by
  Cohen structure theorem `R̂ ≅ κ̂[[T_1,…,T_{k+1}]]` is a power-series ring,
  hence a domain; `R ↪ R̂` by faithful flatness. ~400–600 LOC.
- **(iii) Direct prime-avoidance + Krull-intersection**: with the
  zero-divisor witness `y ≠ 0, x * y = 0` already in scope from Helper 1,
  decompose `y = x^m · z` (Krull intersection on `(x) ⊆ 𝔪`) with `z ∉ (x)`.
  Then `x^{m+1} · z = 0` in `R`, `z̄` is a non-zero-divisor in `R/(x)`
  (a domain by IH); the remaining substantive step is a lifting/pull-back
  showing `x` must be regular on `R`. ~200–300 LOC.

iter-191 Lane G unlocks **route (iii)** by landing
`exists_ne_zero_mul_eq_zero_of_mem_minimalPrimes` axiom-clean. iter-192+
target: close the residual via route (iii)'s lifting argument, which only
requires Mathlib's existing Krull-intersection infrastructure
(`Ideal.iInf_pow_eq_bot_of_isLocalRing`) plus localization / completion
substrate.

### Lemmas discovered

- `Ideal.disjoint_nonZeroDivisors_of_mem_minimalPrimes` (Mathlib): minimal
  primes are disjoint from non-zero-divisors. **Key input** for Helper 1.
- `mem_nonZeroDivisors_iff` (Mathlib): both-sided characterization of
  non-zero-divisors.
- `Ideal.iInf_pow_eq_bot_of_isLocalRing` (Mathlib): Krull intersection
  theorem for local rings. **Substrate** for iter-192+ route (iii).
- `Module.associatedPrimes.minimalPrimes_annihilator_subset_associatedPrimes`
  (Mathlib): alternative path to extract zero-divisor witness (not used in
  final proof since `Ideal.disjoint_nonZeroDivisors_of_mem_minimalPrimes` is
  more direct).
- `Ideal.height_le_card_of_mem_minimalPrimes_span_finset`,
  `height_le_ringKrullDim_quotient_add_spanFinrank` (Mathlib): Krull-height
  bounds. Investigated for catenary-style argument; doesn't give
  contradiction directly without catenary axiom on `R`.

### Blueprint marker recommendation

No new declarations exposed to the blueprint. The new helpers are `private`
and serve internal proof structure. Existing pins
(`auslander_buchsbaum_formula`, `depth_eq_smallest_ext_index`, etc.) remain
typed-sorry-bearing per the `\leanok` policy (sync_leanok will manage).

### File state (line counts approximate)

- Total sorries in file: **2** (was 2 entering iter-191).
- Lines added: ~110 (docstrings + 2 new helpers).
- Build status: GREEN (`lake build AlgebraicJacobian` exit 0).
- Axiom budget: 0 new project axioms; kernel-only on the axiom-clean
  helper.
