Implemented the requested adapter in [Pic0FiniteStageLegacyAdapter.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageLegacyAdapter.lean).

It provides:

- `Pic0FiniteStageGluePackage.toTransitionModelsData`
- `Pic0FiniteStageGluePackage.toTripleTransitionFamilyData`
- `Pic0FiniteStageGluePackage.toStable`
- Basic projection simp lemmas

The adapter derives the pair inverse from the legacy comparison data and uses the existing pinned presentation via `P.presentation`.

Validation was blocked by the workspace’s missing/unfinishable dependency compilation (`Pic0FiniteStageGlueDataFace`); LSP likewise reported dependency failure. The file remains uncommitted for that reason.
