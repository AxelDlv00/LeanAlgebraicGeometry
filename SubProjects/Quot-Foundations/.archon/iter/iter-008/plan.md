# Iter 008 — Plan (Quot-Foundations)

## TL;DR

The committed "MANDATORY FBC + GF dispatch" iter. iter-007 deferred FBC-A and GF-alg to decompose
their Mathlib-absent cruxes into typed sub-lemma chains (progress-critic CHURNING×2; corrective =
blueprint decomposition, executed + HARD-GATE PASS). The iter-007 critic warned a third plan-only iter
on these = avoidance. So this iter dispatches three prover lanes: **FBC-A** (build the 3 mate-trace
sub-lemmas + close `generator_trace_eq` + `map_smul'` route-(a)), **GF-alg** (restructure L5 induction
to generalize the base domain `A`, build the 3 dévissage sub-lemmas + the shared denominator engine,
close the L5/L4/algebraic-core assemblies), and **GrassmannianCells** (build the Cramer-inverse
`transitionMap` + cocycle — the next GR-cells frontier node). QUOT-A is the only deferred lane: I
prepared it via a blueprint-writer + blueprint-clean round (engine-lemma block + QCoh-bridge sub-build +
re-wired `def:modules_annihilator`), so it gates next iter. progress-critic `iter008`: **UNCLEAR ×3,
dispatch=OK, 0 avoidance** — re-dispatching FBC/GF now is the correct mandated response, not churn.

## State at entry

- iter-007 prover (QUOT-defs lane): landed `affineChart`, `IsLocallyFreeOfRank`, and a bonus
  missing-from-Mathlib engine lemma `Module.annihilator_isLocalizedModule_eq_map` — all axiom-clean.
  Two QUOT targets blocked on genuine Mathlib infra (QCoh→IsLocalizedModule bridge; absent monoidal
  `SheafOfModules`). Build GREEN. FBC 4 sorry, GF 4 sorry, QuotScheme 4 (skeleton stubs),
  GrassmannianCells 0 real (1 stale docstring).
- Reviews of record (iter-007): lean-auditor + 2 lean-vs-blueprint-checkers — 0 must-fix; 2 majors on
  QuotScheme (unmatched engine lemma needs a blueprint block; `Grassmannian.representable` Lean
  statement is an intentionally-weakened skeleton).
- FBC/GF chapters: HARD-GATE PASS at iter-007, UNCHANGED since → gate still valid for dispatch.

## Critic dispositions

- **progress-critic (`iter008`): UNCLEAR ×3, dispatch=OK, 0 CHURNING/STUCK, 0 avoidance.** FBC-A and
  GF-alg: correctives EXECUTED (blueprint expansion + proof rewrite + sub-lemma decomposition, gate
  PASS); K=4 window shows PARTIAL ×2 (not ×3); new targets structurally different from all prior
  dispatches → first prove attempt, convergence unassessable yet. GrassmannianCells: 1 iter of clean
  data. **Escalation tripwires for iter-009:** zero closures on FBC-A sub-lemmas → CHURNING; zero
  closures on GF-alg sub-lemmas → STUCK (no further in-loop corrective). QUOT-A's one-iter deferral
  judged the correct writer-first pattern, not avoidance.
- **strategy-critic: SKIPPED** (see `## Subagent skips`).
- **blueprint-reviewer: SKIPPED for the dispatched lanes** (see `## Subagent skips`).

## Decision made

### Dispatch FBC-A + GF-alg + GrassmannianCells; defer QUOT-A one iter for its writer round
- **Option chosen:** three prover lanes this iter (the two mandated deep lanes + the ready GR-cells
  frontier node); QUOT-A prepared via blueprint-writer + clean, dispatches next iter.
- **Why:** (1) FBC-A and GF-alg are the iter-007-mandated dispatch — their chapters are gate-cleared
  and unchanged, so no blueprint work gates them; deferring again = avoidance (critic-confirmed).
  (2) `def:gr_transition` is a leandag frontier node with a complete, source-quoted blueprint block and
  its only `\uses` dep (`def:gr_affine_chart`) landed iter-007 — genuine parallel progress at zero
  blueprint cost. (3) QUOT-A's two targets are blocked on infra that needs blueprint decomposition
  first (the bridge); rushing the prover at a NOTE-only target reproduces the iter-007 PARTIAL. The
  writer round (done this iter) makes QUOT-A a clean mathlib-build target for iter-009.
- **LOC/risk trade-off:** FBC-A ~80–200 (3 small sub-lemmas + 2 assemblies), GF-alg ~120–300 (induction
  restructure + 3 sub-lemmas + engine), GrassmannianCells ~80–200 (Cramer hom + cocycle). Three lanes,
  all import-independent, balanced enough to finish together. GF-alg is the highest-risk (STUCK
  tripwire) — mitigated by instructing the prover to land atomic sub-lemmas even if assemblies don't
  close.
- **Cheapest reversal signal:** if FBC-A or GF-alg lands zero closures, iter-009 escalates per the
  critic tripwire (effort-break the still-hard sub-lemma further, or — for GF — reclassify STUCK and
  weigh the user-escalation note).

## Soundness check (before spending budget on FBC/GF)

Neither crux is a false-statement trap (the failure mode the critic can't catch):
- FBC `map_smul'`: the regroup equiv IS R'-linear — this is an opaque-instance wall, not a false
  claim. Confirmed mathematically true iter-006 (the only refutation was of the *one-liner tactic*,
  not the statement).
- GF generic flatness: Nitsure §4 "Lemma on Generic Flatness", full induction proof transcribed
  verbatim in the blueprint (src L1711–1772). True with the stated hypotheses (noetherian domain base,
  finite-type algebra, finite module). No disproof attempt warranted — both are textbook-true.

## Subagent dispatches this iter

- **progress-critic `iter008`** (read-only, mandatory): verdicts above. Directive carried only the
  extracted per-route signals + the proposed objective list (no STRATEGY/blueprint), per its context
  discipline.
- **blueprint-writer `quot-annihilator`** (write `Picard_QuotScheme.tex` + `references/**`): added
  `lem:annihilator_localization_eq_map` (matched to the landed Lean engine lemma — clears the iter-007
  unmatched-debt major), `lem:qcoh_section_localization_basicOpen` (QCoh→IsLocalizedModule bridge,
  Stacks-cited, TODO Lean name `Scheme.Modules.isLocalizedModule_basicOpen`), a `\mathlibok` anchor for
  `IsAffineOpen.isLocalization_basicOpen`, and re-wired `def:modules_annihilator` to `\uses{}` both +
  require quasi-coherent finite-type `F`. leandag clean.
- **blueprint-clean `quot-iter008`** (write `Picard_QuotScheme.tex` + `references/**`): stripped
  iter-history tags + Lean identifiers from the `def:modules_annihilator` NOTE; removed a circular
  `\uses{def:modules_annihilator}` from the algebra engine lemma (it's pure ring theory, cannot depend
  on the sheaf def that uses it); verified all 3 source quotes verbatim against local reference files
  (Nitsure L468–471 + Stacks `lemma-spec-sheaves` item (4)).

## Subagent skips

- **strategy-critic**: STRATEGY.md route is unchanged this iter (the fan-of-independent-leaves
  decomposition is identical; no route swap, no phase split, no estimate drift >30%); the iter-007
  verdict was SOUND with 0 live CHALLENGE/REJECT. This iter is pure execution of the existing plan
  (dispatch the gate-cleared lanes). Re-running it would be a hollow dispatch.
- **blueprint-reviewer**: skipped for the three DISPATCHED lanes — their chapters
  (`Cohomology_FlatBaseChange.tex`, `Picard_FlatteningStratification.tex`,
  `Picard_GrassmannianCells.tex`) are byte-unchanged since the iter-007 HARD-GATE PASS, and no live
  must-fix touches them. The only chapter edited this iter (`Picard_QuotScheme.tex`) backs QUOT-A,
  which is DEFERRED — it receives the mandatory blueprint-reviewer next iter before any prover runs on
  it (gate honored, just at iter-009). Per the dispatcher_notes skip clause: no active-prover-lane
  chapter was edited; prior verdict cleared the gate for all active lanes; no live must-fix.

## Tool substitutions

- None. The `archon-informal-agent.py` route remains unavailable (no LLM API key in env, re-confirmed
  this iter); not needed this iter — all sub-lemmas have detailed blueprint sketches + verified Mathlib
  API anchors (`analogies/gf-generic-rank-ses.md`, the FBC/GF chapter `% LEAN SIGNATURE` blocks).
