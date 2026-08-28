Read-only audit complete; no files changed.

**Current Cone**

- The rank-one path is implemented and root-audited:
  `rankOneAbelIso` in [Pic0RankOneAbelInverse.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneAbelInverse.lean:181)
  → `canonicalRankOneAbelIso` in [Pic0RankOneCanonicalEvaluation.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:259)
  → rank-one open immersion and translated-chart coverage
  → `pic0_sepClosed_representableBy` in [Pic0SepClosedRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:443).
- Sep-closed `PicRepDatum` and `JacobianData` exist in [Pic0SepClosedJacobianData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:138).
- Finite-Galois descent only gives the conditional producer `pic0RepresentableBy_finiteGaloisDescent`, requiring `OrbitsInAffineOpen`, in [Pic0FiniteGaloisRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35).
- There is no declaration named `pic0_representableBy` at current HEAD, and no arbitrary-field `JacobianData` producer.
- [Challenge.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:96) still has independent holes for the Jacobian object/group, dimension, properness, geometric irreducibility, Abel/Albanese, functoriality, and base change. Representability alone will not close all headline fields.

**First Implementable Universal Edge**

The best first producer is a finite-stage universal-class package, ideally a new module after `Pic0FiniteStageGluedComparison`:

1. Make `P.finiteStageBaseChangeIso` from [Pic0FiniteStageGluedComparison.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluedComparison.lean:284) root-reachable and compiled.
2. Fix `Ck := (baseChange K k).obj C` definitionally and obtain the canonical universal element from `pic0_sepClosed_representableBy`, via its `homEquiv` applied to the identity.
3. Restrict that element to the finite atlas charts encoded by `Pic0FiniteStageGluePackage`; descend the chart classes and overlap equalities to one finite subextension.
4. Package compatibility using `homEquiv_comp`/`pic0Map`, then construct the universal element and Yoneda comparison on `P.gluedOver`.

A finite-family version of `exists_finSubext_relPic_tensorStage` is mathematically sound and useful, but it is not the first edge by itself. The current theorem in [RelPicTensorStageFiniteStage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/RelPicTensorStageFiniteStage.lean:20) descends one raw `relPic` class for a fixed algebra `B` and a curve over `F`; the glue charts have varying coordinate rings and the starting universal element lives in the `pic0`/étale-sheafified API. After the restriction bridge exists, add a dependent finite-family form allowing `B : ι → Type`, together with simultaneous equality reflection. Existing finite element/equality lemmas in `TensorFiniteSubextension.lean` support that extension.

**Reachability And Audit**

- `Pic0CriticalPath.lean` imports and checks the rank-one, sep-closed, and conditional finite-Galois declarations, with `#print axioms` checks around lines 609–663 and 873–918.
- The top glue comparison modules were not imported by `Pic0CriticalPath.lean` or `AlgebraicJacobian.lean` at audit time. Their compilation was concurrently being worked on, so that live status may now have advanced.
- No `sorry`, `admit`, or new `axiom` occurs in the completed rank-one/sep-closed/conditional descent modules. Existing rooted audit records report exactly `[propext, Classical.choice, Quot.sound]`; I did not claim a fresh full-build result.
- The sibling original project is not a shortcut: [FGAPicRepresentability.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/FGAPicRepresentability.lean:963) retains its central FGA `sorry`, and its Jacobian headline has additional holes.

Suggested split: certify/import the glue comparison first; separately implement the universal-class restriction package; then implement dependent finite-family class/equality descent; then orbit-affine and unconditional `pic0_representableBy`; finally integrate `PicRepDatum`/`JacobianData` and close the independent Challenge geometry fields.
