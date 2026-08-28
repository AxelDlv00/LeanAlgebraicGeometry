Recommended bounded target: a Mathlib-only `CurveDivisor` finite-support type with `AddCommGroup`, `PartialOrder`, and unweighted degree bundled as `CurveDivisor →+ ℤ`. This matches Hartshorne IV.1’s algebraically closed-base convention and should link `ha-ch4-conv`.

Reusable sources:

- [Divisor.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/Divisor.lean:40): carrier and instances.
- [WeilDivisor.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean:1040): `degree`, `degree_hom`, and zero/add/neg/sub proofs.
- [ModulesBaseSheaf.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Cohomology/ModulesBaseSheaf.lean:95): lightweight `Scheme.Modules.IsLineBundle` fallback.
- [ClosedPoint.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/ClosedPoint.lean:63): DVR/order and residue-degree APIs for later weighted degree.
- [PrincipalDivisor.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/RiemannRoch/PrincipalDivisor.lean:62): later principal-divisor layer.

No files were modified.
