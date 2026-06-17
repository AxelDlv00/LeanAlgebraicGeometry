# Progress-critic directive — iter-008

Assess convergence per active route from the extracted signals below. K=4 (iters 004–007).
For each route give a verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, if CHURNING/STUCK,
name the corrective TYPE. Also run the dispatch-sanity check on the proposed objective list.

## Route: FBC-A — Cohomology/FlatBaseChange.lean
- Strategy estimate: Iters left 3–4; phase entered ~iter-002 (elapsed ~6 iters, OVER-BUDGET noted).
- Signals (sorry count / prover status / helpers / blocker phrase):
  - iter-004: PARTIAL. Landed L4-a regroup core + L4-c IsIso corollary (axiom-clean). sorry 4.
  - iter-005: dag-only stage, NO prover run.
  - iter-006: PARTIAL. sorry 4→4. The `map_smul'` one-liner (split into RegroupHelper.lean module)
    was REFUTED as mathematically unsound (different tensor carrier TYPES, not a reducibility diamond).
    `generator_trace_eq` got only an `ext x` reduction. Helpers added: 0 net.
  - iter-007: NO prover (intentionally DEFERRED). Corrective executed: blueprint decomposition —
    rewrote the unsound `base_change_mate_regroupEquiv` proof sketch (route-(a) TensorProduct.ext at
    full carrier) and split `generator_trace_eq` into 3 typed sub-lemmas (`base_change_mate_unit_value`,
    `…_fstar_reindex`, `…_gstar_transpose`). blueprint-reviewer iter-007: HARD GATE PASS.
  - Recurring blocker phrase: "map_smul' opaque-instance wall"; "monolithic Mathlib-absent mate trace".
- iter-008 plan: FIRST prove attempt post-decomposition — build+prove the 3 sub-lemmas + thin assembly
  + close map_smul' via route-(a). (NOT another helper round on the monolith.)

## Route: GF-alg — Picard/FlatteningStratification.lean
- Strategy estimate: Iters left 3–4; phase entered ~iter-002 (elapsed ~6 iters).
- Signals:
  - iter-004: landed full L3 chain (4 lemmas, axiom-clean). sorry 4.
  - iter-005: dag-only, NO prover.
  - iter-006: PARTIAL. sorry 4→4. Landed `Nat.strong_induction_on generalizing N` skeleton (the
    iter-006 named corrective, achieved). Dévissage SES residue stayed Mathlib-absent.
  - iter-007: NO prover (DEFERRED). Corrective executed: decomposed L5 into `gf_generic_rank_ses` +
    `gf_torsion_reindex` + assembly, L4 into `gf_clear_one_denominator` + fold; mathlib-analogist
    verified the generic-rank API AND surfaced root cause: the induction must generalize the BASE
    DOMAIN A, not just N. Recipe: analogies/gf-generic-rank-ses.md. blueprint-reviewer: HARD GATE PASS.
  - Recurring blocker phrase: "generic-rank SES dévissage Mathlib-absent"; was at STUCK boundary.
- iter-008 plan: restructure L5 induction to generalize base domain A, then build+prove the 3 sub-lemmas
  (verified atoms) + thin assemblies. First prove attempt post-decomposition.

## Route: GrassmannianCells — Picard/GrassmannianCells.lean
- Strategy estimate: part of QUOT-defs, Iters left 4–7; phase entered iter-007.
- Signals:
  - iter-007: first dispatch. `affineChart` stub filled (RESOLVED, axiom-clean). File 1→0 real sorry
    (one stale docstring mention remains). No helpers churned.
- iter-008 plan: build `transitionMap` (`def:gr_transition`) + cocycle — next frontier node, blueprint
  complete with full Nitsure §1 source quotes.

## Route: QUOT-A — Picard/QuotScheme.lean (DEFERRED this iter, pending blueprint-writer)
- Strategy estimate: QUOT-defs, Iters left 4–7; phase entered iter-007.
- Signals:
  - iter-007: first real def dispatch. Landed `IsLocallyFreeOfRank` def + `annihilator_…_eq_map`
    engine lemma (both axiom-clean). 2 targets BLOCKED on genuine Mathlib infra gaps (QCoh→
    IsLocalizedModule bridge; absent monoidal structure on SheafOfModules). sorry 4→4 (stubs untouched).
- iter-008 plan: NOT dispatched this iter — a blueprint-writer is adding the engine-lemma block +
  decomposing the QCoh-bridge sub-build first; QUOT-A dispatches next iter.

## Proposed iter-008 objective list (dispatch-sanity check target)
3 files: FlatBaseChange.lean (FBC-A), FlatteningStratification.lean (GF-alg), GrassmannianCells.lean.
QUOT-A deferred (writer round). Is this an honest dispatch, or does deferring QUOT-A + dispatching
the two previously-CHURNING routes (FBC/GF) the iter after their decomposition look like avoidance or
churn-continuation? Assess specifically whether re-dispatching FBC/GF now is the correct response to
last iter's CHURNING (corrective was executed) vs a disguised repeat.
