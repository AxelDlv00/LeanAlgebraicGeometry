# Progress Critic Directive

## Slug
route174

## Iteration
174

## Active routes & files

### Route 1 — genus-0 / `gmScalingP1` chain

**File:** `AlgebraicJacobian/Genus0BaseObjects.lean`

**Last 5 iters' signals (extracted by planner from review/task results):**

| Iter | Sorry on file | Helpers added | Prover status | Recurring blocker phrases |
|---|---|---|---|---|
| 170 | 11 → 11 | 0 (API-500, lane died) | INFRA-FAIL | API Error 500 (lane never ran) |
| 171 | 11 → 13 (NET +2; body skeleton landed) | 3 named scaffold sorries factored out | PARTIAL-acceptable | "body skeleton landed on the load-bearing residual" |
| 172 | 13 → 12 (PRIMARY 1 only of 4 attacked) | `mvPolyToHomogeneousLocalizationAway_surjective` axiom-clean | PARTIAL-low | "chart-bridge specialisation" identified as bottleneck |
| 173 | 9 → 8 (PRIMARY 1 of 3 attacked) | `awayι_comp_PLB_hom` + `gmScalingP1_cover_X_iso` (both load-bearing, axiom-clean) | PARTIAL-low | "PRIMARY 2 + 3 deferred as top-level scaffold sorries with shared helper plan" |
| 174 plan | 8 → ? | proposed: `gmScalingP1_chart_PLB_eq` shared helper (~50-60 LOC) | (this iter) | iter-173 review explicitly recommends "close PRIMARY 2 + 3 via shared helper" |

**Strategy's current row (verbatim from STRATEGY.md L33):**
> Iters left: ~3–6
> LOC: ~100–170 · ~25/it

**Entered current phase at:** iter-170 (when `gmScalingP1` body lane was first dispatched).

**iter-174 planner proposal for this route:** Lane A continuation on `AlgebraicJacobian/Genus0BaseObjects.lean` to close PRIMARY 2 (`gmScalingP1_over_coherence`) + PRIMARY 3 (`gmScalingP1_chart_agreement`) via the shared `gmScalingP1_chart_PLB_eq` private helper described in the iter-173 task result.

### Route 2 — Picard A.1.a `RelativeSpec`

**File:** `AlgebraicJacobian/Picard/RelativeSpec.lean` (NEW iter-173)

**Last 3 iters' signals:**

| Iter | Sorry on file | Helpers added | Prover status | Recurring blocker phrases |
|---|---|---|---|---|
| 172 | (no file) | 0 (API-529, lane died) | INFRA-FAIL | API Error 529 (lane never ran) |
| 173 | 0 → 6 (file-skeleton landed) | `structureMorphism` helper | COMPLETE | "file FIRST landing"; "TYPE-level sorry on QcohAlgebra" (must-fix per auditor); "4 weakened-type encodings (UniversalProperty, affine_base_iff, base_change, functor) acknowledged scaffolds" |
| 174 plan | 6 → ? | proposed: body lane on `QcohAlgebra` (Mathlib-analogist consult first) OR refinement of UniversalProperty type | (this iter) | iter-173 review names "mathlib-analogist consult recommended first" |

**Strategy's current row (verbatim from STRATEGY.md L22):**
> Iters left: ~3–5
> LOC: ~200–400 · ~0/it (file-skeleton just landed, no body LOC yet)

**Entered current phase at:** iter-173 (file FIRST landing).

**iter-174 planner proposal for this route:** dispatch `mathlib-analogist` consult on `QcohAlgebra` structure first (api-alignment); defer body lane to iter-175 if analogist returns a structural recipe; alternatively skip Route 2 prover lane this iter to free budget for Lane A + new file-skeleton lanes.

### Route 3 — RR.1 `WeilDivisor`

**File:** `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

**Last 3 iters' signals:**

| Iter | Sorry on file | Helpers added | Prover status | Recurring blocker phrases |
|---|---|---|---|---|
| 172 | 0 → 6+1 (file-skeleton landed with `True` placeholder) | `Scheme.PrimeDivisor` (with `True := trivial` placeholder, lean-auditor must-fix) | COMPLETE | "True placeholder" flagged |
| 173 | 7 → 5 (`True` placeholder retired + `degree_hom` closed) | `degree_hom_apply @[simp]` bridge lemma | COMPLETE | "iter-174 lane options: ofClosedPoint or RationalMap.order" |
| 174 plan | 5 → ? | proposed: `ofClosedPoint` body via closed-point ↔ prime-divisor bridge | (this iter) | iter-173 review names `RationalMap.order` as heavier (DVR-extraction sub-build) |

**Strategy's current row (verbatim from STRATEGY.md L34):**
> Iters left: ~3–6
> LOC: ~300–500 · ~0/it (spec-refine landed; body work iter-173+)

**Entered current phase at:** iter-172 (file FIRST landing).

**iter-174 planner proposal for this route:** Lane D continuation, `ofClosedPoint` body via closed-point ↔ prime-divisor bridge (lighter than `RationalMap.order`).

### Route 4 — new file-skeleton lanes (Picard/LineBundlePullback, RiemannRoch/RRFormula)

**Files:** `AlgebraicJacobian/Picard/LineBundlePullback.lean` + `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (chapters landed iter-173; files do NOT yet exist; opening file-skeleton lanes).

**Strategy's current rows:** A.1.b row L23 `Iters left: ~2–4`; RR.2 row L36 `Iters left: ~3–5`.

**iter-174 planner proposal for this route:** open both as file-skeleton lanes per iter-173 PROGRESS.md `## Next iter (iter-174)` item 6.

## planner's PROGRESS.md `## Current Objectives` proposal for iter-174

5-6 prover lanes:
1. `AlgebraicJacobian/Genus0BaseObjects.lean` — Lane A continuation (close PRIMARY 2 + 3 via shared helper). [OR replaced by G0BO post-refactor target file if refactor lands this iter.]
2. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` — Lane D continuation (`ofClosedPoint`).
3. `AlgebraicJacobian/Picard/LineBundlePullback.lean` — NEW FILE file-skeleton (5 pins).
4. `AlgebraicJacobian/RiemannRoch/RRFormula.lean` — NEW FILE file-skeleton (4 pins).
5. (optional) `AlgebraicJacobian/Picard/RelativeSpec.lean` — body lane on `QcohAlgebra` IF analogist returns recipe in plan phase; otherwise deferred to iter-175.

## What I need

Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR). If any route is CHURNING or STUCK, name the corrective TYPE (blueprint expansion / Mathlib-idiom consult / structural refactor / route pivot / blueprint-writer for predecessor missing) and which subagent in my catalog implements it.

Dispatch-sanity: 5–6 prover lanes for iter-174, of which 2 are NEW file-skeleton lanes. Flag if any objective looks blocked by an unresolved upstream finding.

Also flag if Iters-left × realized/it does NOT match the proposed lane scope (throughput drift detection).
