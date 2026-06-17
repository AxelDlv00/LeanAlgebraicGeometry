# Progress Critic Directive — iter-151

Assess convergence of the single active prover route. Verdict per route.

## Route C (M2 critical path) — chart-algebra envelope
Files: `AlgebraicJacobian/Cotangent/ChartAlgebra.lean`,
`AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean`.

### Strategy estimate (verbatim from STRATEGY.md `## Phases & estimations`)
- Row: "Chart-algebra envelope (5 sub-pieces)" — Status: 3 closed, 1 partial,
  1 open. **Iters left: 6–10.**
- Route entered current phase (chart-algebra pivot): **iter-144**. Elapsed in
  this phase by iter-151 entry: **7 iters**.

### Last 5 iters' signals (extracted by the plan agent)

| iter | declarations-using-sorry (NET) | helpers / LOC added | prover status | recurring blocker phrase |
|---|---|---|---|---|
| 146 | (pre-decomposition baseline) | small | PARTIAL | "Mathlib gap" |
| 147 | 5 → 5 (closed β-core + 2 partials) | moderate | PARTIAL | "Mathlib gap" |
| 148 | 5 → 5 (NET 0) | +77 LOC | PARTIAL | KDM char-0 bridge; substep-3 flat base change |
| 149 | 5 → 9 (NET +4, planner-authorised 4-claim decomposition) | +470 LOC (new file ChartAlgebraS3) | PARTIAL (structural) | flat base change of Γ no Mathlib base |
| 150 | 9 → 9 (NET 0) | +194 LOC (ChartAlgebra) + ~90 LOC (ChartAlgebraS3) | PARTIAL | consumer-compatibility wall on signature inflation; "Mathlib gap" |

Notes on iter-150 specifically:
- KDM (BR.5) `mem_range_algebraMap_of_D_eq_zero`: moved from "structured sorry
  only" → "FREE-CASE + extraction + lift + functoriality CLOSED; only the
  transfer step is a structured sorry" (substantive infrastructure deposit,
  ~120 LOC of closed helpers). The iter-150 review states closing the transfer
  step (~30 LOC, helpers pre-staged) yields **guaranteed strict NET sorry
  reduction** independent of any user gate.
- (S3.sep.*) HYBRID CharZero collapse: attempted-and-blocked by a
  consumer-compatibility wall (signature inflation impossible without an
  upstream cascade). One new closed helper landed
  (`Algebra.IsSeparable.of_finite_of_perfectField`).
- (S3.pi.1), (S3.pi.2): HYBRID-DEFERRED (gated on an unanswered user question
  about adding `[IsAlgClosed kbar]`; user did not reply, so fallback = NO).

### Prior verdict
iter-150 progress-critic returned **CHURNING on Route C** (4 consecutive
PARTIAL iters); corrective fired = mathlib-analogist cross-domain consult
(→ HYBRID pivot). iter-150 prover lane executed the HYBRID-trimmed scope but
landed 0 NET sorry reduction.

### This iter's prover-objectives proposal
The plan agent proposes a SINGLE prover lane this iter:
- `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` — close ONLY the KDM (BR.5)
  transfer step (the iter-150 deposited helpers `_mvPoly_mem_range_C_of_D_eq_zero`,
  `_hFunct` are pre-staged; ~30 LOC via `ker_map_of_surjective` unfolding +
  Leibniz iteration, OR ~10–20 LOC via `subsingleton_h1Cotangent` abstract
  bypass). This is the iter-150-review-flagged "guaranteed NET reduction"
  target. No other lanes; (S3.*) and hPI are NOT proposed this iter (the iter
  is otherwise spent on a user-directed references/blueprint/strategy
  overhaul).

Judge: is one more prover round on the KDM (BR.5) transfer step CONVERGING, or
is this CHURNING that should instead pivot? Name the corrective TYPE if not
CONVERGING.
