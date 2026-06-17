# Progress Critic Directive — iter-150

Fresh-context audit. **Do NOT read** `STRATEGY.md`, blueprint chapters, iter sidecars, prover task results, or review summaries. Verdict the active routes against the extracted signals below.

## Active routes the planner is considering

### Route C — chart-algebra piece (ii) (M2.a critical path)

Files: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`, `AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean` (NEW iter-149).

#### Signals — last 5 iters (iter-145 → iter-149)

| Iter | Sorry count (decl) | Helpers added | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| iter-145 | 8 | 0 (pivot iter) | n/a (pivot) | "iter-145 chart-algebra pivot established" |
| iter-146 | 6 | (β-core PARTIAL) | PARTIAL | "Mathlib gap; KDM forward inclusion" |
| iter-147 | 5 | (β-core CLOSED iter-147; KDM PARTIAL) | PARTIAL (β-core CLOSE) | "Mathlib gap; flat base change of Γ" |
| iter-148 | 5 | (KDM (BR.*) decomposition + substep 3 (S3.*) sub-claim split) | PARTIAL | "Mathlib gap (BR.5) joint-kernel + (S3.pi.1) flat base change" |
| iter-149 | 9 (+4 NET, decomposition) | NEW FILE `ChartAlgebraS3.lean` (4 first-class scaffolds for (S3.*)) + hSep branch CLOSED in-tree | PARTIAL (4 scaffolds + 1 in-tree branch closed; 0 of 4 (S3.*) bodies closed; KDM (BR.5) unclosed) | "Mathlib gap (BR.5) joint-kernel + (S3.pi.1) flat base change" |

#### Strategy's iter-left estimate

From STRATEGY.md row 1 of `## Phases & estimations`:
- Status: 3 closed, 1 partial, 1 open.
- Iters left: **5–9**.
- LOC remaining: **380–800**.

Route entered current phase (chart-algebra pivot): **iter-145**. Elapsed: 4 iters (iter-146 → iter-149). Iter-150 is iter 5 of the route.

#### Iter-149 escalation hook context (from prior plan commitment)

The iter-149 plan committed to: "if iter-149 lane closes ≤1 of four (S3.*) sub-claims AND KDM (p2) body still structured sorry, iter-150 MUST dispatch mid-iter mathlib-analogist in `cross-domain-inspiration` mode for the H1Cotangent-vanishing reformulation. Route-pivot conversation becomes mandatory."

Iter-149 outcome: 0/4 (S3.*) bodies closed (all PARTIAL scaffolds). KDM (BR.5) body still structured sorry. **Trigger conditions met.**

Honest qualifier the planner notes: the iter-149 lane DID deliver substantive scaffolding (new file + 4 first-class declarations + hSep branch in-tree closure + (BR.2)–(BR.4) KDM scaffolding); the hook is triggered on the strict (S3.*)-body-closure metric, NOT on intermediate consumer-side advance.

### Route A — Picard scheme via FGA (M3 off-critical-path)

Off-critical-path. No prover work scheduled.

## Planner's iter-150 proposal — PROGRESS.md `## Current Objectives`

Two lanes proposed, both on Route C:

1. **`AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`** — close (S3.sep.1) + (S3.sep.2) + (S3.pi.2) (3 of 4 bodies). Leave (S3.pi.1) PARTIAL (deep Mathlib gap; iter-150+ scope).
2. **`AlgebraicJacobian/Cotangent/ChartAlgebra.lean`** — close hPI branch of `constants_integral_over_base_field` (consumes Lane 1 lemmas) + (BR.5) KDM joint-kernel collapse helper.

## Verdicts requested

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with:
- Named corrective if CHURNING / STUCK.
- Specific commentary on whether the iter-149 escalation hook (mathlib-analogist cross-domain dispatch + route-pivot conversation) should fire as committed, or whether the substantive iter-149 advance (4 first-class scaffolds + hSep branch in-tree closure + KDM (BR.2)–(BR.4) scaffolding) warrants relaxing the hook to "continue path (b) with the now-decomposed targets".
- Dispatch sanity: do the two lanes proposed look right given the route's trajectory?

Write report to `.archon/task_results/progress-critic-iter150.md`.
