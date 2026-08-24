# AJCR Horizon Status: Why Phase 7 Is Stuck

**Snapshot:** 2026-08-24 10:06 +0800  
**Source ledger before this packet:** `a58a86aca1`

This is a plain-language status handoff for the mathematician who supplied the [execution plan]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf ) and [supervision note]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/AJCR_Runs_121_122_123_Supervision_Note_2026-08-07.pdf ). It separates completed mathematics from unfinished descent work and explains why Horizon has spent days circling the same boundary.

## Status at a Glance

| Status | Meaning |
| --- | --- |
| **Complete** | The rank-one chart and the separably-closed `Pic^0` representer are reported as genuine, root-reachable results. |
| **Build-blocked** | The finite-stage descent modules are present in source, but the compiled proof artifacts needed by the critical root are incomplete. |
| **Mathematically missing** | The universal original-field representer and the exact geometric hypothesis needed by the quotient are not proved. |

The important correction to the previous handoff is that the family-level rank-one producer is no longer the blocker.

## What Has Landed

The reviewed route was:

```text
rank-one Picard/divisor chart
  -> family-level Abel isomorphism
  -> translated rank-one charts over a separably closed field
  -> Pic^0 represented over that field
  -> finite-Galois descent
  -> Pic^0 represented over the original field
  -> Jacobian
```

Horizon reports the first four stages complete:

| Stage | Status | Plain-language interpretation | Pointer |
| --- | --- | --- | --- |
| Rank-one chart | **Complete** | The good locus of line bundles and the matching divisor locus are defined for arbitrary test schemes. | [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:205) |
| Family-level Abel map | **Complete** | The evaluation divisor gives a natural two-sided inverse, not merely a fieldwise uniqueness statement. | [`canonicalRankOneAbelIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:618) |
| Separably-closed cover | **Complete** | Translations of the rank-one chart cover the Picard classes after passing to a separably closed field. | [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:640) |
| Separably-closed `Pic^0` | **Complete** | A scheme and a representation of `Pic^0` exist over the separably closed field; the same scheme/representation feed the current datum objects. | [`Pic0SepClosedRepresentable.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:443) |

These correspond to Horizon roadmap phases P3-P6. The narrow source audit reports only the standard Lean axioms `propext`, `Classical.choice`, and `Quot.sound` for this part of the route.

## Where Progress Stops

Horizon is now trying to descend the separably-closed representer through a custom finite-stage atlas:

```text
finite-stage affine charts and overlap maps
  -> candidate glued scheme P.gluedOver
  -> one universal Picard class on that glued scheme
  -> universal natural equivalence (the actual representability proof)
  -> projectivity / affine-orbit control for the same scheme
  -> finite-Galois quotient and original-field Pic^0
  -> Jacobian data
```

The candidate scheme is described in [`Pic0FiniteStageGluedOver.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:1). The roadmap decomposition is recorded in the [Phase 7 roadmap](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.yaml).

| Remaining item | Status | What it means mathematically | Pointer |
| --- | --- | --- | --- |
| Compile the glued scheme | **Build-blocked** | The source exists, but the critical root cannot yet import the complete gluing construction. `GluePackage.olean` appeared on Aug 24; four top-level artifacts are still absent. | [`Pic0FiniteStageGluingDiagramIso.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:276), [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:84) |
| Prove finite-stage representability | **Missing** | Show that maps into `P.gluedOver` are naturally equivalent to families of `Pic^0` classes. This is the universal property, not just compatibility of charts. | [finite-stage roadmap target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.representability.finite-stage.yaml), [blueprint descent theorem](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1846) |
| Prove the geometric quotient hypothesis | **Missing** | Establish projectivity or affine-orbit control for this exact glued scheme. Existing quotient results assume this property; they do not create it. | [exact-carrier roadmap target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.orbit-affine.exact-carrier.yaml), [`Pic0FiniteStageOrbitAffine.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:1) |
| Descend to the original field | **Missing** | Produce the original-field scheme together with its universal representation, rather than a theorem that accepts a representation as an input. | [original-field roadmap target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.representability.original-field.yaml), [generic descent theorem in the blueprint](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1846) |
| Build the Jacobian | **Blocked downstream** | The final `JacobianData` must use the same original-field scheme and universal class. That handoff does not exist yet. | [`Pic0FiniteGaloisJacobianData.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean:1), [`Challenge.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:1) |

The finite-stage source files in the compile cone are [`Pic0FiniteStageGluePackage.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:1), [`Pic0FiniteStageGluingDiagramIso.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:1), [`Pic0FiniteStageGluingOverlapIsoPreSnd.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingOverlapIsoPreSnd.lean:1), [`Pic0FiniteStageGluingOverlapIsoSnd.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingOverlapIsoSnd.lean:1), and [`Pic0FiniteStageGluedComparison.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:1).

## Why Horizon Appears Stuck

### The mathematical work and the build work are mixed together

After P6, Horizon split the descent target into many local tasks: transition models, triple overlaps, ring maps, glue records, base-change maps, and projection lemmas. These are useful prerequisites, but none is the universal property of the candidate scheme. This is why the commit count grows while the original-field theorem remains absent.

### The critical compile is too expensive to be a normal iteration

The GluePackage probe used about 7.1 GB of memory. The first expensive declaration in the next file is `overlapBaseChangeIso_hom_iota` at line 276 of [`Pic0FiniteStageGluingDiagramIso.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:276), with historical checks around 610 seconds. A session can spend its whole budget on one elaboration before any mathematical producer is tested.

### “Source checked” is being confused with “critical route checked”

The graph contains `lean_ok` labels for source declarations whose compiled artifacts are absent. The critical root imports the top gluing modules, so the only meaningful acceptance test is a fresh native build followed by a root import and axiom check. The exact root is [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:1).

### Horizon is carrying stale orchestration state

Run 0154 still has session metadata marked `running` from `2026-08-23T14:55:00Z`, while `horizon ps` reports a zombie marker and no live Lean process. Its system sessions returned the task to `queued`. Runs 0145 and 0148 repeatedly relaunched the same alignment task; later sessions mostly returned `exit 1` or `queued`. The corresponding reports are [`0154 compile repair`](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0154/sessions/0005-horizon-ajcr-compile-frontier-repair/report.md), [`0153 isolation`](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0153/sessions/0002-horizon-ajcr-compile-isolation/report.md), and [`0156 decomposition`](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0156/sessions/0002-horizon-ajcr-roadmap-decomposition/report.md).

### The candidate carrier is the main architectural uncertainty

The reviewer’s plan says to reuse the AJC finite-Galois quotient/gluing engine. Horizon instead first constructs `P.gluedOver` and then needs a new universal equivalence on it. That may be the right finite-level implementation, but it may also be a second descent stack that has not yet been shown to represent the same `Pic^0` functor. The relevant generic theorem is documented in the [blueprint’s finite-Galois descent section](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1846).

## The Decision Point

The next useful human decision is not another local Lean lemma. It is whether the `P.gluedOver` construction is the correct finite-level representer for the reviewed descent theorem. If it is, Horizon needs one bounded producer milestone: a root-imported universal equivalence for `P.gluedOver`. If it is not, the route should be refactored around the generic AJC descent theorem before more overlap and glue files are added.

## Run Pattern

| Run | Date | Observable result |
| --- | --- | --- |
| `0145` | Aug 14 | Eight-round alignment task; later sessions repeatedly returned `exit 1` or `queued`. |
| `0148` | Aug 14 | Same alignment task relaunched; metadata/audit work, then queued or failed sessions. |
| `0149` | Aug 14 onward | Audit classified 266 commits as 0 acceptance edges, 82 consumed prerequisites, and 10 conditional consumers. |
| `0153` | Aug 22 | Compile isolation measured the GluePackage/DiagramIso frontier. |
| `0154` | Aug 23-24 | Compile repair produced `GluePackage.olean`, but no root-certified downstream top cone; stale `running` metadata remains. |
| `0156` | Aug 23 | Roadmap decomposition separated build, universal-property, orbit, and original-field gates; no theorem edge was added. |

The current task database has 28 done, 3 blocked, 4 queued, 1 running, 1 failed, and 45 cancelled tasks. Open inbox items include 12 conversations, 18 issues, and 11 memories. The static dashboard still has an empty `generatedAt`, and the existing status PDFs describe the older Aug 21 state.

## Bottom Line

Horizon is not stuck because the rank-one route failed. It is stuck because Phase 7 interleaves a resource-bound custom glue construction with missing universal and geometric producers. The central issue for the mathematician is whether `P.gluedOver` is the right object for the reviewed finite-Galois descent route, not whether another local overlap lemma can be added.
