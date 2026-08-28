## Progress

Completed the read-only AJCR strategy review and committed the findings.

- Acceptance matrix and run classification are recorded in the [Rebuild review README](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md).
- Updated [Phase 7](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.yaml), [base-change](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.base-change.yaml), and [Phase 8](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p8-jacobian.yaml) roadmap state.
- Updated the existing [I-2020 conversation](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/inbox/local/items/I-2020.yaml) and [strategy task](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/tasks/items/ajcr-strategy-review.yaml); no duplicate conversation was opened.
- Added graph reviews for the Rebuild acceptance nodes and an explicit sibling-route boundary in the AJC graph.
- Review metadata is committed through `a363d1d20d`; implementation evidence remains anchored at `340206c19e`.

Measured acceptance state:

| Edge | Result |
|---|---|
| `canonicalRankOneAbelIso` | Genuine producer; consumed by sep-closed representability; narrow axioms are the standard three |
| `pic0_sepClosed_representableBy` | Producer only under `[IsSepClosed k]`; exact carrier flows to `picRepDatumSepClosed` |
| `picRepDatumSepClosed` -> `jacobianDataSepClosed` | Same `J`/`rep`, narrow axiom-clean |
| finite-Galois / finite-stage wrappers | Consumers: explicit `(rep : ...)`, orbit/projectivity premises |
| `pic0_representableBy` | Absent |
| `Challenge.Jacobian` | No `JacobianData` consumer; `sorryAx` remains |

From baseline `3b3ac81f3a` through implementation checkpoint `340206c19e`: 266 commits, classified as 0 acceptance edges, 82 consumed prerequisites, 10 conditional consumers, 11 compile/performance splits, and 163 metadata/churn. The later tail is review/lifecycle metadata only.

## Issues

The strategy converges through canonical rank-one -> separably closed representer -> same-carrier sep-closed datum, but not through the required arbitrary-field chain.

The active continuation’s latest bounded build reached `9361/9370` and exited `124` at the 1800-second cap. It produced `Pic0FiniteStageTransitionModels.olean` and `Pic0FiniteStageTripleTransitionModels.olean`; `GluePackage`, top `PreSnd`, `OverlapIsoSnd`, and `GluedComparison` remain absent. This is prerequisite/compile-frontier evidence, not acceptance credit.

Correctness blockers are the missing binder-free `RepresentableBy P.gluedOver`, exact-carrier projectivity/orbit-affineness, original-field `pic0_representableBy`, and same-carrier handoff into `PicRepDatum -> JacobianData -> Challenge`. Cosmetic/engineering risks are separate: `Pic0CriticalPath.lean` is 1,120 lines with 87 imports, 34 modules were unrooted in the last source-root measurement, and graph caches report 752 stale Rebuild nodes and 281 stale AJC nodes.

## Why I Stopped

Run 0149 and continuation session 0104 are still live. The review task is intentionally `queued`, not complete. No Lean source was edited and no full build was started by this review; only narrow binder, `#print axioms`, and import checks were used.

The required protection I-0074 remains acknowledged. The janitor pass found intentional workspace warnings, including Horizon 0.1.2/0.1.3 drift and stale cleanup advisories; active-lane files and artifacts were preserved.

## Next

The next checkpoint must include:

1. `pic0RepresentableBy_finiteStageGlue ... : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver`, with explicit compatibility and natural `homEquiv`, no `(rep)` binder.
2. An exact-carrier `P.gluedMap.IsProjective` or `FiniteInAffine` theorem.
3. Original-field `pic0_representableBy`, then the same `J`/`rep` through `PicRepDatum`, `JacobianData`, and `Challenge.lean`, with fresh root imports and axiom evidence.
