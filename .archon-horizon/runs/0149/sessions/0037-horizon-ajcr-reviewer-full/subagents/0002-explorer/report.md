Audit result: the rank-one-to-separably-closed cone is genuinely complete and rooted; terminal arbitrary-field production is not merely unwired.

- `rankOneAbelIso` is proved in [Pic0RankOneAbelInverse.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneAbelInverse.lean:181), with a concrete inhabitant and `canonicalRankOneAbelIso` in [Pic0RankOneCanonicalEvaluation.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:259). It feeds the actual separably closed representer.
- The sep-closed endpoint is real: `picRepDatumSepClosed` and `jacobianDataSepClosed` package the exact `pic0_sepClosed_representableBy` without changing carrier/representation ([Pic0SepClosedJacobianData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedJacobianData.lean:138), :146). These are available but only at `[IsSepClosed k]`.
- Finite-Galois descent is also real but conditional: `pic0RepresentableBy_finiteGaloisDescent` consumes an already-produced finite-Galois-level `RepresentableBy` plus `OrbitsInAffineOpen`; it returns only `RepresentableBy`, no lft/qc datum ([Pic0FiniteGaloisRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35)). No producer supplies either required input for the sep-closed carrier.

Actual missing producers:
1. finite-stage object-to-exact global base-change comparison;
2. descent of the universal Picard natural equivalence, not just the object;
3. fixed-base filtered-colimit preservation before the arbitrary-field descent;
4. finite Galois normal-closure/orbit-in-affine input;
5. only then arbitrary-field `PicRepDatum`/`JacobianData`, and Challenge discharge.

This is stated accurately in the root ([Pic0CriticalPath.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:283)). Thus global glued base change is a real prerequisite for the current finite-stage route, but is not sufficient for the terminal endpoint.

The finite-stage package itself is inhabited ([Pic0FiniteStageGluePackage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluePackage.lean:113)). Current local comparisons are:
- pullback glue equals gluing of pullback charts, [Pic0FiniteStageGluingBaseChange.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:37);
- chart isomorphisms, same file :52;
- left-leg naturality, [Pic0FiniteStageRestrictionNaturality.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionNaturality.lean:32);
- ring-level right-leg equality through final scalar extension, [Pic0FiniteStageRightLegEquality.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightLegEquality.lean:35), :90, :119.

Recommended highest-value independent target: add the missing **scheme-level right-overlap-leg base-change compatibility** in `Pic0FiniteStageGluingBaseChange`/a companion file, derived from the existing right-leg ring equality plus the left-leg naturality and `gluingChartIso`/`overlapBaseChangeIso`. It is a bounded local theorem, unblocks assembly of the global glued-scheme isomorphism, and does not pretend to produce representability. The global iso itself is the next consumer, but should not be attempted before this compatibility is named.

No endpoint can simply import this cone into `Challenge.lean`: `Pic0Functor -> DegreeZero -> RelPicDegree -> ChiCurve -> Challenge`, while Challenge’s `Jacobian` remains sorried ([Challenge.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean:96)). The same cycle reaches `H1BaseFieldInvariance`. A final discharge needs a foundational split (Challenge core/base-change/genus facts below Picard, then downstream endpoint), not a new import from Challenge into Picard.
