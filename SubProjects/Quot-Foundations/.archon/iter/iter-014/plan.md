# Iter 014 — Plan (Quot-Foundations)

## TL;DR

First prover iter after the iter-013 DAG cleanup. Entry state: build GREEN, sorries FBC 5 / GF 5 /
QUOT 4 / GR **0 (DONE)**; blueprint fully reviewed PASS at iter-013. The leandag "ready frontier"
(4 nodes) is misleading — all four are forward-declarations gated on substantial sub-builds, so the
genuinely-dispatchable proof work is the open sorries in GF and FBC. **All three mandatory critics
fired hard:** progress-critic = **CHURNING ×3** (GF, FBC, QUOT); strategy-critic = **CHALLENGE** on
FBC + QUOT (GF SOUND), format DRIFTED. The decisive moves this iter were the two **mathlib-analogist**
consults, which converted the two hardest walls into concrete recipes: FBC's "no Mathlib idiom /
confirmed dead end" was **false** — `unit_conjugateEquiv_symm` states the unit transport abstractly
(4-move recipe `analogies/fbc-mate.md`); QUOT's graded-API was **mis-scoped** as Mathlib-absent —
`HomogeneousSubmodule`/`QuotSMulTop` already exist, shrinking it to a thin G1–G5 wrapper. Dispatched
**2 hard-must-close prover lanes** (FBC Seam 1 via the idiom; GF reindex via top-level helper
factoring) and **set up QUOT** (graded-API blueprint written+cleaned) with an **unconditional iter-015
QUOT prover commitment**. All five strategy-critic CHALLENGES were addressed in STRATEGY.md.

## State at entry

- iter-012 = 4-lane prover iter (GR-cells CLOSED; FBC section_identity decomposed into 3 seams +
  inner_value proven; GF reindex hard-finiteness landed but 1 sorry; QUOT power-series engine, 8
  decls). iter-013 = DAG-only (44 helpers blueprinted → 0 `lean_aux`; reviewer PASS).
- Sorries (verified): FBC 5 (Seam1 ~1010, Seam2 ~1091, Seam3 ~1136, affine-reduction ~1309, FBC-B
  ~1331); GF 5 (L4 ~516, reindex ~1016, L5 ~1101, genFlatAlg ~1168, genFlat ~1235); QUOT 4
  (downstream-blocked stubs); GR 0.

## Critic dispositions

- **progress-critic `iter014` — CHURNING ×3, DONE ×1; dispatch=OK.** GF CHURNING (sorry 5→5→5, 3
  consecutive PARTIAL; corrective = top-level (a)–(e) helper factoring, the prover's own lesson;
  hard must-close, else iter-015 escalates to a Mathlib-analogy consult on
  `IsLocalization.algEquivOfAlgEquiv`/`IsLocalizedModule` descent). FBC CHURNING (conjugateEquiv wall
  2 prover iters old; corrective = analogist consult BEFORE the prover, then close Seam 1; hard
  must-close, else STUCK → user escalation). QUOT CHURNING (3 consecutive zero-dispatch iters;
  corrective = analogist API file + **unconditional iter-015 prover commitment**). 2-lane dispatch
  judged correct; the two walls are distinct with distinct correctives.
- **strategy-critic `iter014` — CHALLENGE (FBC, QUOT); GF SOUND; format DRIFTED.** All Mathlib
  prerequisites verified present (no phantoms). FBC: the mate coherence is RELOCATED-not-eliminated
  and the relocated form was described as stalled — test the two cheaper routes (drop-the-mate if
  merge-back permits; use `conjugateEquiv` + `conjugateEquiv_apply_app` not the opaque iso wrapper).
  QUOT: `def:sectionGradedRing` (goal-required via SNAP S1/S3) has no phase row; RelativeSpec
  `RepresentableBy` needs a chosen route; graded-API mis-scoped (`HomogeneousSubmodule`/`QuotSMulTop`
  exist). All addressed (see Prior critique status).
- **mathlib-analogist `fbc-mate` — ALIGN_WITH_MATHLIB.** `unit_conjugateEquiv_symm` +
  `comp_unit_app`; 4-move recipe reduces Seam 1 to one project-local `gammaPushforwardIso` identity,
  no elements. `homEquiv_unit`/`leftAdjointUniq` answered NO (wrong shape).
- **mathlib-analogist `graded-api` — NEEDS_MATHLIB_GAP_FILL.** Mathlib has the scaffold
  (`HomogeneousSubmodule`, `QuotSMulTop`, `Ideal.homogeneous_span`, rank-nullity,
  `restrictScalars_of_surjective`); absent = the gradings/regrade/finiteness-transfer (G1–G5). The
  avoidance route (D5 only) does NOT collapse the build (the IH on C,K over R/(x) still needs G1–G5).
  Build order G1→G2→G5→G3→G4→assembly.

## Decision made

### 1. Dispatch 2 hard-must-close prover lanes (FBC Seam 1, GF reindex); QUOT prover → iter-015
- **Why:** the two walls now have concrete recipes (FBC the found idiom; GF the helper-factoring
  with the verified (e)-descent glue `IsLocalizedModule.linearEquiv`). QUOT's residual is a fresh
  multi-lemma sub-build needing a blueprint first — set it up this iter, dispatch the mathlib-build
  next iter (progress-critic explicitly accepts this IF iter-015 is committed unconditionally).
- **Reversal signal:** a 2nd consecutive PARTIAL on FBC Seam 1 *with the idiom in hand* → the
  `conjugateEquiv` route is genuinely STUCK → pivot to the merge-back-necessity check (define the
  comparison as `regroupEquiv` if merge-back permits). A 2nd PARTIAL on GF reindex → iter-015
  mathlib-analogist consult on the localization-module descent diamond.

### 2. FBC route — pursue the found idiom (route b), keep merge-back check as the fallback (route a)
- **Why:** strategy-critic's route (a) "drop the mate identification" is highest-leverage but
  depends on whether the parent consumes the *fixed* geometric map (then seams unavoidable) or just
  "∃ iso" (then `regroupEquiv` suffices). The analogist made route (b) cheap and concrete THIS iter,
  so we execute (b) now; (a)'s merge-back check is the named iter-cap fallback (recorded as the sole
  live FBC open question). This is the strategy-critic's requested "iter cap + named fallback."

### 3. QUOT graded-API — thin wrapper over existing Mathlib, NOT from scratch
- **Why:** strategy-critic + analogist both found `HomogeneousSubmodule`/`QuotSMulTop`. Re-scoped the
  blueprint and STRATEGY accordingly; the build shrinks to G1–G5 grading/regrade/finiteness instances.

## Prior critique status (strategy-critic `iter014` — all addressed in STRATEGY.md)

- FBC framing (no-idiom/dead-end) → **fixed**: idiom named, element-chase identified as the dead end,
  abstract route stated; iter-cap + merge-back fallback recorded.
- `def:sectionGradedRing` unbudgeted → **fixed**: added a budgeted `SNAP-S1/S3` phase row.
- RelativeSpec `RepresentableBy` undecided → **decided**: STRENGTHEN via `representableByEquiv`
  (re-opening the 2 RelativeSpec proofs is in QUOT-repr's scope/estimate).
- SNAP graded-API mis-scoped → **fixed**: re-scoped onto `HomogeneousSubmodule`/`QuotSMulTop`; G1–G5.
- Format DRIFTED → **fixed**: removed both `(strategy-critic iter-012)` parentheticals + the
  decision-history prose from `## Routes`; trimmed FBC-A/SNAP table cells; added a `## Completed`
  table (RegroupHelper, GR-cells, SNAP-S2 engine, P1 predicates).

## Subagent skips

- **blueprint-reviewer:** skipped — the two prover-active chapters this iter (Cohomology_FlatBaseChange,
  Picard_FlatteningStratification) are UNEDITED since iter-013's whole-blueprint review (verdict PASS,
  both `complete:true`+`correct:true`, no live must-fix; the 2 FBC INFO flags are non-blocking
  sync/`\uses` cosmetics). The QUOT chapter WAS edited (graded-API writer + clean) but QUOT is NOT a
  prover lane this iter — its mathlib-build is committed iter-015 and will be gated by iter-015's
  mandatory whole-blueprint review. HARD GATE satisfied for both dispatched lanes from the iter-013
  verdict; no fast-path needed.

## Notes

- No LLM API key in env (`DEEPSEEK/MOONSHOT/OPENROUTER/OPENAI/GEMINI` unset) — analogist consults +
  Mathlib search substituted for `archon-informal-agent.py` (no tool substitution needed beyond that).
- GF is the 4th prover iter in phase GF-alg (estimate 2–4) — at the ceiling; if it doesn't close,
  the estimate goes OVER_BUDGET and iter-015 revises it up.
