# AJCR Mathematical Status for Human Review

**Review state:** 24 August 2026

This is a mathematics-only handoff based on the supplied [execution plan]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf ) and [supervision note]( /home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/AJCR_Runs_121_122_123_Supervision_Note_2026-08-07.pdf ). It records what has been established, what the current descent strategy is trying to prove, and where a mathematician's judgment is most valuable.

## The Mathematical Route

The intended curve-specialized route is:

```text
rank-one Picard/divisor chart
  -> family-level Abel isomorphism
  -> translated rank-one charts over a separably closed field
  -> Pic^0 represented over that field
  -> finite-Galois descent
  -> Pic^0 represented over the original field
  -> Jacobian
```

This is the route described in the review plan's Phase 3 through Phase 8.

## Established Mathematics

| Stage | Status | Mathematical content | Pointer |
| --- | --- | --- | --- |
| Rank-one chart | **Established** | The good locus of line bundles and the matching divisor locus are defined for arbitrary test schemes. | [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:205) |
| Family-level Abel map | **Established** | The evaluation divisor gives a natural two-sided inverse, not merely fieldwise uniqueness. | [`canonicalRankOneAbelIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:618) |
| Separably-closed cover | **Established** | Translations of the rank-one chart cover Picard classes after passing to a separably closed field. | [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:640) |
| Separably-closed `Pic^0` | **Established** | A scheme and a representing universal class exist over the separably closed field; the same pair feeds the current Picard/Jacobian datum. | [`Pic0SepClosedRepresentable.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:443) |

The rank-one family producer emphasized in the review PDFs is therefore no longer the mathematical obstruction.

## Current Descent Strategy

The current strategy starts with the separably-closed representing scheme and attempts to spread it to a finite field of definition:

```text
finite affine charts and overlap maps for the separably-closed representer
  -> finite-stage glued scheme P.gluedOver
  -> one universal Picard class on P.gluedOver
  -> natural equivalence between maps to P.gluedOver and Pic^0 families
  -> projectivity or affine-orbit control for that same scheme
  -> finite-Galois quotient and descent to the original field
  -> PicRepDatum -> JacobianData
```

The candidate scheme is defined in [`Pic0FiniteStageGluedOver.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:1). The mathematical decomposition is recorded in the [Phase 7 roadmap](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.yaml).

## Open Mathematical Obligations

| Obligation | Mathematical question | Pointer |
| --- | --- | --- |
| Universal property of the finite-stage carrier | Does `P.gluedOver` represent the finite-stage `Pic^0` functor? The required result is a natural equivalence between maps into this one scheme and `Pic^0` families on every test scheme. A collection of compatible charts and overlap maps is not yet this universal property. | [finite-stage representability target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.representability.finite-stage.yaml), [blueprint descent theorem](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1846) |
| Coherence of the universal class | Do the local universal Picard classes, their restrictions, and their overlap identifications assemble into one class on `P.gluedOver`, naturally under arbitrary base change? This is the point where pointwise or affine data must become a family-level object. | [`Pic0FiniteStageUniversalClass.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageUniversalClass.lean:1), [`Pic0FiniteStageGluedComparison.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:1) |
| Exact-carrier orbit geometry | Can one prove projectivity, `FiniteInAffine`, or an equivalent affine-orbit statement for the exact carrier `P.gluedOver`? The finite-Galois quotient requires this property for the same scheme that represents the functor; a theorem about another carrier is insufficient. | [exact-carrier orbit target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.orbit-affine.exact-carrier.yaml), [`Pic0FiniteStageOrbitAffine.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:1) |
| Effective finite-Galois descent | Given the finite-stage representer, its universal class, and the semilinear Galois action, can the quotient be formed and can the universal class descend with its naturality and cocycle identities? The blueprint states this as one representation-preserving descent theorem. | [blueprint finite-Galois descent](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1777), [blueprint representability descent](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1846) |
| Original-field Jacobian datum | Does the descended scheme and the descended universal class pass unchanged through `PicRepDatum`, `JacobianData`, and the final Jacobian statement? The construction must not choose a second representing object or a second universal class. | [`Pic0FiniteGaloisJacobianData.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean:1), [`Challenge.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:1) |

The finite-stage mathematical objects are distributed across [`Pic0FiniteStageGluePackage.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:1), [`Pic0FiniteStageGluingDiagramIso.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:1), [`Pic0FiniteStageGluingOverlapIsoPreSnd.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingOverlapIsoPreSnd.lean:1), [`Pic0FiniteStageGluingOverlapIsoSnd.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingOverlapIsoSnd.lean:1), and [`Pic0FiniteStageGluedComparison.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:1).

## Mathematical Diagnosis

The repeated plateau has a mathematical shape:

1. The separably-closed representer is available, but the passage from its finite affine atlas to a single universal object is not yet expressed as one theorem.
2. The current work keeps strengthening local restriction, overlap, and base-change identities. Those identities are necessary, but they do not by themselves prove that the glued carrier represents the functor.
3. The quotient step is conditional on a geometric property of the exact carrier. It is not enough to know that some finite-stage scheme is projective or that an orbit lies in an affine open for a different carrier.
4. Until the universal property and exact-carrier geometry are both settled, the original-field representer and the Jacobian datum cannot be assembled from the same mathematical object.

The main route question for the mathematician is therefore: **Is `P.gluedOver` genuinely the finite-level representing scheme required by the reviewed descent theorem, or is the current strategy constructing an atlas without yet identifying its universal property?**

## Minimal Mathematical Checkpoint

The next meaningful milestone is one theorem, not another collection of local identities:

```text
P.gluedOver represents the finite-stage Pic^0 functor
```

It should include the universal Picard class, the natural map/equivalence for every test scheme, and the compatibility needed by the finite-Galois quotient. Once that theorem is in place, the mathematician can assess the exact-carrier orbit argument and the final descent. If it cannot be stated without adding unrelated hypotheses or changing carriers, that is evidence that the route needs redesign.

## Bottom Line

The rank-one and separably-closed mathematics is in place. The unresolved mathematics is concentrated in the finite-stage universal property, the geometry of the exact glued carrier, effective Galois descent of the same representing datum, and the final Jacobian handoff. Those are the points where a mathematician can identify a missing theorem, a false implication, or a better route.
