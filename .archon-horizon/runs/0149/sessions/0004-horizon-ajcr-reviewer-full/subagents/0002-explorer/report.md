Final cone verdict:

- The rank-one through separably closed endpoint is genuinely complete and clean:
  `AlgebraicGeometry.picRankOneOpen_isOpen` → `DivRankOneOpenData` → `canonicalRankOneAbelIso` → translated-chart coverage → `pic0_sepClosed_representableBy` → `picRepDatumSepClosed` → `jacobianDataSepClosed`.
- All audited declarations in that chain report only `propext`, `Classical.choice`, and `Quot.sound`; no `sorryAx` is reachable.
- The arbitrary-field endpoint remains open: there is currently no declaration named `pic0_representableBy`, and consequently no arbitrary-field `PicRepDatum` or `JacobianData` producer.
- `Challenge.lean` remains independently sorry-backed; the headline `Jacobian` does not yet consume the clean `JacobianData` infrastructure.

The most material clean but currently unrooted theorem is:

- `AlgebraicGeometry.pic0RepresentabilityDescentData` at [Pic0RepresentabilityDescentData.lean:412](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean:412), packaging a supplied finite-Galois-level
  `(pic0TypeFunctor ((baseChange k L).obj C)).RepresentableBy J`
  as `Over.pullbackPseudofunctor.DescentData'`.
- Its immediate producer is the clean cocycle
  `AlgebraicGeometry.pic0RepresentabilityDescentCocycle` at [Pic0RepresentabilityDescentData.lean:398](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentabilityDescentData.lean:398).
- This file is not imported by `Pic0CriticalPath`, so it presently does not advance the rooted theorem graph despite being mathematically substantive.

Key rooted declarations:

- `AlgebraicGeometry.picRankOneOpen_isOpen`: [Pic0RankOneOpenProducer.lean:352](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneOpenProducer.lean:352)
- `AlgebraicGeometry.divRankOneOpenData_of_picRankOneOpen_isOpen`: [DivRankOneOpen.lean:181](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRankOneOpen.lean:181)
- `AlgebraicGeometry.canonicalRankOneAbelIso`: [Pic0RankOneCanonicalEvaluation.lean:259](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:259)
- `AlgebraicGeometry.pic0_sepClosed_representableBy`: [Pic0SepClosedRepresentable.lean:426](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426)
- `AlgebraicGeometry.picRepDatumSepClosed`: [Pic0SepClosedJacobianData.lean:138](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:138)
- `AlgebraicGeometry.jacobianDataSepClosed`: [Pic0SepClosedJacobianData.lean:146](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:146)

The quotient machinery is conditional, not an endpoint:

- `AlgebraicGeometry.pic0SemilinearGalActionOfRepresentableBy`: [Pic0GaloisAction.lean:377](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0GaloisAction.lean:377)
- `AlgebraicGeometry.StableAffineOpen.gluedQuotientOverHomEquiv`: [Pic0FiniteGaloisDescent.lean:129](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisDescent.lean:129), requiring finite Galois hypotheses and `rho.OrbitsInAffineOpen`.

Smallest honest next implementation slice: finish and root the in-flight Pic0 invariant/equivariant matching theorem plus its conditional finite-Galois quotient `RepresentableBy` consumer. After that, the next mathematical producer must be finite-stage spreading of the separably closed representative, with the conditional quotient theorem as its immediate consumer. The orbit-in-affine input remains a separate required obligation; it cannot be silently inferred from the existing descent-data package.

No source or metadata files were edited.
