Implemented in [Pic0FiniteStageOverlapBaseChange.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean:61):

- Three scheme-only projection lemmas for `nestedPullbackFlatteningIso`
- Generated reassociation lemmas via `@[reassoc]`
- Original isomorphism definition unchanged
- No commit created

Verification passed:

```text
LSP diagnostics: clean
lake env lean AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean: passed
```

The optional affine-intersection isomorphism was left as the next step; its intended final factor already appears inline in `Pic0FiniteStageGluingDiagramIso.lean`.
