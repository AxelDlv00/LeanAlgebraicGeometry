# Progress Critic Directive

## Slug
iter009

## Scope
Assess convergence per active route for iter-009 dispatch. K=4 window (iters 004–008; 005 and 007 were
plan-only / decomposition iters with no prover on these files). Render CONVERGING / CHURNING / STUCK /
UNCLEAR per route + dispatch-sanity on the objectives proposal.

## Route 1 — FBC-A — `Cohomology/FlatBaseChange.lean`
Strategy: `Iters left` = 3–4; entered ACTIVE phase ~iter-002 (≈6 iters elapsed; flagged OVER-BUDGET).
Signals (last K iters):
- iter-004: landed 2 helpers (L4-a regroup core, L4-c trace corollary), axiom-clean. sorry 4. PARTIAL.
- iter-006: tried the `map_smul'` one-liner → REFUTED as unsound; only an `ext x` reduction committed.
  helpers added: 0 net. sorry 4. PARTIAL.
- iter-007: NO prover (route deferred for blueprint decomposition into 3 mate sub-lemmas).
- iter-008: `map_smul'` route-(a) — substantive generator computation + R'-additivity PROVEN; 2 residual
  `r' • 0 = 0` zero-branches left as `sorry`. The 3 mate sub-lemmas (`base_change_mate_unit_value` /
  `_fstar_reindex` / `_gstar_transpose`) were NOT created — prover refused to guess their Lean types
  because the blueprint blocks carry prose but NO `% LEAN SIGNATURE` (correctly declined to fabricate
  categorically-subtle adjunction-unit / pseudofunctor-reindex / transpose types). `generator_trace_eq`
  NOT attempted. helpers added: 0. sorry 4→5 (the +1 is the zero-branch split, not regression). PARTIAL.
- Recurring blocker phrases: "opaque `Module R'` instance won't synthesize `SMulZeroClass`" (map_smul'
  zero-branches); "mate sub-lemmas untyped / no `% LEAN SIGNATURE` block" (generator_trace_eq).

## Route 2 — GF-alg — `Picard/FlatteningStratification.lean`
Strategy: `Iters left` = 3–4; entered ACTIVE phase ~iter-002 (≈6 iters elapsed).
Signals (last K iters):
- iter-004: landed the entire L3 chain (4 lemmas) axiom-clean. sorry 4. PARTIAL.
- iter-006: landed the strong-induction skeleton (generalizing N) axiom-clean. helpers 0 net. sorry 4. PARTIAL.
- iter-007: NO prover (route deferred for blueprint decomposition into gf_generic_rank_ses /
  gf_torsion_reindex / gf_clear_one_denominator).
- iter-008: 2 NEW sub-lemmas PROVED axiom-clean (`gf_generic_rank_ses`, `gf_clear_one_denominator`);
  the load-bearing L5 induction restructure to generalize the BASE DOMAIN `A` landed (the named iter-006
  root-cause); `gf_torsion_reindex` created with `sorry` (single-variable Nagata elimination — genuinely
  Mathlib-absent). helpers added: 2 (both proved). sorry 4→5 (the +1 is the isolated torsion-reindex
  residue). PARTIAL with 2 axiom-clean closures.
- Recurring blocker phrases: "single-variable Nagata elimination / variable-drop engine Mathlib-absent"
  (shared by gf_torsion_reindex L5b and L4 Step 2).

## Route 3 — GR-cells — `Picard/GrassmannianCells.lean`
Strategy: `Iters left` = 4–7 (QUOT-defs phase); GR-cells sub-phase started iter-007.
Signals:
- iter-007: `affineChart` landed axiom-clean (file went to 0 real sorry).
- iter-008: dispatched on `def:gr_transition` (Cramer-inverse transition map) → produced NOTHING: 0 edits
  committed, no task_result written, file unchanged. helpers 0. sorry unchanged.
- Recurring blocker phrases: none recorded (silent no-output).

## iter-009 `## Current Objectives` proposal (dispatch-sanity check)
Proposing 3 prover lanes (file count = 3):
1. `Picard/GrassmannianCells.lean` — re-dispatch `def:gr_transition` [mathlib-build].
2. `Picard/FlatteningStratification.lean` — continue L5/L4 assemblies (GF converging).
3. `Picard/QuotScheme.lean` — annihilator sub-build [mathlib-build] (conditional on blueprint gate).
FBC-A is being DEFERRED this iter (route under design-shape re-validation: mathlib-analogist on the
opaque-`Module R'` wall + blueprint-writer to type the 3 mate sub-lemmas). Flag if this deferral, or any
of the 3 proposed lanes, is unsound.
