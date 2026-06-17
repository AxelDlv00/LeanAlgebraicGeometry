# Directive: progress-critic — slug `routec167`

## Active routes / files for iter-167

### Route C (genus-0 rigidity) — TWO Lanes this iter

#### Lane A: `AlgebraicJacobian/Genus0BaseObjects.lean`

Live-consumer scaffold closures: `gm_grpObj` (L400), `gmScalingP1` body (L437),
`gmScalingP1_collapse_at_zero` body (L452). Goal: discharge the 3 CRITICAL deferred items +
export product-stability + Proj-integrality instances Lane B consumes (`IsReduced (P1⊗Gm).left`,
`GeometricallyIrreducible (P1⊗Gm).hom`, `LocallyOfFiniteType (P1⊗Gm).hom`, `IsReduced P1.left`).

#### Lane B: `AlgebraicJacobian/AbelianVarietyRigidity.lean`

Helper hygiene: discharge the 5 `morphism_P1_to_grpScheme_const_aux` internal sorries
(L944/L949/L953/L1029/L1037) using Lane A's exported instances + `iotaGm` dominance lemma;
drop the 5 `-- TODO:` excuse comments at L943/947/952/1028/1034.

### Last K=4 iters' SIGNALS (per route)

K=4 iters: 163, 164, 165, 166.

**`Genus0BaseObjects.lean` (Lane A this iter)**

| Iter | sorry-count delta (file) | helpers added | prover status | recurring blocker phrases |
|------|-------|---------------|---------------|--------------------------|
| 163 | n/a (file didn't exist) | n/a | n/a (route-c decision iter, no file) | (none — STRATEGY commit iter) |
| 164 | n/a (file didn't exist) | n/a | n/a (hygiene-only AVR iter) | (none — base-case route RESOLVED but no scaffold yet) |
| 165 | 0 → 9 (new file, scaffold landed) | 4 main objects + 5 axiom-clean Mathlib-bridge instances + `projectiveLineBar_isProper` proven axiom-clean | PARTIAL (per plan target) | `Proj.fromOfGlobalSections` boilerplate; `GrpObj.ofRepresentableBy` deferred |
| 166 | 9 → 6 (closed 3 ℙ¹-points axiom-clean) | shared `pointOfVec` helper; `irrelevant_map_eq_top` helper | PARTIAL (per plan target — closed 3 HIGH, deferred 3 CRITICAL + 3 OPT-IN) | "`GrpObj.ofRepresentableBy` + `IsLocalization.Away`-Spec representable-by witness — substantial sub-build"; "`Scheme.Cover.glueMorphisms` over 2-chart cover — substantial chart-level construction" |

**`AbelianVarietyRigidity.lean` (Lane B this iter)**

| Iter | sorry-count delta (file) | helpers added | prover status | recurring blocker phrases |
|------|-------|---------------|---------------|--------------------------|
| 163 | -1 (Cor 1.5 + Cor 1.2 from Rigidity Lemma) | none | COMPLETE | (none) |
| 164 | 0 (hygiene-only — signature trims) | none | COMPLETE | (none — chapter HARD GATE clear, demoted Thm 3.2 / cube / etc.) |
| 165 | 0 (sister file landed, no AVR edits this iter) | none | (no AVR lane this iter) | (none) |
| 166 | 3 → 6 (3 scaffold sorries replaced by 6 inline aux sorries — but proof STRUCTURE landed for both refactored theorems) | private helper `morphism_P1_to_grpScheme_const_aux` (~100 LOC, 5 internal sorries); outer body of `morphism_P1_to_grpScheme_const` sorry-free; iso-transport body of `rigidity_genus0_curve_to_grpScheme` sorry-free | PARTIAL (per plan target — refactor + outer bodies landed; aux residuals + RR-bridge deferred) | "product-stability for `(ℙ¹⊗Gm)` over alg-closed base"; "`IsReduced ProjectiveLineBar.left` not packaged by Mathlib for `Proj`"; "`IsDominant iotaGm.left` blocked on Lane A `gmScalingP1` body" |

### STRATEGY estimate (per `Phases & estimations` row "genus-0 rigidity")

- Iters left (current): **~5–12**
- Phase entered: iter-152 (current shape — concrete ℙ¹/Gm scaffold + 𝔾_m-scaling shortcut landed iter-164/165). Elapsed under the current shape: 13 iters (152 → 165). Elapsed since `Genus0BaseObjects.lean` landed: 1 iter (165 → 166).
- LOC trajectory: G0BO 0 → ~390 (iter-165) → ~463 (iter-166); AVR 1024 → 1186 (iter-166 added ~100-LOC aux). Realized velocity ~30–80 LOC/it.

### iter-167 PROGRESS.md `## Current Objectives` proposal

2 files (≤10 dispatch cap, well-within).
1. `AlgebraicJacobian/Genus0BaseObjects.lean` (Lane A — CRITICAL closure + product-instance export)
2. `AlgebraicJacobian/AbelianVarietyRigidity.lean` (Lane B — aux helper closure + TODO-comment hygiene)

Lanes file-disjoint; Lane B's `IsDominant iotaGm.left` discharge depends on Lane A's `gmScalingP1`
body, but within-iter sequential timing in a single prover lane on Lane B is acceptable since
once Lane A commits Lane B can `infer_instance`/cite directly.

## Question for you

CONVERGING / CHURNING / STUCK / UNCLEAR per lane, with corrective TYPE if not CONVERGING. Pay
particular attention to:

1. Is `Genus0BaseObjects.lean`'s trajectory CONVERGING (3 ℙ¹-points axiom-clean iter-166 +
   3 CRITICAL items + product instances scheduled iter-167) or CHURNING (each iter adds
   structure but the LIVE-consumer sorries `gm_grpObj` / `gmScalingP1` keep deferring)?
2. Is `AbelianVarietyRigidity.lean`'s "PARTIAL → 6 aux sorries" pattern a structural advance
   (refactor + outer-body landed) or a regression (3 scaffold sorries became 5 aux sorries)?
3. Is 2 lanes the right count, or should iter-167 be a single-lane drill (e.g. Lane A only,
   defer Lane B to iter-168 once instances ship)?
4. Are the 3 CRITICAL G0BO items realistically closable in one iter, or should iter-167
   pick the 1-2 most tractable + scope the rest to iter-168?
