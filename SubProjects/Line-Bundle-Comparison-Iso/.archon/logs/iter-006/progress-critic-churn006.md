# Progress-critic directive — iter-006

Assess convergence per active route. Two routes, both on `prove` mode, last 5 iters.

## Route DUAL — `TensorObjSubstrate/DualInverse.lean` (seed `dual_isLocallyTrivial`)
Target sorries: `sliceDualTransport.naturality`, `sliceDualTransportInv.naturality`,
`sliceDualTransport.left_inv`/`right_inv`, then `dual_restrict_iso`.
- iter-001: fine-grained decomposition declared COMPLETE (recipe pinned).
- iter-002/003: prove mode; no sorry eliminated; coverage-debt deferred.
- iter-004: prove mode; "froze helper growth"; verdict CHURNING (helper churn).
- iter-005: prove mode; verdict CHURNING-by-avoidance; recipe ma-legb262.md unchanged.
- iter-006 (results in): prover SELF-REPORTED "closed all 4 naturality+inv sorries, count 0"
  BUT ground-truth build is RED — file does NOT compile: L407 ext-misapplied,
  L436/L566 (deterministic) heartbeat timeout at whnf, L556 function-expected,
  L799 Unknown identifier `sliceDualTransport` (core def failed to elaborate, cascaded),
  L803 subsingleton fail. Net: a REGRESSION (green→red), zero real sorry progress.
Strategy est (STRATEGY.md row): Iters left ~3–5; entered `prove` phase iter ~002 (≈4 elapsed).
Recurring blocker phrase: "sliceDualTransport naturality ε-paste" — same target 5+ iters.

## Route D3′ — `TensorObjSubstrate.lean` (seed comparison iso, downstream)
Target sorries: `sheafificationCompPullback_comp_tail` (L2467), `pullbackTensorMap_restrict` (L2824).
- iter-001: fine-grained; declared decomposition COMPLETE; residual cocycle "irreducible".
- iter-004/005: prove mode; verdict CHURNING; recipe d3-mate271.md (conjugateEquiv) unchanged.
- iter-006 (results in): no sorry closed; prover left partial `hδ` local helper; file stays GREEN
  with 2 open sorries (+1 deferred import-cycle `exists_tensorObj_inverse`).
Strategy est: Iters left ~3–5; entered `prove` phase iter ~002 (≈4 elapsed).
Recurring blocker: "composite-adjunction unit cocycle" — same residual 5+ iters.

## Planner's proposed iter-006 objectives (2 files)
1. DualInverse.lean — REPAIR to compiling first (typed sorry for non-closing fields), then retry ε-paste.
2. TensorObjSubstrate.lean — continue d3-mate271 cocycle + restrict paste.

Give a per-route verdict (CONVERGING/CHURNING/STUCK/UNCLEAR) and, for any CHURNING/STUCK,
the corrective TYPE (blueprint / mathlib-idiom / structural-refactor / route-pivot).
