# iter-006 review (session_6)

## Overall Progress — this session
- **Prover lane**: one (P4 → `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`,
  `[prover-mode: mathlib-build]`). Model: sonnet.
- **Global sorry**: 2 → 2 (unchanged). Both in `CechHigherDirectImage.lean`
  (`CechAcyclic.affine` L774, `cech_computes_higherDirectImage` L811 — P3/P5, out of scope).
- **`AcyclicResolution.lean`**: 0 → 0 sorries; **14 new declarations added**, all axiom-clean
  (`{propext, Classical.choice, Quot.sound}`). Compiles `EXIT 0` (style warnings only).
- **P4 targets (3 named blueprint targets + the `quasiIso_τ₂` supplement)**:
  solved / partial / blocked = TARGET 1 ✅, TARGET 2 ✅ (part (1)), TARGET 3 ⛔; supplement ✅.
- **Solved / partial / blocked / untouched** (5 attempted): 4 / 0 / 1 / 0.

## This session's analysis
**The multi-iter P4 bottleneck is closed.** iter-004 built every *consumer* of the horseshoe;
iter-005 built almost all of the horseshoe core (twisted-biproduct complex, the τ twist recursion
+ cocycle), collapsing the whole P4 chain to one precise gap — the middle-term quasi-iso transfer
`HomologicalComplex.HomologySequence.quasiIso_τ₂`, ABSENT from Mathlib. This iter built it (a
faithful general homology four-lemma over the `mapComposableArrows₅` windows with the ℕ degree-0
boundary mono) and then assembled, straight-line: `quasiIso_horseshoeι` → `ofShortExact_resolvesMiddle`
→ `ofShortExact` (the dual Horseshoe Lemma, TARGET 1) → `rightDerivedShiftIsoOfAcyclic` (object-level
dimension shift, TARGET 2, by feeding the horseshoe lift into the iter-004 engine
`rightDerivedShiftIsoOfSplitResolutionSES`). The decompose-then-build response across iters 005→006
carried the construction to completion; the strategy's reversal signal (horseshoe a multi-iter wall)
never fired.

The prover correctly **declined** to start TARGET 3 (`rightDerivedIsoOfAcyclicResolution`, the
staircase): it is a separate multi-lemma construction needing two new ingredients — (a) the part-2
base-case coker iso `(R¹G)(A) ≅ coker(G(J)→G(Z))` and (b) cosyzygy SES infrastructure — and a
sorry-bearing partial def would not count under `mathlib-build`. It handed off a precise recipe +
suggested input signature. The right next action is an **effort-break** into (a)+(b), mirroring the
horseshoe decomposition — NOT a re-dispatch of the monolith.

### Headline finding — partial coverage of `lem:acyclic_dimension_shift` (lean-vs-blueprint MAJOR)
`rightDerivedShiftIsoOfAcyclic` is axiom-clean and carries a genuine `\leanok`, but the blueprint
lemma states **two** parts and the Lean delivers **part (1) only** (the k≥1 shift isos). Part (2),
`(R¹G)(A) ≅ coker(G(J)→G(Z))`, is not in the Lean signature — it is precisely TARGET 3 ingredient (a).
This is the inverse of a laundering risk: the declaration is real, but the *statement* over-claims
relative to the Lean, so a reader could think the cokernel base case is done. I added a
`% NOTE (iter-006 review): PARTIAL COVERAGE`; the planner should split part (2) into its own block
(natural, since it equals TARGET 3 ingredient (a)) or narrow the statement. Captured in recommendations.

### Two stale review NOTEs retired
- iter-004 FALSE-DONE NOTE on `lem:injective_resolution_of_ses` (the code-fence false-positive):
  obsolete — `ofShortExact` now genuinely exists and is axiom-clean. Replaced with a CLOSED note.
- iter-005 `quasiIso_τ₂`-is-ABSENT scaffolding NOTE on `lem:horseshoe_resolvesMiddle`: obsolete —
  the transfer was built. Replaced with a CLOSED note.

## Subagent dispatches
- **lean-auditor** (`iter006`): dispatched (`.lean` modified). iter-006 work **entirely clean** — all
  four focus decls axiom-clean and non-vacuous, `quasiIso_τ₂` boundary hyps correctly universally
  quantified (not a degree-0 special case), code-fence trap not reintroduced. 2 must-fix + 2 major are
  **pre-existing**: the two `CechHigherDirectImage.lean` sorries (P3/P5) and two stale comment blocks
  there (L184, L246–449) claiming `pushPullMap_comp` unimplemented when it is proved at L627. 9 minor.
  Report: `task_results/lean-auditor-iter006.md`.
- **lean-vs-blueprint-checker** (`acyclic`): dispatched. 0 must-fix; 4 major (partial coverage of
  `lem:acyclic_dimension_shift`; dangling `\lean{rightDerivedIsoOfAcyclicResolution}` for unbuilt
  TARGET 3 [expected]; `quasiIso_τ₂` and `rightDerivedShiftIsoOfSplitResolutionSES` lack blueprint
  blocks); 2 minor. Report: `task_results/lean-vs-blueprint-checker-acyclic.md`.

(No `## Subagent skips` — both highly-recommended review subagents dispatched.)

## Blueprint doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`, no new `axiom` declarations.

## Blueprint markers updated (manual)
- `Cohomology_AcyclicResolution.tex`, `lem:injective_resolution_of_ses`: stale iter-004 FALSE-DONE
  `% NOTE` → `% NOTE (iter-006 review): CLOSED`.
- `Cohomology_AcyclicResolution.tex`, `lem:horseshoe_resolvesMiddle`: stale iter-005
  `quasiIso_τ₂`-ABSENT `% NOTE` → `% NOTE (iter-006 review): CLOSED`.
- `Cohomology_AcyclicResolution.tex`, `lem:acyclic_dimension_shift`: added
  `% NOTE (iter-006 review): PARTIAL COVERAGE` (Lean covers part (1) only).

(No `\leanok` touched — owned by `sync_leanok`, which ran this iter: iter 6, sha 79bc88b, added 6.)
