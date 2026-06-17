# AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean — iter-198 Lane AB

## Summary

- **Declarations added (2, axiom-clean):**
  - `RingTheory.Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`
    (lines 1023-1124). Stacks `lemma-depth-drops-by-one`: for a Noetherian
    local ring `(R, 𝔪)`, a nonzero finite `R`-module `M`, and `x ∈ 𝔪` an
    `M`-regular element, the depth of `M/xM` is exactly one less than the
    depth of `M`: `depth(M/xM) + 1 = depth(M)`. Proof routes through
    `depth_eq_smallest_ext_index` on both sides plus the LES of
    `Ext^*(κ, -)` on `0 → M →[x] M → M/xM → 0`, using that `[x]_*` is zero
    on every `Ext^*(κ, M)` (since `x ∈ Ann κ`) to break the LES into
    short-exact pieces. The two-direction bridge via
    `ENat.forall_natCast_le_iff_le` converts the natural-number indexed
    Ext characterization to the `ℕ∞` depth equality.
  - `RingTheory.Module.exists_isSMulRegular_of_one_le_depth` (lines
    1138-1166). Companion lemma: `1 ≤ depth_𝔪(M)` implies the existence of
    an `M`-regular `x ∈ 𝔪`. Proof unfolds `depth` to the regular-sequence
    supremum (Nakayama rules out the trivial-quotient branch under
    `Nontrivial M`) and reads off the first element of a length-≥1 witness.
- **Sorry count:** unchanged at 1. The single remaining sorry is at
  `auslander_buchsbaum_formula_succ_pd` (L1299), updated comment to reflect
  that gap (4) `depth-drops-by-one` is now CLOSED.
- **Total sorries before → after across file:** 1 → 1 (net zero; two new
  axiom-clean substrate pieces added, the AB succ_pd substrate gap (4) is
  retired but gaps (1)-(3) remain).

## `depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`

- **Approach:** Convert both depths to Ext characterizations via
  `depth_eq_smallest_ext_index`. The LES of `Ext^*(κ, -)` on the SES
  `0 → M →[x] M → M/xM → 0` plus the fact that `[x]_*` is zero on
  `Ext^*(κ, M)` (via the existing `ext_smul_eq_zero_of_mem_annihilator`
  helper + `x ∈ Ann κ`) gives a short-exact decomposition
  `0 → Ext^i(κ, M) → Ext^i(κ, M/xM) → Ext^{i+1}(κ, M) → 0` for each `i`.
  This translates to the equivalence
  `(n+1 : ℕ∞) ≤ depth M ↔ (n : ℕ∞) ≤ depth(M/xM)`. The `ℕ∞` equality is
  recovered via `le_antisymm` using `ENat.forall_natCast_le_iff_le` on
  each direction.
- **Pieces used:** `covariant_sequence_exact₁`, `covariant_sequence_exact₃`,
  `postcomp_mk₀_injective_of_mono`, `IsSMulRegular.smulShortComplex_shortExact`,
  `ModuleCat.smulShortComplex`, `nontrivial_quotSMulTop_of_mem_maximalIdeal`,
  `Ideal.annihilator_quotient`, the file-local
  `ext_smul_eq_zero_of_mem_annihilator` helper, and the file-local
  `depth_eq_smallest_ext_index` theorem.
- **Result:** RESOLVED — axiom-clean (`{propext, Classical.choice, Quot.sound}`).

## `exists_isSMulRegular_of_one_le_depth`

- **Approach:** Unfold `depth` via the `if_neg` branch (since
  `𝔪 • ⊤ ≠ ⊤` by Nakayama under `Nontrivial M`), use `lt_sSup_iff` to
  extract a regular sequence of length ≥ 1, then `isRegular_cons_iff` to
  read off the head element as an `M`-regular member of `𝔪`.
- **Result:** RESOLVED — axiom-clean.

## `auslander_buchsbaum_formula_succ_pd` (L1299, NOT closed)

- **Status:** NOT ADDED to closure target. Single sorry retained at
  this declaration; docstring updated to reflect iter-198 progress.
- **Approach 1 (case-split on `depth M`):** Carving into a case split
  produces TWO sub-cases, each requiring substantive Mathlib substrate
  not present at b80f227:
  - `depth M = 0`: needs Stacks `lemma-add-trivial-complex`
    (minimal-finite-free-resolution structure) AND Stacks 00MF
    ("what is exact" criterion). Both gaps (1) and (2).
  - `depth M > 0`: needs gaps (1)+(2)+(3) for the snake-lemma step
    `pd_{R/xR}(M/xM) = pd_R(M)` and for the common-NZD existence
    (since the blueprint argues from `pd > 0 ⟹ depth R > 0` via 00MF).
    Then gap (4) (now closed by iter-198) drops both depths by 1, and the
    IH applies on `(R/xR, M/xM)`.
- **Decision:** Carving would inflate the sorry count (1 → 2+) without
  closing any new branch — VIOLATES the HARD BAR. Left structure intact.
- **iter-199+ path:** Per the updated docstring, the body becomes
  ~80-120 LOC of strong-induction-on-`depth M` assembly once gaps
  (1)-(3) land. Recommended next slice: gap (3)
  (snake-lemma-on-minimal-resolution) — depends on gap (1).
- **Dead end:** No project-side path closes this in a single iter
  without first landing gaps (1)-(3). Substrate cost ≥ 4 iters per
  iter-184/185/195 estimates.

## Blueprint update

- The blueprint chapter (`Albanese_AuslanderBuchsbaum.tex`) is
  unchanged; the new helpers do NOT correspond to chapter-pinned
  declarations (they are internal substrate). No `\leanok` to
  toggle; sync_leanok handles markers deterministically.
- The chapter NOTE at L562-574 about "FOUR core ingredients ALL
  absent" should be updated by a future plan-agent or
  blueprint-writer to reflect that gap (4) `depth-drops-by-one` is
  now closed kernel-clean in the project file. Prover does NOT touch
  the blueprint per role-permission table.

## Why I stopped

- **Real progress (2 axiom-clean declarations added):**
  - `Module.depth_quotSMulTop_succ_eq_depth_of_isSMulRegular`
    (L1023-L1124, ~100 LOC body, axiom-clean).
  - `Module.exists_isSMulRegular_of_one_le_depth` (L1138-L1166,
    ~30 LOC body, axiom-clean).
- **Partial progress on the HARD BAR target `L1131` (now L1299 after
  the new helpers shifted line numbers):** body unchanged. Closing
  the full AB succ_pd requires three additional substrate pieces
  (gaps 1-3) absent at Mathlib b80f227; each is multi-iter work per
  the chapter's L562-574 estimate.
- **Approaches written but not attempted:** none — every approach
  identified was either already attempted in prior iterations
  (gaps 1-3) or successfully closed this iteration (gap 4).
- **Informal agent:** not consulted; no API key is set in the
  environment (`env | grep -E "DEEPSEEK|MOONSHOT|OPENROUTER|OPENAI|GEMINI"`
  returns empty). The closure path was sufficiently constrained by
  the existing chapter docstring + Stacks references to not require
  an external sketch.
- **Infrastructure that exists:** none — Mathlib at b80f227 has none of
  the four substrate pieces (1)-(4); item (4) is now project-side.

## Next-step handoff for plan agent

The depth-drops-by-one + regular-element-existence substrate is now in
place. Next priority for AB succ_pd closure:

1. **Gap (3) snake-lemma-on-minimal-resolution** — preserves pd under
   tensoring by `R/(x)`. ~80-120 LOC; depends on gap (1).
2. **Gap (1) minimal-resolution carving** (Stacks
   `lemma-add-trivial-complex`) — independent, ~80-120 LOC.
3. **Gap (2) "what is exact" criterion** (Stacks 00MF) — largest gap
   (~150-200 LOC); candidate for Mathlib upstream PR.

After all three land, `auslander_buchsbaum_formula_succ_pd` closes in
~80-120 LOC of assembly using the now-axiom-clean depth-drops-by-one
helper.
