# Progress Critic Directive

## Slug
route175

## Active routes / files the planner is considering for iter-175 prover dispatch

This iter is post-STUCK-trigger-arm on Route 1. The plan-phase will execute
the deferred G0BO split refactor (1143 LOC → 4 sub-files) as the structural
response. After split, Lane A would target the new `Genus0BaseObjects/GmScaling.lean`
file (where the chart_PLB_eq Step C + chart_agreement cross cases live) with
the analogist's chart-bridge structural pivot recipe. Other lanes:
- Lane B body on `Picard/RelativeSpec.lean` (5 sorries downstream of axiom-clean
  QcohAlgebra carrier).
- Lane D body on `RiemannRoch/WeilDivisor.lean` `RationalMap.order` (gated on
  DVR analogist consult landing this plan-phase).
- 7 file-skeleton lanes on the 10 iter-174 chapters (gated on scoped
  blueprint-reviewer HARD GATE clearing this plan-phase).

### Route 1 — genus-0 rigidity (`gmScalingP1` body chain)

Files: `AlgebraicJacobian/Genus0BaseObjects.lean` (post-split: 4 sub-files +
re-export shim).

Last 5 iters' signals:

- iter-170: progress-critic `routec170` — INFRA-FAIL (API-500). Reversal
  trigger did NOT fire.
- iter-171: PARTIAL-acceptable (body skeleton landed; 3 named scaffold sorries
  + 1 surjective helper).
- iter-172: PARTIAL-low. `mvPolyToHomogeneousLocalizationAway_surjective`
  landed axiom-clean (one substantive closure). progress-critic `route172`
  CHURNING; recommended body-first corrective.
- iter-173: PARTIAL-low. `gmScalingP1_chart` body axiom-clean via analogist's
  4-step `pullbackSymmetry ≫ pullbackRightPullbackFstIso ≫ pullback.congrHom ≫
  pullbackSpecIso` bridge. Helper count grew by 2 (`awayι_comp_PLB_hom` +
  `gmScalingP1_cover_X_iso`). progress-critic `route173` CHURNING.
- iter-174: PARTIAL-low. `homogeneousLocalizationAwayIso_algebraMap` axiom-clean,
  `gmScalingP1_chart_PLB_eq` Steps A+B axiom-clean (Step C blocked on Fin
  syntactic mismatch), `over_coherence` structurally closed (propagates sorry),
  `chart_agreement` diagonals closed (cross cases deferred). progress-critic
  `route174` CHURNING; mathlib-analogist consult + hard scope-discipline corrective.

Net sorry count over 5 iters: 8 → 8 (unchanged at the file level). Helpers
added each iter (chart-bridge + algebraMap + PLB_eq + cover_X_iso +
awayι_comp); none of the original 8 retired. **Fourth consecutive PARTIAL**.

STRATEGY.md row for genus-0 rigidity: `~3–6 iters / ~100–170 LOC remaining
· ~25/it`. Entered current phase iter-167 (8 iters ago).

Prior verdicts: CHURNING for iter-171/172/173/174 in sequence; STUCK
escalation trigger ARMED for iter-175 per iter-174 review.

### Route 2 — Picard A.1.a (`RelativeSpec.lean`)

File: `AlgebraicJacobian/Picard/RelativeSpec.lean`.

Last 3 iters' signals:

- iter-172: file dispatched, API-529 killed prover; no edits.
- iter-173: file FIRST-LANDED (260 LOC; 6 pinned declarations). COMPLETE on
  file-skeleton target.
- iter-174: Lane G `QcohAlgebra` Encoding I carrier refactor PROVEN
  axiom-clean. File sorry 6 → 5. COMPLETE per Lane G target.

Net sorry count: NEW file +5 (post-iter-174). Helpers added each iter ≤ 1.
STRATEGY.md row: A.1.a `~3–5 iters / ~200–400 LOC · ~0/it`. Entered current
phase iter-172.

Prior verdicts: UNCLEAR (iter-172, 173, 174).

### Route 3 — RR.1 (`WeilDivisor.lean`)

File: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`.

Last 3 iters' signals:

- iter-172: file FIRST-LANDED (file-skeleton). Lane C COMPLETE.
- iter-173: Lane D landed `PrimeDivisor` refactor (`coheight` field) +
  `degree_hom` axiom-clean. File sorry 6 → 5. COMPLETE per target.
- iter-174: Lane D `ofClosedPoint` body axiom-clean (junk-defined `if` branch
  + 2 bridge equation lemmas). File sorry 5 → 4. COMPLETE per target.

Net sorry count: NEW file → 4. Helpers added per iter ≤ 2 substantive.
STRATEGY.md row: RR.1 `~3–6 iters / ~300–500 LOC · ~0/it`. Entered current
phase iter-172.

Prior verdicts: UNCLEAR / CONVERGING (iter-172, 173, 174).

### Route 4 — newly-scaffolded file-skeleton lanes (iter-174 landings)

Files: `Picard/LineBundlePullback.lean` (NEW iter-174, 5 sorries),
`RiemannRoch/RRFormula.lean` (NEW iter-174, 3 sorries). Both COMPLETE on
file-skeleton target this iter.

This is a brand-new lane class; no longitudinal signal yet. Iter-175 will
open 7 more file-skeleton lanes (10 chapters from iter-174 plan-phase).

### Planner's PROGRESS.md `## Current Objectives` proposal for iter-175

Total = 10 lanes (at the dispatch cap):

1. `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (post-split target;
   chart_PLB_eq Step C + chart_agreement cross cases with chart-bridge
   structural-pivot analogist recipe).
2. `AlgebraicJacobian/Picard/RelativeSpec.lean` body lane (subset of 5
   downstream sorries).
3. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` `RationalMap.order` body
   (gated on DVR API analogist consult landing this plan-phase).
4. `AlgebraicJacobian/Picard/FlatteningStratification.lean` file-skeleton.
5. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` file-skeleton.
6. `AlgebraicJacobian/Picard/RelPicFunctor.lean` file-skeleton.
7. `AlgebraicJacobian/Picard/QuotScheme.lean` file-skeleton.
8. `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` file-skeleton.
9. `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` file-skeleton.
10. `AlgebraicJacobian/RiemannRoch/OCofP.lean` file-skeleton.

The 3 file-skeletons deferred to iter-176 are `Albanese/CodimOneExtension.lean`
(A.4.a — risk-dominant, complex), `Albanese/AlbaneseUP.lean` (A.4.d — pending
Sym^g writer re-dispatch THIS plan-phase), `RiemannRoch/RationalCurveIso.lean`
(RR.4 — gated on RR.3 spec + RR.1 body).

## Specific questions for the critic

1. Is the planner's structural action (G0BO split + analogist
   chart-bridge-structural-pivot consult) adequate to address the STUCK
   escalation arm, or is the verdict still CHURNING / STUCK?
2. Is the lane fan-out (3 body lanes + 7 file-skeletons) reasonable, or
   does it exceed the prover-throughput capacity given the iter-174 critic
   data?
3. Do you see any dispatch-sanity issues with the 10-lane list (overlapping
   files, missing HARD GATE check, etc.)?
