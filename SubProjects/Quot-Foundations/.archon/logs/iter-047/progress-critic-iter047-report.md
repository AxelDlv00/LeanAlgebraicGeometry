# Progress Critic: iter047
**Iter:** 047

## Routes

- **`FlatteningStratification.lean` (Route A — GF base case)**: **UNCLEAR**.
  - Sorry: 1 (genericFlatness, downstream/untouched) — unchanged across all 5 iters, but that decl is NOT the target; the base-case seam is a new decl that doesn't exist yet.
  - Data: iter-042–044 = different file; iter-045 = PARTIAL on locality half (2 decls done); iter-046 = 0 prover (deliberate blueprint-prep). Base-case sub-phase entered iter-046; zero prover runs on this lane.
  - Only 1 blueprint-prep iter since phase entry — below K-iter threshold for any verdict. Fresh lane; no churn signal.
  - Corrective: None. Proceed — iter-047 is the first prover dispatch; gather trajectory.

- **`SectionGradedRing.lean` (Route B — SNAP scaffold)**: **UNCLEAR**.
  - File does not exist. Zero prover history. Blueprint authored iter-046 (1 prep iter).
  - Completely fresh; < K iters of signal. Scaffold proposal is correct first action.
  - Corrective: None. Proceed.

- **`FlatBaseChange.lean` (Route C — FBC keystone)**: **CHURNING (avoidance)**.
  - Off-critical-path for 2 consecutive iters (iter-045 post-park, iter-046 untouched).
  - Re-engagement condition is "user steer" — no concrete metric, date, or trigger. This is indefinite deferral, not a plan.
  - Prior progress-critic endorsed managed-park, but the avoidance-pattern rule (≥2 consecutive off-critical-path + no re-engagement plan) fires verbatim.
  - Corrective: **Address deferred infrastructure** — either (a) formally close FBC in STRATEGY.md as out-of-scope (remove it from the goal cone if it's truly not needed), or (b) write a concrete re-engagement condition (e.g. "re-engage at iter-X if SNAP/GF land and budget allows"). "User steer" with no default is not a plan.

- **`QuotScheme.lean` (Route D)**: Closed. +2 axiom-clean, 0 new sorry. No assessment needed.

## Dispatch Sanity

- **Verdict: OK.** 2 files proposed, both fresh lanes (first prover dispatch), both blueprint-ready from iter-046 prep. Dispatch cap (default 10) not approached. No known files with complete blueprint chapters AND open sorries being withheld — QUOT P2 residue is "small" but not confirmed chapter-ready; FBC is managed-parked. Under-dispatch check: not triggered (no ≥3 ready-but-withheld files identified).

## Must-fix-this-iter

- Route `FlatBaseChange.lean`: CHURNING (avoidance) — formally close in STRATEGY.md or add concrete re-engagement trigger. "User steer" with no fallback is indefinite deferral.

## Overall

2 fresh lanes (UNCLEAR — proceed), 1 managed-park triggering avoidance-pattern (FBC: must close or commit to condition in STRATEGY.md), dispatch OK.
