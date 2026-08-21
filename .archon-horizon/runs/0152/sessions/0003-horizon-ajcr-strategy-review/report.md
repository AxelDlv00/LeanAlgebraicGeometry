## Progress

- Reviewed both binding PDFs, I-0074, and the live I-2020 thread. Project Lean source was not modified.
- Acceptance matrix is recorded in the [Rebuild README](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md):
  - `canonicalRankOneAbelIso` directly feeds `pic0_sepClosed_representableBy`; rooted and standard-three axioms.
  - `pic0_sepClosed_representableBy` feeds the same-carrier `picRepDatumSepClosed`, then `jacobianDataSepClosed`; all remain conditional on `IsSepClosed`.
  - Finite-Galois `RepresentableBy`/PicRep/JD declarations bind `(rep : ...)` and orbit/projectivity hypotheses, so they are consumers.
  - No arbitrary-field `pic0_representableBy` exists; `Challenge.Jacobian` has no `JacobianData` consumer and still includes `sorryAx`.
- Run 0149 classification from baseline `3b3ac81f3a` through implementation commit `340206c19e`: 266 commits, 120 Lean-touching, 146 metadata/churn; 0 acceptance edges, 82 consumed prerequisites, 10 conditional consumers, 11 compile/performance splits, 163 metadata/churn. The later ledger tail through `1e344a199f` is metadata-only.
- Rebuild graph: 1,143 modules, 3,105 local edges, 1,109 root-reachable, 34 unrooted, no syntactic cycles. The critical cone remains `GlueDataFace -> GluePackage -> PreSnd -> OverlapIsoSnd -> GluedComparison`. The sibling project has 388 modules, 10 unrooted, no cycles, and a separate `JacobianWitness` route rather than the requested carrier chain.
- The narrow compiled probe passed. Named route declarations report only `propext`, `Classical.choice`, `Quot.sound`; the Face theorem reports `propext`, `Quot.sound`. No full build was run by this review.
- The bounded top-PreSnd compile stopped after 1183.80s with exit 130 and no Lean diagnostic. It produced only the intermediate `GlueDataAssembly` artifact; top PreSnd, OverlapIsoSnd, and GluedComparison remain unverified.
- Review state and documentation were committed across the audit, hgraph, roadmap, task, and I-2020 updates, including `1e344a199f`, whose exact diff is metadata-only. The final janitor pass found I-2020 open/read, no unread conversations, and run 0149 still active.

## Issues

Measured blockers are the missing binder-free `RepresentableBy P.gluedOver`, exact-carrier projectivity/orbit evidence, arbitrary-field producer, and same-carrier `PicRepDatum -> JacobianData -> Challenge` handoff. The Challenge import boundary is acyclic but architecturally upward-facing. The one-lemma/PreSnd fragmentation is primarily compile engineering, not the headline correctness gate.

Inference: the strategy converges through rank-one Abel evaluation to the separably closed representer and same-carrier sep-closed datum, but not yet to the required arbitrary-field chain. Stop adding `(rep :)` wrappers, further rank-one refinements, unconsumed DivScheme routes, cosmetic consolidation, or graph reconciliation while runs are live.

## Why I Stopped

The review is partly advanced, not complete. Task `ajcr-strategy-review` remains `queued`; run 0149 (`pid 1203301`) is still active, so the review is intentionally not marked done.

## Next

1. Land and root-check a producer of the form  
   `pic0RepresentableBy_finiteStageGlue ... : (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver`, with explicit curve/base-change compatibility and natural `homEquiv`.
2. Prove exact-carrier `P.gluedMap.IsProjective` or `FiniteInAffine`, then the corresponding orbit-affineness instance.
3. Expose unconditional `pic0_representableBy`, reuse its exact `.1/.2` in `PicRepDatum` and `JacobianData`, and wire that same datum into `Challenge.lean`, with root imports, binder inspection, narrow checks, and `#print axioms`.

The exact successor checkpoint is any newer committed Lean delta plus fresh root/native evidence for `GluePackage -> PreSnd -> OverlapIsoSnd -> GluedComparison`; until then, keep the review queued.
