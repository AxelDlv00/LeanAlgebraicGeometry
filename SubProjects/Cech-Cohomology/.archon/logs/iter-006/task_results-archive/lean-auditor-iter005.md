# Lean Audit Report

## Slug
iter005

## Iteration
005

## Scope
- files audited: 1 (per directive)
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (4 unused-section-variable warnings; no simp confluence issues)
- **excuse-comments**: none
- **notes**:
  - **Compilation / axioms**: 0 sorries, 0 errors. All verified declarations use only
    `propext`, `Classical.choice`, `Quot.sound` — confirmed via `lean_verify` on
    `twistedBiprodD_comp`, `horseshoeτ_cocycle`, `horseshoeSES_shortExact`,
    `rightDerivedShiftIsoOfSplitResolutionSES`, `mono_biprod_lift_factorThru_of_exact`,
    `horseshoeβ_comp_d`, `horseshoeτZero_hf`, `twistedBiprodSplitting`, `ofInjective`.
    No `axiom` declarations present.

  - **Non-vacuity — `twistedBiprodD_comp` (line 238)**: The cocycle hypothesis `hτ` is
    genuinely consumed at line 244 (`rw [... hτ n, add_neg_cancel, ...]`). The proof fails
    without it (the off-diagonal `τ` term would not cancel). Non-vacuous. ✓

  - **Non-vacuity — `twistPair` (lines 359–377)**: Base case uses `horseshoeτZero_hf`
    (which in turn depends on `ιC_comp_horseshoeτZero` and `horseshoeH_comp_d`) to satisfy
    the `descToInjective` precondition. Inductive step correctly threads the previous
    cocycle identity `p.2.2` into the next precondition proof. The recursion is well-founded
    by `ℕ`-recursion. Non-vacuous. ✓

  - **Non-vacuity — `rightDerivedShiftIsoOfSplitResolutionSES` (lines 153–170)**:
    `[IsRightAcyclic J]` is consumed by two calls to
    `isZero_homology_mapHomologicalComplex_of_isRightAcyclic` (lines 168–169), which provide
    the vanishing hypotheses to `δIso`. The `splits` parameter feeds
    `shortExact_map_mapHomologicalComplex_of_degreewise_splitting`. Non-vacuous. ✓

  - **Non-vacuity — `horseshoeβ_comp_d` (lines 438–451)**: The proof correctly uses
    `ιC0_comp_τZero` (which unwraps `horseshoeτZero` via `@Injective.factorThru`) and
    `g_comp_horseshoeH` to cancel the two components. Non-vacuous. ✓

  - **Non-vacuity — `mono_biprod_lift_factorThru_of_exact` (lines 181–195)**: The proof
    walks through `cancel_mono γ`, `ShortComplex.Exact.lift_f`, and `Injective.comp_factorThru`
    to conclude `x = 0`. Each step is load-bearing. Non-vacuous. ✓

  - **Workaround hygiene — `ιC0` (line 416)**: Confirmed by LSP hover: type is
    `ses.X₃ ⟶ I_C.cocomplex.X 0`, body is `I_C.ι.f 0`. The types `((single₀).obj ses.X₃).X 0`
    and `ses.X₃` are definitionally equal in Mathlib, so `ιC0` is strictly defeq to
    `I_C.ι.f 0`. The comment accurately describes a syntactic (not semantic) workaround.
    Sound. ✓

  - **Workaround hygiene — `@Injective.factorThru` explicit mono (lines 316, 339, 345)**:
    Explicit argument passing is sound; `hses.mono_f` / `mono_of_isLimit_fork` are proper
    `Mono` instances, not ad-hoc admits. ✓

  - **Workaround hygiene — `horseshoeτZero_hf` (lines 348–353)**: Standalone helper for
    the `I_C.exact₀.descToInjective` precondition in `twistPair`'s base case. Proof uses
    only `horseshoeH_comp_d` and `ιC_comp_horseshoeτZero`. Correct and necessary given the
    universe-metavariable restriction on direct `rw`. ✓

  - **Outdated/misplaced comment block — lines 457–633**: A 177-line `/-! ### Status
    (iter-005) ... -/` block embeds project-status narrative and planner strategy guidance
    directly in the Lean source. Content belongs in PROGRESS.md / STRATEGY.md, not in a
    `.lean` file. The block includes `-- def InjectiveResolution.ofShortExact ...` at line
    570 (doubly-commented: `--` inside `/-! ... -/`). Checked against the iter-004 trap:
    `lean_decls` and `dag.json` correctly list `ofShortExact` as a pending blueprint target
    (not as an existing declaration), and `sync_leanok` uses the Lean build system rather
    than raw-text regex, so no DAG poisoning is occurring. However, the block will become
    stale the moment the remaining gap is filled, and all 8 long-line warnings in the
    diagnostics originate entirely within it (lines 465–632). Flagged **major**.

  - **Unused section variables (lines 319, 418, 429, 433)**: Lean warns that
    `[HasInjectiveResolutions 𝒜]` is automatically included but unused in
    `f_comp_horseshoeβ₁`, `ιC0_comp_d`, `horseshoeβ_fst`, `horseshoeβ_snd`. Fixable with
    `omit [HasInjectiveResolutions 𝒜] in` (consistent with the pattern already used for
    `shortExact_of_degreewise_splitting` and the `TwistedBiprod` section). Flagged
    **minor**.

  - **`@[simp]` confluence**: All simp lemmas are directed toward component form
    (`≫ biprod.fst` / `≫ biprod.snd`) or are `rfl`-equalities. The chain
    `twistedBiprod_d` → `twistedBiprodD_fst`/`snd` is directed and terminating.
    `@[reassoc (attr := simp)]` is standard Mathlib practice. No confluence issues
    detected. ✓

  - **Module docstring (lines 27–33)**: Lists three undeclared constructions
    (`ofShortExact`, `rightDerivedShiftIsoOfAcyclic`, `rightDerivedIsoOfAcyclicResolution`)
    as "will be constructed by the prover". Accurate for iter-005 but requires update once
    those land. Flagged **minor**.

  - **No circular reasoning detected**: `horseshoeH` depends on `horseshoeβ₁`; `horseshoeτZero`
    depends on `horseshoeH`; `twistPair` recurses by `ℕ`-structural recursion. No cycles.

---

## Must-fix-this-iter

None.

---

## Major

- `AcyclicResolution.lean:457–633` — 177-line `/-! ### Status (iter-005) ... -/` block
  embeds project narrative and planner strategy in Lean source. Contains a `-- def
  InjectiveResolution.ofShortExact` stub at line 570 (doubly-commented; confirmed safe from
  the iter-004 `sync_leanok` trap by direct inspection of `lean_decls`/`dag.json` and LSP
  verification). The block will become immediately stale when the remaining gap is filled
  and is the origin of all 8 long-line style warnings. Strategy and status content of this
  kind belongs in `.archon/` state files, not embedded in `.lean` source.

---

## Minor

- `AcyclicResolution.lean:319` — `f_comp_horseshoeβ₁` picks up `[HasInjectiveResolutions 𝒜]`
  as an unused section variable. Add `omit [HasInjectiveResolutions 𝒜] in`.
- `AcyclicResolution.lean:418` — `ιC0_comp_d` same issue.
- `AcyclicResolution.lean:429` — `horseshoeβ_fst` same issue.
- `AcyclicResolution.lean:433` — `horseshoeβ_snd` same issue.
- `AcyclicResolution.lean:27–33` — Module docstring lists three undeclared constructions as
  future targets; will need updating once those declarations land.
- `AcyclicResolution.lean:458` — The `iter-005` label and "REMAINING GAP (next iter)" note in
  the status block will become stale once the gap is closed. Block should be pruned at that point.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 6
- **excuse-comments**: 0

Overall verdict: The file is axiom-clean, sorry-free, and all 27+ new declarations
genuinely consume their stated hypotheses; the only actionable finding is the 177-line
embedded strategy/status block (major), whose `-- def` stub is confirmed not to
reintroduce the iter-004 `sync_leanok` trap, plus four trivially-fixable unused-section-
variable warnings (minor).
