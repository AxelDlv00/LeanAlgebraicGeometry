# Directive — progress-critic @ iter-148

## Task

Fresh-context audit of recent progress on the project's active routes.
Verdict per route: CONVERGING / CHURNING / STUCK / UNCLEAR. Plus
must-fix-this-iter findings if any.

## Active routes

### Route 1 — chart-algebra piece (ii) in `Cotangent/ChartAlgebra.lean`

The critical-path route. Five sub-pieces; remaining as of iter-148
entry:

- (KDM ring-side) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
  — L139 forward inclusion sorry; signature blueprint-mandated
  iter-147; reverse inclusion closed iter-147.
- (constants substep 3) `constants_integral_over_base_field` —
  L294 surjectivity-form sorry; 7-step closure chain documented
  in-source iter-147; step (e) flat base change of `Γ` for proper
  schemes is the substantive Mathlib gap.

Closed sub-pieces (sorry-free): α (iter-146), lift / `ext_of_diff_zero`
(iter-146 via signature reduction; iter-148+ refinement pending),
β-core (iter-147 via delegation to KDM).

#### Last K=4 iters' signals

| Iter | Decls | Inline | Δ | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|---|---|
| 144 | 6 | 6 | — | 0 | bundled-route pre-pivot | bundled route declarations |
| 145 | 8 | 8 | +2 | 5 sub-pieces scaffolded | refactor (no prover) | chart-algebra decomposition cost |
| 146 | 6 | 6 | −2 | 0 | DONE (substantive) | none — first prover on chart-algebra |
| 147 | 5 | 5 | −1 | 0 | DONE (1 closed + 2 partial) | "flat base change of Γ for proper schemes" (substep 3 step e) |

#### STRATEGY.md estimate for this route

The `## Phases & estimations` row for chart-algebra envelope:

- Iters left: **4–6**
- Iter entered current phase: iter-145 (chart-algebra pivot landed)
- Elapsed in this phase: **3 iters** (145 + 146 + 147)
- LOC: 400–800 remaining

#### Plan agent's iter-148 proposal

Single prover lane on `Cotangent/ChartAlgebra.lean` with both
remaining sorries in scope (constants substep 3 + KDM forward
inclusion). Estimate per recommendations.md: ~150–350 LOC.

### Route 2 — off-critical-path scaffolds (`Jacobian.lean` + `RigidityKbar.lean`)

Three frozen scaffolds gated on Route 1 closure:

- `Jacobian.lean:197` `genusZeroWitness` — gated on M2.a body
  (iter-149+ realistic earliest).
- `Jacobian.lean:223` `positiveGenusWitness` — gated on M3 Route
  A (iter-170+ realistic earliest).
- `RigidityKbar.lean:87` `rigidity_over_kbar` — gated on chart-
  algebra piece (ii) closure (iter-149+ realistic earliest).

#### Last K=4 iters' signals

| Iter | Δ-sorries | Helpers | Status | Notes |
|---|---|---|---|---|
| 144 | 0 | 0 | dormant | gated |
| 145 | 0 | 0 | dormant | gated |
| 146 | 0 | 0 | dormant | gated |
| 147 | 0 | 0 | dormant | gated |

#### STRATEGY.md estimate

Three separate `## Phases & estimations` rows:
- `rigidity_over_kbar` body closure — Iters left: 2; gated on
  chart-algebra envelope.
- `genusZeroWitness` body + terminal-object cluster — Iters
  left: 2–4; gated on chart-algebra envelope.
- Genus-stratified body of `nonempty_jacobianWitness` — Iters
  left: 1; trivial once arms close.
- `positiveGenusWitness` body via Route A — Iters left: 50–80
  (M3); off-critical-path.

## Plan agent's `## Current Objectives` proposal for iter-148

1. `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` — fill the 2
   remaining sorries (L294 constants substep 3 step (e); L139 KDM
   forward inclusion via char-0 path).

Single file, ~150–350 LOC aggregate. The iter-147 plan agent's
"PARTIAL with same geom-irr base-change phrase → escalate via
blueprint expansion or Mathlib-idiom consult, not 2nd prover
lane" hook is committed; iter-148 should verify whether iter-147
constituted such a PARTIAL (it did per the iter-147 review:
substantive Mathlib gap step (e) explicit).

## Specific question for the critic

Was iter-147's constants substep 3 PARTIAL = "same blocker as a
prior iter" or "new substantive Mathlib gap discovery"? The
iter-146 constants prover lane closed substeps 1–2 and deferred
substep 3 with the docstring naming geom-irr base-change as the
substantive gap. Iter-147 prover then *reduced* the substep 3
goal to surjectivity, documented the 7-step chain, and
*identified* step (e) (flat base change of `Γ` for proper
schemes) as the residual gap. Does this constitute:

(a) CHURNING (2 iters of helper-adding without closure) — in
    which case the iter-147 escalation hook fires and iter-148
    must consult Mathlib idioms / blueprint expand, NOT
    dispatch a 3rd prover lane against the same wall.

(b) CONVERGING (substantive narrowing of the gap from "geom-irr
    base-change chain" to "step (e) flat base change of Γ") —
    in which case the iter-148 prover lane should proceed and
    target the step (e) wrapper specifically.

(c) UNCLEAR — needs another iter of data.

Recommendation if (a): dispatch a `mathlib-analogist` (api-alignment
mode) on `flat base change of Γ for proper schemes` and a
`reference-retriever` on Stacks Tags 02KH + 0BUG before any
further prover lane. Recommendation if (b): the iter-148 prover
lane stands.

## What you read

ONLY this directive. No other files.

## What you DO NOT read

`STRATEGY.md`, `PROGRESS.md`, `task_pending.md`, `task_done.md`,
`PROJECT_STATUS.md`, blueprint chapters, iter sidecars, prover
journals.

## Output

Standard verdict-per-route + must-fix list per the descriptor's
prompt body. Write to `task_results/progress-critic-iter148.md`.
