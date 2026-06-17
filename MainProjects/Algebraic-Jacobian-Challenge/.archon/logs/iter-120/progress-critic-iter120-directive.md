# Progress-critic directive (iter-120)

Fresh-context audit of recent progress on the single active route.
Verdict: CONVERGING / CHURNING / STUCK / UNCLEAR.

You MUST NOT read STRATEGY.md, blueprint chapters, or iter sidecars'
full content. Only the signals below.

## Active route

`smooth_locally_free_omega` in `AlgebraicJacobian/Differentials.lean`
(forward smoothness criterion: smooth → locally free Ω of correct
rank on affine charts).

## Per-iter signals (window iter-115 → iter-119)

| Iter | sorry-count on `Differentials.lean` | Helpers added on file | Prover status | Recurring blocker phrase |
|------|-------------------------------------|------------------------|---------------|--------------------------|
| 115  | 5 | 0 | (no prover lane on this file; project-wide focus on `BasicOpenCech`/`Cohomology`) | — |
| 116  | 5 | 0 | (no prover lane on this file) | — |
| 117  | 1 (trim — 4 deleted as orphan to protected chain) | 0 (refactor) | n/a (trim iter) | — |
| 118  | 1 (signature refactored iff → forward) | 0 (refactor) | n/a (refactor + blueprint iter) | — |
| 119  | 1 (sorry RELOCATED L93 → L136 inside a structured cascade `constructor / all_goals first | exact hfree | exact hrank | sorry`) | 0 (no new declarations, just ~45 LOC of body content) | PARTIAL | "presheaf vs appLE algebra source-ring mismatch — colimit ring `((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V₀)` strictly larger than `Γ(S, U₀)` in general; Step-5 'definitionally equal to Ω[B/A]' claim is WRONG at the Lean level" |

## What's load-bearing about iter-119

The prover landed Steps 1–5 of a verified 5-step Mathlib chain
verbatim (~45 LOC of real algebraic content) and emitted exactly one
structurally-minimal residual `sorry` inside a `constructor / all_goals
first | ... | sorry` cascade. The residual sits at a SPECIFIC named
gap: the bridge between the appLE-algebra Kähler module
`Ω[Γ(X,V)⁄Γ(S,U)]` and the inverse-image-presheaf Kähler module
`(relativeDifferentialsPresheaf f).presheaf.obj (.op V)`.

The iter-119 review's recommendations CRITICAL #1 proposes a project-
local helper `relativeDifferentialsPresheaf_iso_kaehler_appLE` with
estimated cost 50–150 LOC.

## Specific anti-pattern flags to evaluate

- **Helper-churn**: Were the iter-119 ~45 LOC of body content
  "helpers without payoff" or "real algebraic content that lands the
  Mathlib chain"? My read is the latter (Steps 1–5 are not helpers,
  they're the actual proof). Cross-check.
- **PARTIAL-streak**: How many consecutive PARTIAL prover statuses on
  this route? My read: 1 (iter-119 is the first PARTIAL on the
  iter-118-refactored signature). Pre-iter-118 PARTIAL counts on the
  same DECLARATION-NAME are not load-bearing because the declaration
  was refactored at iter-118.
- **Recurring iter-115 affine-basis-bridge blocker**: did the iter-119
  PARTIAL re-introduce that blocker? My read: NO — the iter-115 blocker
  was on a different (deleted at iter-117) declaration and concerned
  "unique-gluing on affine basis", not "presheaf-vs-appLE source-ring
  colimit". The iter-119 blocker is a NEW finding on a DIFFERENT
  construction.

The iter-119 progress-critic committed four watch criteria for iter-120
(reproduced for your reference):
1. iter-120 helper lane COMPLETE → CONVERGING (retroactive).
2. iter-120 PARTIAL with same colimit-source-bridge blocker recurring
   → CHURNING; corrective = `mathlib-analogist` on the helper.
3. iter-120 INCOMPLETE with a fundamentally new blocker → STUCK; route
   pivot (consider re-statement of `smooth_locally_free_omega`).
4. iter-120 INCOMPLETE with iter-115 affine-basis-bridge blocker
   recurring → STUCK; primary corrective = route pivot + strategy-
   critic re-dispatch mid-iter.

## Your verdict shape

Per the route above, render a verdict of CONVERGING / CHURNING / STUCK
/ UNCLEAR. For STUCK or CHURNING, name the corrective.

This is a single-route audit; do NOT re-litigate the iter-118
axiomization challenge (the rebuttal stands; the foundational hypothesis
`nonempty_jacobianWitness` is off-limits to this audit).

## Output

Write a single `task_results/progress-critic-iter120.md` report.
