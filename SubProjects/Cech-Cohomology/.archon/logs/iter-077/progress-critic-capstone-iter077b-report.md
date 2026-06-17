# Progress Critic: capstone-iter077b
**Iter:** 077

## Routes

- **P5b capstone — Route-A (`CechToHigherDirectImage.lean` + `CechTermAcyclic.lean`)**: CONVERGING.
  - Sorry trajectory K=5 (iters 073–077): ~4→3→2→1→6. Iters 074–076 each closed real sorries (PARTIAL / COMPLETE / COMPLETE). Iter-077 net +5 is strategic scaffolding of the correctly-stated sibling `cech_computes_higherDirectImage_of_affineCover` in response to a concrete counterexample showing the frozen goal is provably false — NOT helper sprawl. The 5 new sorries are the actual last-mile targets; blueprint-reviewer confirmed proof sketches adequate; strategy-critic confirmed math sound for corrected statement.
  - Prover status: INCOMPLETE (tooling outage) → PARTIAL → COMPLETE → COMPLETE → NO PROVER (plan-only, mathematical necessity). No consecutive plan-only iters, no avoidance pattern.
  - Helpers: +2 (iter-074), +1 (iter-076), +0 (iter-077 prover helpers). No helper accumulation without closures — iters 074–076 all yielded closures.
  - Recurring blocker "build wall / exit-137" in 2 of last 5 iters (074, 076). Below STUCK threshold (3) but established pattern; provers should have `lake build` fallback ready.
  - Throughput: **OVER BUDGET** — 11 iters elapsed in assembly phase (since iter-066) vs current estimate "~2–3 iters left." The assembly phase consumed far more iterations than any original "~2–3" figure implied; strategy row estimate should be updated to reflect actual phase length.

## Dispatch Sanity
- **Verdict**: OK. 2 files proposed (`CechTermAcyclic.lean`, `CechToHigherDirectImage.lean`) = all closeable sorries in cone. Frozen sorry at `CechHigherDirectImage.lean:780` is correctly excluded (escalated to mathematician). No under-dispatch vs ready files; no over-cap.

## Must-fix-this-iter
- Throughput: OVER BUDGET (11 iters elapsed, "~2–3 left" current estimate). Update STRATEGY.md active-phase row to reflect actual elapsed count; do not let the gap silently compound into another 5-iter slip.

## Overall
- 1 route audited: CONVERGING; 0 CHURNING/STUCK verdicts; 0 avoidance findings; dispatch=OK. Proposed 2-file dispatch covers all closeable sorries and is the correct next step; the 5-sorry decomposition is genuine last-mile work, not a new helper-sprawl cycle.
