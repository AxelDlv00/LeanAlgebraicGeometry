# AJCR Horizon Status and Route-Divergence Brief

**Snapshot:** 2026-08-24 10:06 +0800  
**Source ledger before this packet:** `a58a86aca1`  
**Projects:** `Algebraic-Jacobian-Challenge-Rebuild` and the shared AJC descent engine

This is a status handoff for the mathematician who supplied the two review PDFs. It answers a narrower question than the previous packet: what has Horizon actually completed relative to the reviewed route, what is still missing, and why have several days of sessions not crossed the same Phase 7 boundary?

## Executive Verdict

The expected rank-one route was followed through the separably-closed milestone:

```text
PicRankOneOpen / DivRankOneOpen
  -> canonicalRankOneAbelIso
  -> translated rank-one cover over a separably closed field
  -> pic0_sepClosed_representableBy
```

The Horizon board marks these Phase 4-6 edges done, and the source-root audit reports the standard axiom footprint (`propext`, `Classical.choice`, `Quot.sound`). The same separably-closed carrier and representation feed `picRepDatumSepClosed` and `jacobianDataSepClosed`.

The stall is now Phase 7, finite-Galois descent. Horizon is pursuing a custom finite-stage atlas/gluing route:

```text
finite-stage atlas and GlueData
  -> P.gluedOver and glued base-change maps
  -> universal class and overlap/glue equivalences
  -> binder-free RepresentableBy P.gluedOver
  -> exact-carrier FiniteInAffine / projectivity
  -> original-field pic0_representableBy
  -> PicRepDatum -> JacobianData -> Challenge.Jacobian
```

The first line is substantial infrastructure. The rest is not yet proved. The immediate blockage is therefore not the old rank-one family producer; it is the combination of an expensive compile frontier and three unclosed Phase 7 producers.

## The Reviewer Route

The two supplied PDFs specify this binding chain:

```text
PicRankOneOpen
  -> rankOneAbelIso
  -> rankOne_translate_cover_sepClosed
  -> pic0_sepClosed_representableBy
  -> finiteGaloisDescent
  -> pic0_representableBy
  -> JacobianData
```

The review plan's Phase 7 expects a finite-type/proper/group descent package over the separable closure, a finite Galois action and stable affine cover, reuse of the AJC quotient/gluing engine, and one theorem returning both the descended scheme and its `RepresentableBy` certificate. Endpoint credit requires root reachability, an immediate consumer, a kernel build, an axiom audit, and no obsolete parallel route.

The August 7 supervision note specifically said to give the arbitrary-affine family producer one owner and then park the downstream lanes. That producer has since been marked complete in the Horizon roadmap. The current review question is consequently whether the new Phase 7 construction is the right realization of the descent contract, or whether it has become a second, much larger descent stack.

## Current Phase Status

| Reviewed phase | Horizon status | Evidence and interpretation |
| --- | --- | --- |
| Phase 3: public rank-one loci | **Done on board** | `PicRankOneOpen`, `DivRankOneOpen`, openness, and base-change APIs are reported as unconditional. |
| Phase 4: family-level rank-one Abel isomorphism | **Done on board** | `canonicalRankOneAbelIso` is root-reachable and used by the separably-closed representability file; this closes the reviewer PDF's central family-level producer. |
| Phase 5: separably-closed translated cover | **Done on board** | The translator is tied to the input Picard class and lands in the public rank-one locus. |
| Phase 6: separably-closed Pic0 representer | **Done on board** | `pic0_sepClosed_representableBy` and same-carrier `picRepDatumSepClosed` / `jacobianDataSepClosed` are present and narrow-axiom-clean. |
| Phase 7: finite-Galois descent | **Blocked** | No unconditional original-field producer. The finite-stage glue chain is only partly native-built; the universal Yoneda and exact-carrier orbit gates remain mathematical. |
| Phase 8: Jacobian capstone | **Blocked** | No `pic0_representableBy` feeds the same `J` and `rep` into `PicRepDatum`, `JacobianData`, and `Challenge.lean`. |

## What Is Actually Remaining

| Gate | Current state | What would close it |
| --- | --- | --- |
| Native finite-stage glue cone | **Build frontier** | A fresh root import must certify `GluingDiagramIso`, top `PreSnd`, `OverlapIsoSnd`, and `GluedComparison`. `GluePackage.olean` landed on 2026-08-24 00:29, but the four downstream artifacts are still absent. |
| Universal finite-stage producer | **Mathematical blocker** | A theorem of the form `pic0RepresentableBy_finiteStageGlue ... : (pic0TypeFunctor ...).RepresentableBy P.gluedOver`, with the exact carrier and no `(rep : ...)` binder, including a natural `homEquiv`. |
| Exact-carrier orbit geometry | **Mathematical blocker** | `P.gluedMap.IsProjective`, `FiniteInAffine P.glueData.glued`, or an equivalent theorem for the same carrier used by the representation producer. Existing orbit lemmas consume this as a hypothesis. |
| Original-field Pic0 | **Missing producer** | A finite-Galois descent theorem that returns the descended scheme and its representation certificate, immediately consumed by `pic0_representableBy`. |
| Jacobian handoff | **Missing consumer** | Project the same original-field `J` and `rep` through `PicRepDatum` and `JacobianData`, then wire that datum to the protected `Challenge.Jacobian` statement without an import cycle. |

## Why Horizon Keeps Returning to the Same Issues

### 1. The route is split after the first genuine milestone

P4-P6 are now complete, but the Phase 7 target was decomposed into a long sequence of infrastructure leaves: transition models, triple overlaps, ring maps, glue records, base-change isomorphisms, overlap projections, and only later the actual natural Yoneda equivalence. A successful prerequisite does not close an acceptance edge. This creates many plausible-looking commits while the first producer consumed by the descent theorem remains absent.

### 2. Source labels are being mistaken for root evidence

The graph contains `lean_ok` and source-synchronized labels for declarations whose native `.olean` files are missing. `Pic0CriticalPath.lean` imports the top glue modules, so a source scan cannot certify the critical root. The current acceptance rule must be: native artifact, fresh root import, `#check`, and `#print axioms`.

### 3. One declaration consumes the whole iteration budget

The GluePackage probe used about 7.1 GB RSS before its proof body. The first expensive declaration in the next cone is `overlapBaseChangeIso_hom_iota` in `Pic0FiniteStageGluingDiagramIso.lean:276`; historical checks reached roughly 610 seconds. Run 0154 spent its time repairing this cone. This is a legitimate performance problem, but it is not evidence that the later Yoneda or orbit theorem is mathematically solved.

### 4. The orchestration keeps stale work alive

Run 0154 has session metadata `status: running` from `2026-08-23T14:55:00Z`, while Horizon reports its PID as a zombie marker and no Lean compiler is active. Its system sessions explicitly returned the task to `queued` without a terminal result. Runs 0145 and 0148 repeatedly relaunched the same alignment task; their later sessions are mostly `exit 1` or `queued` with no substantive output. Run 0156 decomposed the blocker and repaired the roadmap, but did not advance a theorem edge.

### 5. The custom finite-stage carrier may be a second descent stack

The reviewer plan says to reuse the AJC finite-Galois quotient/gluing engine. The current route introduces `P.gluedOver`, a custom finite-stage overlap/glue cone, then asks for a new universal `homEquiv` on that carrier before the generic quotient consumer can apply. This may be the correct implementation, but it is the largest architectural question for review: is it genuinely the finite-level representer required by the plan, or is Horizon rebuilding descent infrastructure without first proving that the carrier represents the same Pic0 functor?

## Chronology of the Stall

| Run | Date | What happened | Acceptance result |
| --- | --- | --- | --- |
| `0145` | Aug 14 | Eight-round alignment-tag task; later sessions repeatedly returned `exit 1` / `queued`. | No theorem edge. |
| `0148` | Aug 14 | Same alignment task relaunched; substantial metadata/audit work, then repeated queued/failed sessions. | No theorem edge. |
| `0149` | Aug 14 onward | Full AJCR review continuation; the implementation audit classified 266 commits as 0 acceptance edges, with 82 consumed prerequisites and 10 conditional consumers. | P4-P6 evidence was clarified, but no arbitrary-field edge. |
| `0153` | Aug 22 | Compile isolation measured the GluePackage/DiagramIso frontier. | No native top-cone acceptance. |
| `0154` | Aug 23-24 | Compile-frontier repair; `GluePackage.olean` eventually appeared, but DiagramIso and four downstream top artifacts did not. Metadata remains stale `running`. | No root acceptance. |
| `0156` | Aug 23 | Roadmap decomposition separated build gates from Yoneda, orbit, and original-field gates. | No source or theorem edge. |

## Questions for the Mathematician

1. Does the current `P.gluedOver` construction actually implement the finite-level representer required by the reviewer plan, including the universal Picard class and natural Yoneda equivalence, or is it only an atlas/base-change model?
2. Can the finite-Galois descent be expressed by the existing AJC theorem `representableBy_of_finiteGalois_baseChange` once the correct finite-level producer is stated, instead of extending the custom glue cone further?
3. What mathematical input proves orbit affineness/projectivity for the exact glued carrier? Do finite type, properness, geometric irreducibility, and the group structure of the separably-closed representer suffice, or is a new theorem needed?
4. Is the missing binder-free `RepresentableBy P.gluedOver` a genuine descent argument that should be written at the functor/sheaf level, rather than assembled from more overlap identities?
5. What single declaration should be the next acceptance milestone, with a bounded resource budget: the root-imported glue cone, the binder-free finite-stage producer, or the exact-carrier orbit theorem?

## Recommended Reading Order

1. This brief.
2. `MainProjects/Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf` (the binding route and Phase 7 contract).
3. `MainProjects/Algebraic-Jacobian-Challenge/informal/AJCR_Runs_121_122_123_Supervision_Note_2026-08-07.pdf` (the earlier owner/stop recommendation).
4. `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean` (current claimed route and checks).
5. The Phase 7 roadmap files under `.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent*`.
6. Run reports `0152`, `0153`, `0154`, and `0156` listed below.

The existing `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md` acceptance section is useful but was measured before the latest GluePackage artifact landed; do not treat its artifact inventory as current.

## Evidence Reports

- `.archon-horizon/runs/0152/sessions/0006-horizon-ajcr-strategy-review/report.md`
- `.archon-horizon/runs/0153/sessions/0002-horizon-ajcr-compile-isolation/report.md`
- `.archon-horizon/runs/0154/sessions/0002-horizon-ajcr-compile-frontier-repair/report.md`
- `.archon-horizon/runs/0154/sessions/0005-horizon-ajcr-compile-frontier-repair/report.md`
- `.archon-horizon/runs/0156/sessions/0002-horizon-ajcr-roadmap-decomposition/report.md`

## Dashboard and Queue Caveat

The current task database has 82 tasks: 28 done, 3 blocked, 4 queued, 1 failed, and 45 cancelled. Open inbox items include 12 conversations, 18 issues, and 11 memories. These explain the session noise but are not mathematical progress. The static dashboard has local data through ledger `16de23f3d5`, but `dashboard/index.html` still has an empty `generatedAt`, and the existing status PDFs still describe the older Aug 21 state. Use this packet and the evidence reports as the current status source.

## Bottom Line

Horizon is not stuck because the rank-one route failed: that route has reached the separably-closed representer. It is stuck because Phase 7 currently has two different problems being interleaved: a resource-bound custom glue cone and missing mathematical producers after that cone. Until a human decides whether `P.gluedOver` is the right finite-level object and names one producer-level acceptance test, more sessions will continue to generate prerequisites, conditional wrappers, and metadata without reaching `pic0_representableBy`.
