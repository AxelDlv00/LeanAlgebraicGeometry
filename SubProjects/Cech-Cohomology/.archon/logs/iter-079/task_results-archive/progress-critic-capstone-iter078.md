# Progress Critic: capstone-iter078
**Iter:** 078

## Routes

- **`CechToHigherDirectImage.lean` (consumer) + `CechTermAcyclic.lean` (producer)**: **CONVERGING**.
  - Sorry trajectory: 3×COMPLETE (074–076) → PARTIAL/0-close iter-077 (cause: parallelism mid-sig-change, fully diagnosed) → producer DONE (0 sorries, clean build, iter-078 ground-truth). Consumer file already has full assembly written (no `sorry` in body); only defect is a type error at L207 from the old signature (missing `[S.IsSeparated]`+`hres`). Single-line fix + re-verify.
  - Helpers iter-077 (~18): all structural (restrict-over bridge + `mapAlternatingCofaceMapComplexIso`). They landed and are used in the current consumer file. Not churn — one-time infra cost, not repeated.
  - PARTIAL pattern: only 1 of last 5 iters is PARTIAL, and it has a clear single-cause diagnosis (process error, not mathematical). CHURNING requires ≥3 PARTIAL. Not triggered.
  - Planner's single-lane call: correct. Producer is frozen-done (not a dispatch candidate). Parallelism was the iter-077 failure; reverting to single lane is the right lesson applied.

## Dispatch Sanity

- **Verdict**: OK. 1 file dispatched, 1 file ready (`CechToHigherDirectImage.lean`); producer is frozen-done, not dispatchable. No under-dispatch gap.

## Throughput

- `Iters left` from strategy: ~1 (current remaining estimate). Capstone leaf started iter-077; this is iter-078 = 1 iter elapsed on the capstone proper. On schedule for the remaining-iters estimate.
- Phase P5b has been active since iter-067 (~11 elapsed), but the capstone was not the active leaf for most of those iters (CSI + CechAugmented were the active leaves). No throughput inflation signal specific to the capstone.

## Must-fix-this-iter

*(none — route CONVERGING)*

## Overall

- 1 route audited, 0 CHURNING/STUCK, 0 avoidance findings, dispatch=OK. Single-lane consumer dispatch is correct; expected to close in this iter.
