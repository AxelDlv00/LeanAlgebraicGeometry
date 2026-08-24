# AJCR Mathematical Diagnosis for Human Review

**Review state:** 24 August 2026

## Verdict

The current plateau is not explained by formal transport alone. The route has two
substantive mathematical producer gaps:

1. No theorem yet proves that the chosen finite-stage carrier `P.gluedOver`
   represents the finite-stage `Pic^0` functor for arbitrary test schemes.
2. No unconditional theorem yet gives the required orbit-affine/projective
   geometry for that same carrier over an arbitrary finite Galois stage.

The local atlas identities and scheme comparisons needed by these statements are
largely present. Effective Galois descent and the final Jacobian packaging look
like downstream formal transport once the two producer theorems are available.
The mathematician should therefore inspect the two producer claims first: they are
the places where the route may need a new idea, a stronger hypothesis, or a
different carrier.

The handoff follows the supplied [execution plan](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/Lean_Algebraic_Jacobian_Complete_Execution_Plan.pdf)
and [supervision note](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/informal/AJCR_Runs_121_122_123_Supervision_Note_2026-08-07.pdf).

## Route currently being formalized

```text
rank-one Picard/divisor chart
  -> family-level Abel isomorphism
  -> translated charts over a separably closed field
  -> Pic^0 represented over that field
  -> finite-stage glued carrier P.gluedOver
  -> finite-Galois quotient and descent
  -> Pic^0 over the original field
  -> Jacobian
```

The carrier is defined in
[`Pic0FiniteStageGluedOver.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedOver.lean:1),
and the intended decomposition is recorded in the
[Phase 7 roadmap](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.yaml).

## Mathematics already established

| Stage | What is actually available | Pointer |
| --- | --- | --- |
| Rank-one chart | The good line-bundle locus and matching divisor locus are defined over arbitrary test schemes. | [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:205) |
| Family Abel map | The evaluation divisor gives a natural two-sided inverse, not only a fieldwise bijection. | [`canonicalRankOneAbelIso`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:618) |
| Separably-closed cover | Translates of the rank-one chart cover Picard classes after passing to a separably closed field. | [`Pic0CriticalPath.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:640) |
| Separably-closed `Pic^0` | A scheme and a representing universal class exist over the separably closed field. | [`Pic0SepClosedRepresentable.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:443) |
| Local universal class | The pinned class restricts to each chart and both sides of every overlap; these equalities are stored in `Pic0FiniteStageUniversalAtlasClass`. | [`Pic0FiniteStageUniversalClass.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageUniversalClass.lean:119) |
| Object-level comparison | `gluingGluedIso` and `finiteStageBaseChangeIso` identify the scalar extension of the finite-stage glued scheme with the separably-closed atlas glue. | [`Pic0FiniteStageGluedComparison.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:239) |

Thus the original rank-one family producer is no longer the obstruction, and the
local overlap compatibility of the universal class is not the missing ingredient.

## Exact issue classification

| Classification | Exact missing statement | Why the current route stops here | Pointers |
| --- | --- | --- | --- |
| **Confirmed mathematical gap: finite-stage representability** | For every test scheme `T` over `Spec k`, construct a natural equivalence `P.gluedOver ⟶ T` (in the relevant opposite category) `≃ pic0TypeFunctor C T`, with the exact carrier fixed and naturality under precomposition. Equivalently, produce `(pic0TypeFunctor ((baseChange K P.N.1).obj C)).RepresentableBy P.gluedOver`. | The glue package supplies charts, overlaps, and a glued scheme. The comparison theorems supply an isomorphism of schemes after base change. Neither statement identifies maps from an arbitrary `T` with `Pic^0` families on `T`. The roadmap records that there is no existing binder-free `homEquiv` producer. | [Yoneda target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.universal.yoneda.yaml), [finite-stage target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.representability.finite-stage.yaml), [blueprint descent theorem](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1846) |
| **Confirmed geometric gap, with conditional lemmas: exact-carrier orbit geometry** | Prove `FiniteInAffine P.glueData.glued`, or an equivalent finite-dimensional projective-space immersion/projectivity statement, over the arbitrary finite Galois stage used by `P`. The theorem must apply to the exact carrier that is supposed to represent the functor. | `Pic0FiniteStageOrbitAffine.lean` has useful conditional producers, but they consume `rep` and, depending on the route, assume an algebraically closed field plus connectedness/irreducibility, or an explicit immersion/projectivity input. This does not yet provide an unconditional arbitrary-field theorem before the representation certificate exists. The gap is mathematical unless the reviewed finite-type/proper/group geometry supplies those hypotheses. | [Exact-carrier target](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/roadmap/items/AJCR.review-plan.p7-galois-descent.orbit-affine.exact-carrier.yaml), [orbit lemmas](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOrbitAffine.lean:56), [stable-cover wrappers](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableAffineCover.lean:43) |
| **Likely formal transport: global universal-class gluing** | Turn the already compatible chart/overlap classes into one class on the glued scheme, then prove that its pullback along every test map is the class corresponding to that map under the Yoneda equivalence. | The local equations are already present. The remaining work is to transport them through the multicoequalizer and package them with the natural equivalence. This is secondary to the missing representability theorem; it should not introduce a second universal class. | [Atlas class](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageUniversalClass.lean:135), [gluing comparison](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:284) |
| **Likely formal transport: effective finite-Galois descent** | Apply the representation-preserving descent theorem to the finite-stage scheme, its semilinear action, orbit-affine input, and the same universal class; retain the cocycle and naturality identities. | The reviewed blueprint already specifies this as a single descent theorem. Once representability and exact-carrier orbit geometry are supplied, the remaining check is whether the existing hypotheses match the theorem, not whether a new moduli construction is needed. | [Finite-Galois descent](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1777), [representability descent](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/blueprint/src/chapters/DivisorScheme.tex:1846) |
| **Likely formal transport: Jacobian handoff** | Pass the descended scheme and its universal class unchanged through `PicRepDatum`, `JacobianData`, and the final statement. | This is downstream of the original-field `RepresentableBy` certificate. A second representing object or a freshly chosen class would be a mathematical change of route, not a harmless packaging step. | [`Pic0FiniteGaloisJacobianData.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisJacobianData.lean:1), [`Challenge.lean`](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:1) |

## Why the same boundary keeps reappearing

The current strategy repeatedly proves facts about the finite atlas: restriction
maps agree on overlaps, the diagrams are isomorphic, and the glued scheme has the
right scalar extension. Those facts establish that the proposed carrier is a
plausible model. They do not prove the universal assertion

```text
for every T, maps(T, P.gluedOver) are naturally the same as Pic^0-families on T.
```

That assertion is the first producer theorem consumed by every later descent
construction. The orbit-affine lemmas then consume the same `rep`; they cannot
create it. Consequently, local overlap identities can accumulate without moving
the route past the same mathematical boundary.

## Mathematical conclusion

The route is not currently blocked by mere formal transport. It contains one
confirmed functor-level theorem gap and one confirmed geometric gap at the exact
finite carrier. The class-gluing, finite-Galois descent, and Jacobian steps are
best viewed as conditional downstream work. A mathematician can now validate or
reject two concrete claims: whether the proposed `P.gluedOver` really has the
finite-stage universal property, and whether its orbit geometry follows over an
arbitrary finite Galois stage from the available geometry of `Pic^0`. If either
claim requires a different carrier or an extra hypothesis, the route itself must
change before further local identities will help.
