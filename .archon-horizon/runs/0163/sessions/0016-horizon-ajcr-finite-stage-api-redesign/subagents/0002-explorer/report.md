Audit complete; no source edits made.

Key finding: the sole finite-stage `sorry` is `pic0FiniteStageFinalBaseChangeEquiv_naturality` at [Pic0FiniteStageFinalBaseChange.lean:1121](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange.lean:1121), currently ending at line 1157. It feeds both:

- `restrictionBaseChangeMap_naturality` at [Pic0FiniteStageRestrictionNaturality.lean:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionNaturality.lean:39)
- `rightRestrictionFinalBaseChangeEquiv_naturality` at [Pic0FiniteStageRightRestrictionNaturality.lean:46](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRightRestrictionNaturality.lean:46)

The legacy giant API is `Pic0FiniteStageGluePackage` fields at lines 152–193, with dependent instance reconstruction at lines 197–319. The stable facade was introduced specifically to avoid this.

Bounded refactor candidate: extend [Pic0FiniteStageStableRestrictionBaseChange.lean:36](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableRestrictionBaseChange.lean:36) with selected-presentation scheme-level factor/base-change lemmas, retaining opaque carriers and arbitrary presentation indices. Verification target: `"$HORIZON_BIN" check --lean AlgebraicJacobian/Picard/Pic0FiniteStageFinalBaseChange.lean`.
