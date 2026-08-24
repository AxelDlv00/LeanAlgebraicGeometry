# AJCR Human Mathematician Review Packet

**Snapshot:** 2026-08-24, workspace ledger `16de23f3d5`  
**Projects:** `Algebraic-Jacobian-Challenge-Rebuild` (AJCR) and the shared AJC engine  
**Purpose:** give a human mathematician a short, auditable account of what is proved, what is only conditional, and what is blocking the Jacobian theorem.

This is a review packet, not a completion claim. The central question is whether the current finite-descent route can produce an unconditional original-field Picard-zero representer, or whether the route must change.

## Executive Diagnosis

The rank-one and separably-closed parts are genuine and kernel-clean. The requested arbitrary-field capstone is not present. Most recent work has built prerequisites and conditional consumers, while the two decisive bridges remain open:

1. a binder-free finite-stage `RepresentableBy`/Yoneda equivalence for the glued carrier;
2. exact-carrier projectivity or finite-in-affine control of the finite Galois orbit.

The compile chain needed to test those bridges is also not certified. This is why many sessions produced commits without moving the headline theorem.

## Acceptance Matrix

| Edge | Current status | What is actually available | What a reviewer should verify |
| --- | --- | --- | --- |
| `canonicalRankOneAbelIso` | **Proved producer** | Rank-one divisor locus is identified with the rank-one Picard locus over the base field; narrow axioms are `propext`, `Classical.choice`, `Quot.sound`. | Is the carrier and Abel inverse the intended one for the later descent? |
| `pic0_sepClosed_representableBy` | **Proved, sep-closed only** | Produces `J` and `RepresentableBy J` under `[IsSepClosed k]`; the exact `J`/`rep` flows into `picRepDatumSepClosed`. | Does this theorem expose precisely the data needed for descent, without hidden choice of a different carrier? |
| `picRepDatumSepClosed` -> `jacobianDataSepClosed` | **Proved, sep-closed only** | Same-carrier datum and Jacobian data are assembled. | Is the same-carrier handoff strong enough to survive field descent? |
| finite-Galois / finite-stage wrappers | **Conditional consumers** | They take an explicit `(rep : ...)` and often `OrbitsInAffineOpen` or projectivity hypotheses. | Do not count these as representability producers. Can those hypotheses be proved for the exact glued carrier? |
| finite-stage glued carrier | **Compile frontier** | Source exists, but native artifacts are missing along `GluePackage -> GluingDiagramIso -> PreSnd -> OverlapIsoSnd -> GluedComparison`. | Can the declarations elaborate within a bounded resource budget and remain root-reachable? |
| `pic0_representableBy` | **Missing producer** | No unconditional original-field `RepresentableBy` theorem is available. | Is there a valid construction from the finite-stage package, or is a standard Picard representability theorem needed instead? |
| `Challenge.Jacobian` | **Missing capstone handoff** | The statement boundary is root-imported, but no original-field `JacobianData` consumer is wired in and `sorryAx` remains. | Can the same `J` and `rep` be transported all the way into `Challenge.lean` without an import cycle? |

## Critical Path

```text
canonicalRankOneAbelIso
  -> pic0_sepClosed_representableBy
  -> picRepDatumSepClosed -> jacobianDataSepClosed

finite-stage source package
  -> GluePackage.olean
  -> GluingDiagramIso.olean
  -> PreSnd.olean
  -> OverlapIsoSnd.olean
  -> GluedComparison.olean
  -> binder-free RepresentableBy P.gluedOver
  -> exact-carrier projectivity / FiniteInAffine
  -> original-field pic0_representableBy
  -> PicRepDatum -> JacobianData -> Challenge.Jacobian
```

The top line is the completed separably-closed route. The lower line is the missing arbitrary-field route. The two lines meet only after the binder-free representer and the exact-carrier geometric hypothesis have been proved.

## Mathematical Blockers

### 1. Universal Yoneda descent

The current code can descend individual relative Picard classes. The required theorem must descend the whole finite atlas, overlap equalities, and a natural `homEquiv` simultaneously. The intended target has the shape:

```text
pic0RepresentableBy_finiteStageGlue ... :
  (pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver
```

There must be no explicit `(rep : ...)` binder in this producer. An explicit representation argument makes a theorem a consumer, not a producer.

### 2. Exact-carrier orbit geometry

The finite-Galois quotient route needs projectivity or `FiniteInAffine` for the same carrier `P.gluedOver` used by the representation theorem. A theorem about a different carrier, or an assumption named `OrbitsInAffineOpen`, does not discharge this gate.

### 3. Original-field assembly

After the two preceding gates, the resulting `J` and `rep` must be projected into `PicRepDatum`, then `JacobianData`, and finally consumed by `Challenge.lean`. The existing separably-closed datum is not an original-field substitute.

## Compile Evidence

- `Pic0FiniteStageGluePackage.lean` fails before its proof body under the current source/cache state; a narrow probe used about 7.1 GB RSS.
- `overlapBaseChangeIso_hom_ι` in `Pic0FiniteStageGluingDiagramIso.lean` is the first expensive declaration in the coherent cone; prior checks reached roughly 610 seconds.
- Run `0154` reports no `GluePackage.olean` or `GluingDiagramIso.olean`; downstream `PreSnd`, `OverlapIsoSnd`, and `GluedComparison` therefore cannot be checked.
- At packet creation, Horizon still had zombie markers for runs `0149` and `0154`, but their recorded PIDs were dead and no Lean build process was active. Treat those as stale orchestration state, not as mathematical evidence.

Evidence reports:

- `.archon-horizon/runs/0152/sessions/0006-horizon-ajcr-strategy-review/report.md`
- `.archon-horizon/runs/0153/sessions/0002-horizon-ajcr-compile-isolation/report.md`
- `.archon-horizon/runs/0154/sessions/0002-horizon-ajcr-compile-frontier-repair/report.md`
- `.archon-horizon/runs/0156/sessions/0002-horizon-ajcr-roadmap-decomposition/report.md`

## What Not to Count as Capstone Progress

- A declaration with `(rep : ...)` is a consumer, even if it is proved and root-imported.
- A generated hgraph `lean_ok` label is not a substitute for a fresh native `.olean` and root import check.
- A previous full build passing on an earlier checkpoint does not certify the current glue cone.
- Root-only checks, metadata commits, and file splits may be useful engineering work, but they do not close an acceptance edge.

The strategy audit classified one implementation interval as 266 commits, 0 acceptance edges, 82 consumed prerequisites, 10 conditional consumers, 11 compile/performance splits, and 163 metadata/churn. This is the main explanation for the mismatch between activity and visible mathematical progress.

## Questions for the Human Reviewer

1. Is the finite-stage atlas mathematically sufficient to construct the required natural `homEquiv`, or is a standard representability theorem for the Picard functor the more defensible route?
2. Can projectivity or `FiniteInAffine` be proved for the exact glued carrier, rather than assumed or transported from a different scheme?
3. Are the field-extension and quotient constructions preserving the same `J` and `rep` strongly enough for the `PicRepDatum` and `JacobianData` interfaces?
4. Does the current `Challenge.lean` statement ask for more than the available finite-descent data can support, and should the statement boundary be redesigned before further proof work?
5. Which single theorem should be treated as the next acceptance milestone, with a concrete proof and resource budget?

## Suggested Reading Order

1. This packet.
2. `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`, section **Acceptance review**.
3. `status/AJCR/status.tex` for the older project snapshot; note that it is stale after runs `0153`-`0156`.
4. The four evidence reports listed above.
5. `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean` and the five glue modules named in the compile chain.
6. The two binding reviewer PDFs under `MainProjects/Algebraic-Jacobian-Challenge/informal/`.

## Operational Context (Separate from the Mathematics)

The task database currently contains 82 tasks: 28 done, 3 blocked, 4 queued, 1 failed, and 45 cancelled. The inbox reports 11 open memories, 12 open conversations, and 43 other open items. These numbers explain dashboard noise and repeated launches; they should not be interpreted as mathematical claims.

The static dashboard has local data through ledger `16de23f3d5`, but `dashboard/index.html` has an empty `generatedAt` field. The status PDFs still describe the August 21 state and mention runs `0149` and `0152` as active. A human reviewer should use this packet and the evidence reports as the current source of truth until those publication artifacts are refreshed.
