# Iter 067 — Plan (Quot-Foundations)

## TL;DR
Iter-066 was the best iter of the project: SNAP crux `isIso_sheafification_whiskerRight_unit`
CLOSED axiom-clean (2→0, ULift-ℤ/`W.whiskerRight` route — stalk route never needed) and GR
`tautologicalQuotient` CLOSED + `represents` decomposed into 5 scoped sorries with ~350 LOC
proven descent infra (keystone `isIso_glueRestrictionHom` with full written route). This iter:
3 prover lanes — split the generic glue-descent layer into `GlueDescent.lean` (keystone lane) ‖
GrassmannianQuot Nitsure-inverse lane ‖ SNAP tensor-chain lane (scaffold-conditional).

## Prover results processed (iter-066)
- SNAP: COMPLETE — crux + feeder closed; helpers all private. → task_done.md.
- GR: MAJOR×2 — tautologicalQuotient closed (rect matrixEndRect chain), represents decomposed.
  → task_done.md. task_results cleared.

## Wave-1 subagents (dispatched ~minute 8, parallel)
- **refactor `split-glue-descent`:** move the `Scheme.Modules` glue/descent layer (L390–658 +
  L1233–2160) to NEW `Picard/GlueDescent.lean` — enables 2 parallel GR lanes (standing
  parallelism directive; clean semantic seam now that the descent layer is self-contained).
  Reverses the iter-065 no-split decision: that rationale (intra-iter import race on rect infra)
  no longer applies — the layer is generic, no Grassmannian deps, and wall-clock recovered.
- **blueprint-writer `gr-coverage2`:** the twice-deferred coverage-debt writer, scope grown
  22→~55 public decls (iter-064 + iter-066 helpers; glue layer + rect infra + reconciliation of
  effort-breaker pins + stale forward-decl NOTEs). Private SNAP ULift helpers EXCLUDED.
- **lean-scaffolder `snap-tensor`:** `tensorObjAssoc` + `tensorPowAdd` (+`sectionsMul_assoc_unit`
  if prerequisites exist) sorry-bearing in SectionGradedRing.lean, matching chapter pins.
- **progress-critic `iter067`:** GR UNCLEAR (decomposition spike, NOT churn; throughput gate:
  iter-067 must close ≥2 of 6 sorried decls or next iter reads CHURNING), SNAP CONVERGING,
  3-lane dispatch OK. Accepted — no corrective owed (UNCLEAR = proceed and watch).

## Planner edits this phase
- `Picard_SectionGradedRing.tex`: feeder block `lem:snap_ztensor_whisker_localIso` rewritten to
  the REAL statement (relative-tensor whiskering preserves J.W, not the ℤ-tensor stalkwise
  claim) + crux proof's stalkwise paragraph replaced by the feeder-based route (prover-flagged
  blueprint drift; the formalized route is Day-reflection whiskering + coequalizer descent).
- STRATEGY.md: GR-quot + SNAP-S0 rows refreshed (crux closed, decomposition, split), SNAP route
  paragraph updated, C2 open-question replaced by keystone fallback note. No route/phase change.
- task_done.md iter-066 entry; task_pending.md rewritten; TO_USER.md: wall-clock bullet PRUNED
  (iter-066 sessions ran 27+ min and completed — kill streak over), added leandag-counts-private
  quirk to the loop-infra bullet.

## Decisions made
1. **GR file split EXECUTED (reverses iter-065 deferral).** Trigger conditions met: seam is now
   semantic (generic descent layer), no same-iter producer/consumer race, wall-clock recovered.
   Reversal signal: if the split breaks cold build or the refactor aborts on a hidden cyclic dep,
   fall back to single GR lane this iter and do not re-attempt without restructuring.
2. **SNAP chapter fixed by planner, not writer** — small two-block surgical edit; a writer
   dispatch would have raced the scaffolder reading the same chapter.
3. **Coverage-debt writer scope = public decls only.** The ~30 private SNAP helpers stay
   unblueprinted (implementation details per the private-exemption rule); the scan counting them
   is a loop-infra quirk (TO_USER).

## Subagent skips
- strategy-critic: STRATEGY.md edits are status/factual refresh only (milestones closed, no
  route swap / phase split / goal change); prior verdict SOUND with no live CHALLENGE; matches
  iter-058→066 precedent.
- blueprint-reviewer: dispatched LATE-PHASE (after writer lands) if wall-clock allows — see
  "Reviewer gate" below; if it cannot run, next iter's mandatory dispatch re-gates. Rationale
  for dispatching provers regardless: identical to iter-066 decision 1 — this iter's GR chapter
  edits (coverage blocks) describe Lean decls that are ALREADY proven/scoped on-disk, and the
  SNAP edit aligns prose to a CLOSED axiom-clean proof; content risk minimal vs. losing a
  3-lane prover round.
- blueprint-clean: queued AFTER the gr-coverage2 writer returns (same-iter if wall-clock allows,
  else first dispatch next iter) — same file-corruption-risk logic as iter-066.

## Reviewer gate
GR + SNAP chapters were "complete:false/correct:false" in the iter-066 FULL review, but per that
report's own lane-status routing these verdicts track open targets, not blueprint inadequacy —
it explicitly routes provers at both lanes (keystone first; crux first). The iter-066 planner
precedent applies; the open-target blocks all carry complete informal proofs.

## Reports collected
(filled at phase end — refactor / writer / scaffolder / reviewer outcomes + final objective set)
