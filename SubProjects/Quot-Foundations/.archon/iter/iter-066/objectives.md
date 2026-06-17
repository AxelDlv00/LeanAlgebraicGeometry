# Iter 066 — Objectives (per-lane detail)

## Lane 1 — GrassmannianQuot.lean (2 sorries)
- Target: `tautologicalQuotient` overlap condition (L1973) via the 4-piece rectangular recipe
  (matrixEndRect def+pullback → comp law → adjunction transposition → Cells matrix core), then
  `represents` (L2156) if budget remains.
- Recipe source: `.archon/logs/iter-064/task_results-archive/AlgebraicJacobian_Picard_GrassmannianQuot.lean.md`
  (the iter-064 prover's own decomposition) + blueprint `lem:gr_matrixEndRect*` chain (effort-breaker
  `tq-rect2`, landing this phase).
- iter-065 attempt: prover KILLED by wall-clock, no edits, no result; dispatched against stale
  iter-063 PROGRESS.md (rewrite never persisted). Not a math signal.

## Lane 2 — SectionGradedRing.lean (scaffold-dependent)
- Target: `ztensor_whisker_localIso` (feeder) → `isIso_sheafification_whiskerRight_unit` (crux).
- Pre-condition: `snap-crux3` scaffolder (this phase) lands the two sorry-bearing decls. 4th/5th
  re-attempt — iters 064 and 065 scaffolders were both killed pre-landing.
- Blueprint: `Picard_SectionGradedRing.tex` ~L716 + ~L961 (full 4-step proof block).

## Deferred (explicit)
- blueprint-writer gr-coverage (22 unmatched decls): write-race with effort-breaker on
  `Picard_GrassmannianQuot.tex` + wall-clock budget. First dispatch of iter-067 plan phase.
