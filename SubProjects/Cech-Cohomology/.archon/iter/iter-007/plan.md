# Iter-007 plan — TARGET 3 staircase decomposed + gate-cleared; single P4 prover lane dispatched to close P4

## Context

iter-006 closed P4 TARGET 1 (horseshoe `ofShortExact`) + TARGET 2 (object-level dimension shift
`rightDerivedShiftIsoOfAcyclic`, part 1), collapsing P4 to the comparison theorem TARGET 3
(`rightDerivedIsoOfAcyclicResolution`, the staircase). The prover correctly declined TARGET 3 as a
separate multi-lemma construction and handed off a precise (a) base coker iso + (b) cosyzygy-SES
recipe. The iter-006 lean-vs-blueprint-checker flagged: partial coverage of `lem:acyclic_dimension_shift`
(Lean = part 1 only), and two missing blueprint blocks (`quasiIso_τ₂`, `rightDerivedShiftIsoOfSplitResolutionSES`).

## What this plan phase did (across context-window resumption)

This phase was resumed after context summarization; the earlier window had already:
1. **strategy-critic** (`baseline`) → CHALLENGE (specific): (1) make basis-lemma dependency explicit
   + scope it; (2) commit P5a/P5b split + exploit parallelism; (3) format DRIFTED. **Addressed** in
   the 05:58 STRATEGY.md edit (separate P5a/P5b rows; basis lemma scoped in Open Questions + Routes
   bridge subsection; per-iter narrative stripped; bare status tags).
2. **progress-critic** (`p4t3`) → CONVERGING (46 axiom-clean decls / 3 iters, 2/3 named targets
   closed iter-006, concrete TARGET 3 recipe in hand). PARTIAL×3 false-positive correctly dismissed.
3. **effort-breaker** (`staircase`) → decomposed TARGET 3 into the sourced `\uses`-chain
   `lem:cosyzygy_ses`, `lem:acyclic_one_iso_coker`, `lem:applied_cosyzygy_cycles`,
   `lem:cohomology_of_applied_resolution` + assembly; split `lem:acyclic_dimension_shift` to part
   (1) only (resolving the iter-006 PARTIAL-COVERAGE flag). It flagged 2 pre-existing broken `\uses{}`
   refs (`lem:quasiIso_tau2`, `lem:right_derived_shift_split_resolution`).

This window completed the phase:
4. **Plan agent wrote the 2 missing blueprint blocks** (`lem:quasiIso_tau2` for the proven
   `quasiIso_τ₂`; `lem:right_derived_shift_split_resolution` for the proven
   `rightDerivedShiftIsoOfSplitResolutionSES`) — both project-bespoke supplements (no source quote).
   DAG re-checked: **zero broken `\uses{}`** across all chapters.
5. **blueprint-clean** (`acyclic`) → stripped 6 process-history `% NOTE` blocks; validated all
   staircase source quotes verbatim-faithful against `references/homological-acyclic-derived.tex`.
6. **whole blueprint-reviewer** (`gate`) → `Cohomology_AcyclicResolution.tex` **complete + correct,
   HARD GATE CLEARS** for the P4 lane (all `\mathlibok` anchors verified; staircase proofs adequate
   for direct formalization; 0 unstarted-phase proposals). One must-fix: deferral-only on
   `Cohomology_CechHigherDirectImage.tex` (P3/P5 known-deferred).
7. Wrote the single P4 prover lane to PROGRESS.md (`[prover-mode: mathlib-build]`, scaffold/build
   phrasing so plan-validate doesn't noop the zero-sorry file).

## Decisions made

### D1 — Single P4 lane this iter (close P4); no second parallel lane (parallelism directive weighed).
- **What**: dispatch ONE `mathlib-build` lane on `AcyclicResolution.lean` to build the 5 TARGET 3
  declarations (2 frontier-ready leaves + 2 upstream + assembly). Straight-line off already-proven
  decls; expected to close the entire P4 phase.
- **Why single lane**: there is exactly one gate-cleared, statement-sound ready lane. The P4 chain
  is a single bottom-up dependency in one file — splitting it across provers needs import coupling
  for marginal gain. The other frontier nodes are P5a, behind a `partial/partial` chapter that fails
  the HARD GATE (see D2). progress-critic validated "1 of 1 ready lane = full utilization."
- **Reversal signal**: if the prover stalls on a staircase leaf, effort-break that leaf (the
  decomposition floor has no limit) rather than re-dispatch the monolith.

### D2 — P5a is NOT a parallel lane this iter; first action when P4 closes is a P5a blueprint rewrite.
- The standing parallelism directive + strategy-critic must-fix #2 push P5a parallelism. The honest
  blocker: `Cohomology_CechHigherDirectImage.tex` is `partial/partial`, and **two P5a/P5b proof
  sketches (`lem:cech_to_cohomology_on_basis` via a Čech-to-derived spectral sequence;
  `lem:open_immersion_pushforward_comp` via the relative Leray spectral sequence) invoke spectral
  sequences ABSENT from Mathlib** — which also contradicts Route A's "no spectral sequences" basis.
  P5a cannot pass the gate until those are rewritten to the acyclic-resolution / basis-comparison
  argument. That is substantial blueprint work (Stacks 01EO + relative affine vanishing), not a quick
  fix; the blueprint-reviewer itself gave 0 unstarted-phase proposals and judged the chapter
  "mathematically sound up to known Mathlib gaps."
- **Decision**: do NOT spin up a half-baked P5a writer alongside P4's close (would produce
  gate-failing blueprint the next iter throws away — exactly what the gate guards). Instead, recorded
  the rewrite as the **first action once P4 closes** (PROGRESS.md Deferred + STRATEGY.md new Open
  Question). P4 is the rate-limiter and ~1 iter from done; finishing it cleanly is the highest-value
  move. This is a genuine "no second gate-cleared lane exists" serialization, not avoidance.

### D3 — strategy-critic CHALLENGE addressed, not rebutted.
- All three must-fixes were folded into STRATEGY.md (05:58 edit + this window's Open-Question
  addition on the P5 spectral-sequence rewrite). No rebuttal needed — the critic's reading is correct
  and the route choice (Route A) was affirmed SOUND by the same report.

## Deferral rationale (blueprint-reviewer must-fix)

`Cohomology_CechHigherDirectImage.tex` is `partial/partial` — **known-deferred, not writer-fixable
this iter**: P3 statement gap (general `OpenCover` vs standard-cover, narrowing DECIDED), and
P5a/P5b inputs blocked on absent Mathlib facts (and two sketches needing Route-A rewrites, D2). This
partial does NOT gate the P4 prover lane on `AcyclicResolution.lean`. No blueprint-writer dispatched
against it this iter (deferred to P4's close).

## Subagent skips

- (none — strategy-critic, progress-critic, blueprint-reviewer all dispatched this iter;
  blueprint-clean dispatched after the effort-breaker writer round.)
