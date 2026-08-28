Audit result: the next real boundary is not another object isomorphism. `gluingOverlapIso` is already defined at [Pic0FiniteStageGluingDiagramIso.lean:88](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:88), but it has no multispan/projection naturality theorem, so it has no downstream use besides `#check`/axiom audit.

The missing producer is the two-leg compatibility package for that iso, preferably exported as:
```lean
gluingOverlapIso_hom_comp_f :
  (gluingOverlapIso C P U V).hom ≫ (pic0SepClosedAtlasGlueData C).f U V =
    (Scheme.Pullback.gluing ...).f U V ≫ (gluingChartIso C P U).hom

gluingOverlapIso_hom_comp_t_comp_f :
  (gluingOverlapIso C P U V).hom ≫
      (pic0SepClosedAtlasGlueData C).t U V ≫
      (pic0SepClosedAtlasGlueData C).f V U =
    (Scheme.Pullback.gluing ...).t U V ≫
      (Scheme.Pullback.gluing ...).f V U ≫
      (gluingChartIso C P V).hom
```
This is one bounded “diagram-compatibility producer,” although it necessarily has two projection equations. It is the immediate prerequisite for constructing the global base-changed glued-scheme map/iso from the chart maps, then composing with `baseChangeGluingIso` ([Pic0FiniteStageGluingBaseChange.lean:37](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean:37)). No source consumer currently exists; `rg` finds `gluingOverlapIso` only at its definition and `Pic0CriticalPath` audits.

Proof ingredients are all present:
- Flattened source projections: [Pic0FiniteStageOverlapBaseChange.lean:165](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean:165), [195](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean:195), [226](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageOverlapBaseChange.lean:226).
- Structure-map rewrite: `glueData_f_comp_inclusion_comp_gluedMap` at [GluingDiagramIso:52](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:52).
- Ring-level left-leg square: `restrictionBaseChangeMap_naturality` at [RestrictionNaturality:39](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionNaturality.lean:39).
- Exact affine identification: `exactRestrictionAlgHom_fromSpec` at [GluingDiagramIso:67](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingDiagramIso.lean:67).
- Final target pullback projections: `isPullback_opens_inf.isoPullback_hom_fst/snd`.

Strategy: unfold only the composite iso once; reassociate; use the corresponding `gluingOverlapFlatteningIso_*` equation, simp the `pullback.congrHom` projection, apply the restriction naturality square, then close the final target leg with `exactRestrictionAlgHom_fromSpec` and `isoPullback_hom_fst/snd`. The right equation additionally uses the already-rooted right-leg identity chain (`transition_comp_restrictionLeft_eq_restrictionRight` etc., checked at [Pic0CriticalPath.lean:800](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:800)).

Evidence from commits: `b914523466` added the package-specialized flattening; `663dea427f` added the object-level overlap iso; `51baf6e6bc` added exactly the three source projection lemmas. All are ancestors of current HEAD. Session `0054` is no longer report-less at HEAD and contains no proof attempt: it terminated during orientation, so the substantive handoff remains the `0042` commits.
