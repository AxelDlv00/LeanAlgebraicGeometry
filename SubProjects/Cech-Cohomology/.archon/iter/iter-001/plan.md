# Iter-001 plan — foundation pivot to the acyclic-resolution route

## Context

First iteration of the freshly-extracted `Cech-Cohomology` subproject. Goal: prove the
protected `AlgebraicGeometry.cech_computes_higherDirectImage` (`lem:cech_computes_cohomology`)
and its cone, zero sorry / zero axioms. At start: 3 inline sorries (`CechNerve`,
`CechAcyclic.affine`, `cech_computes_higherDirectImage`), all blocked on absent-from-Mathlib
infrastructure; inherited strategy routed the comparison theorem through TWO spectral
sequences for `Scheme.Modules`. Frontier was empty ("Ready to prove: none").

## What I did

Ran a 4-way parallel read-only validation pass before committing any prover budget:
strategy-critic, strategy-auditor (read Stacks source), blueprint-reviewer (whole-blueprint
+ HARD GATE), mathlib-analogist (api-alignment on the push–pull functor). Then acted on the
convergent findings: rewrote STRATEGY.md, split the HARD-GATE-blocking blueprint block,
dispatched two blueprint-writers to rewrite the comparison route, ran blueprint-clean, and
updated content.tex / STRATEGY.md.

## Decision made

### D1 — Comparison theorem: PIVOT to the acyclic-resolution route (Route A); spectral sequences demoted to fallback (Route B).
- **Why**: strategy-critic and strategy-auditor *independently* identified the two-spectral-
  sequence route as the project's dominant infeasibility risk (both SS absent from Mathlib for
  `Scheme.Modules`; Leray additionally needs quasi-coherence of `R^q f_*` via Mayer–Vietoris —
  another absent prerequisite the blueprint had omitted). The goal is only the weak
  `Nonempty (homology i ≅ rightDerived i)` existence form. The standard Cartan–Leray
  acyclic-cover proof (Stacks Tag 015E) gives it via ONE abstract homological-algebra lemma,
  buildable by comparison-of-resolutions from Mathlib's verified `InjectiveResolution.isoRightDerivedObj`,
  and it REUSES the affine-acyclicity phase (P3) as its acyclicity input — removing a blocker
  and sharing infrastructure rather than building two SS from scratch.
- **LOC/risk trade-off**: Route B ≈ multi-thousand LOC of SS machinery + a Mayer–Vietoris
  quasi-coherence lemma; Route A ≈ one abstract lemma (~200–450 LOC) + the geometric inputs we
  needed anyway. Strictly lighter.
- **Cheapest reversal signal**: if the abstract lemma `rightDerivedIsoOfAcyclicResolution`
  proves unexpectedly hard in Lean (e.g. the comparison-of-resolutions route also hits a wall),
  reconsider Route B for the degree-0 / affine-base corollary only.

### D2 — `pushPullMap_comp`: prove via the MATE calculus, and treat it as a parallelizable side-task, not THE rate-limiter.
- mathlib-analogist (major, ALIGN_WITH_MATHLIB): the composition law is an instance of
  `CategoryTheory.conjugateEquiv_comp` ("mate-of-composite = composite-of-mates"); via
  injectivity of `conjugateEquiv` it reduces to the pullback-side `pseudofunctor_associativity`,
  staying syntactic — the stalled pushforward-side `erw` grind is what triggered the documented
  kernel `whnf` explosion. Recipe persisted in `analogies/pushpull-functoriality.md` and folded
  into the `lem:push_pull_comp` blueprint block. Strategy-critic also flagged the prior
  "rate-limiter, weight effort there" posture as sunk-cost: closing `pushPullMap_comp` only
  unblocks `CechNerve`/`CechComplex`, not the protected target. Reframed accordingly.
- mathlib-analogist also confirmed (Q1/Q2): keep the hand-rolled functor `G` — Mathlib has no
  pseudofunctor→fixed-object-functor straightening, and `G`'s functoriality is genuinely on the
  critical path for `CechNerve` (no bypass). So `pushPullMap_comp` is still needed, just not THE
  pole.

### D3 — P4 build route: comparison-of-resolutions, NOT a hand-built LES.
- acyclicres writer found Mathlib has NO long-exact-sequence / δ-functor for
  `Functor.rightDerived`. Rather than build that general machinery, build Leray's acyclicity by
  comparing the acyclic resolution `J•` to an injective resolution `I•` of `A`:
  `isZero_rightDerived_obj_injective_succ` shows `G(J•) → G(I•)` is a `G`-quasi-iso, then
  `isoRightDerivedObj` transports. Recorded in STRATEGY Open questions. Implication: the
  `lem:acyclic_dimension_shift` sub-lemma may be reframed/dropped at scaffold time — leave the
  blueprint block (mathematically valid) and let iter-002 choose under D3.

### D4 — File split: the abstract lemma lives in a NEW file `AcyclicResolution.lean`.
- Honors the standing parallelism directive (scheme-independent, reusable, parallel-provable)
  and keeps the Čech file focused. New chapter `Cohomology_AcyclicResolution.tex` created +
  wired into content.tex.

## Why no prover proof dispatch this iter (mechanical + blueprint HARD GATE)

The frontier was empty; the only sorry-bearing file (`CechHigherDirectImage.lean`) is covered
by a chapter the blueprint-reviewer rated `correct: partial` (broken `\lean{pushPullMap_comp}`),
and I then pivoted the strategy and rewrote that chapter + added a new chapter. The rewritten
blueprint's to-build `\lean{}` targets are unmatched until scaffolded. Sending a prover into a
mid-pivot, freshly-rewritten, unreviewed blueprint is the exact waste the HARD GATE exists to
prevent. iter-002 scaffolds the frontier (matched targets) → mandatory blueprint-reviewer
clears the gate → provers fan out. Deferral is intentional, not idling: this iter delivered a
strategy pivot that removes the project's dominant infeasibility risk + a complete, cleaned,
graph-consistent blueprint rewrite.

## Rebuttals to subagent findings
None withheld. All four reports' must-fix findings were acted on:
- strategy-critic CHALLENGE (comparison route undecided/undecomposed) → adopted Route A,
  decomposed into P2–P5 with estimates, restructured STRATEGY.md to canonical skeleton with
  the missing `Iters left`/`LOC` columns.
- strategy-critic format NON-COMPLIANT → STRATEGY.md rewritten to canonical headings.
- blueprint-reviewer HARD GATE (correct: partial, unmatched `pushPullMap_comp`) → split block;
  full gate clearance deferred to iter-002 post-scaffold review.
- strategy-auditor (two-SS overstatement; missing quasi-coherence prereq; conflated
  `cech_acyclic_affine`) → all resolved by the Route A pivot + the `cech_acyclic_affine` split.

## Subagent skips

- progress-critic: prior iter ran no prover phase (this is iter-001, fresh extraction) — no
  trajectory data to assess. Skip condition met per its dispatcher_notes.

## Tool substitutions

- `archon-informal-agent.py` requires an external-LLM API key; `env` has only `GEMINI_CLI_*`
  (IDE-server vars), not `GEMINI_API_KEY`/`DEEPSEEK_API_KEY`/etc. Where I needed a Mathlib-
  design opinion and a literature-grounded route check I used the in-catalog subagents
  (mathlib-analogist, strategy-auditor, blueprint-writer→reference-retriever) instead. No
  fabricated verification produced.

## References newly available
- `references/homological-acyclic-derived.tex` (Stacks `derived.tex`) + `-homology.tex`,
  registered in `references/summary.md` as `homological-acyclic.md`. Tags 0157/015C/015D/015E/05TA
  back `Cohomology_AcyclicResolution.tex`. Retrieved this iter by a child reference-retriever.

## Carry-forward for iter-002
- Retrieve Stacks `cohomology.tex` for the standalone statement of
  `cohomology-lemma-cech-vanish-basis` before scaffolding `cech_eq_cohomology_of_basis`.
- After scaffolding, the 4 `lean_aux` push–pull helpers still need blueprint entries once
  `pushPullMap_comp` closes (1-to-1 Lean↔blueprint upkeep).
