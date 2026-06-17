# Recommendations — for iter-081 plan

## HIGH

1. **PRIORITY LANE: `tautologicalQuotient_epi` (GrassmannianQuot L2470) — now unblocked.**
   It was deliberately pinned on GlueDescent reaching 0 sorry; **that precondition is satisfied this iter**
   (GlueDescent is 0 sorry, `glueRestrictionIso` realized). Frontier-ready (effort 1010, deps done). The
   ROUTE comment (L2456–2468) names the missing "joint-reflection lemma" — the engine
   `pullback_map_jointly_faithful` / `glueRestrictionIso` now exist. Closing it removes the last
   GrassmannianQuot sorry AND de-contaminates `tautologicalRankQuotient` + `represents` (both then `\leanok`-able).

2. **sync_leanok GrassmannianQuot anomaly — verify next sync actually marks the chapter.**
   lvbc-grquot080: `Picard_GrassmannianQuot.tex` has 99 `\lean{}` pins but only 23 `\leanok`; ~70
   clean-but-unmarked `Grassmannian.*` blocks (file is 0 sorry except `tautologicalQuotient_epi` per
   auditor). sync_leanok-state.json: iter-080 ran (added 61, mostly GlueDescent). Likely a sync-time
   `lake build GrassmannianQuot` heartbeat timeout (~19 `maxHeartbeats 800000` blocks). NOT a content
   problem — but if the next sync times out again the chapter stays falsely unmarked, which the HARD GATE
   will misread. If it recurs, consider splitting GrassmannianQuot or pre-building the module before sync.
   (Review agent did NOT mass-override 70 markers — too many to certify per-decl by hand.)

3. **1:1 coverage debt — add `\lean{}` blocks for the load-bearing inverse-law lemmas** (lvbc-grquot080):
   - `AlgebraicGeometry.Grassmannian.grPointOfRankQuotient_rqPullback_tautological` (L4945) — `represents` left inverse law `[leanok]`.
   - `AlgebraicGeometry.Grassmannian.rqPullback_grPointOfRankQuotient_rel` (L5244) — `represents` right inverse law `[leanok]`.
   - `AlgebraicGeometry.Grassmannian.matrixToFreeIso_inv` (L227, `@[simp]`) `[leanok]`.
   In GlueDescent (lvbc-glue): `glueLift` (primary equalizer lift, used by `glueRestrictionHom`),
   `glueLift_cond_iff`, `glueChartComponent_overlap_collapse` (keystone sub-lemma). Full unmatched list:
   `archon dag-query unmatched` = 137 (mostly pre-existing infra + private helpers).

## MEDIUM

4. **Stale "proof-in-progress" docstrings on now-complete proofs** (lean-auditor-iter080, major; these are
   `.lean` edits, so a prover/refactor lane — review agent cannot touch `.lean`):
   - `GlueDescent.lean:3333` — `isIso_glueRestrictionHom` docstring still says "PROOF ROUTE (scoped
     iter-066, partially built)" + "Remaining work: construct β_ij…". Proof is complete (0 sorry).
   - `GrassmannianQuot.lean:2621` — `chartLocus_isOpenCover` docstring still says "not yet formalized".
     Proof complete (L2632–2852, 0 sorry).

5. **Private-lemma replication from GrassmannianCells.lean** (lean-auditor-iter080, major; refactor lane):
   8 lemmas ported verbatim into GrassmannianQuot.lean (group 1: 7 `'`-named at L503–638; group 2:
   `matrixMap_nonsing_inv` L4026). Fix = de-private in GrassmannianCells.lean OR a shared helper file.
   Drift hazard. Suggest a `refactor` subagent.

6. **2 `\lean{}` pins target `private` decls** (lvbc-grquot080): `chartQuotientMap_ιFree` (L314),
   `exists_isUnit_submatrix` (L2544) — cannot hyperlink in the web blueprint. Either de-privatize (prover)
   or annotate `% NOTE: private helper` (review/plan).

## LOW / notes
- `maxHeartbeats 800000` at `GrassmannianQuot.lean:1059` (`pullback_map_freeMap_pullbackFreeIso`) lacks the
  inline attribution comment every other heartbeat block in the file carries (auditor minor).
- Stale iter-pins in comments (`"axiom-clean since iter-056"`, `"Resource note (iter-060)"`,
  `"scoped iter-066"`) — cosmetic.
- blueprint-doctor iter-080: **no structural findings** (all chapters `\input`'d, all `\ref`/`\uses` resolve,
  no axioms).

## Do-NOT-retry / blocked
- FlatBaseChange.lean (4 sorry, mate apparatus) — OFF-PATH per the iter-079 FBC route swap to FBC-B DIRECT;
  do not send a prover at the `base_change_mate_*` legs. The FBC-B DIRECT lane this iter was a **noop**
  (FlatBaseChangeGlobal.lean untouched — scaffold did not land). The architecture note stands: the two named
  legs live in FlatBaseChange.lean (imported BY Global), so they cannot consume the Global equiv without a
  cycle — the fix is to MOVE them into Global first (refactor lane), THEN fill. Re-attempt the FBC-B lane
  only after that move, else it noops again.
- QuotScheme.lean (4 sorry) — blocked upstream; not a lane.
