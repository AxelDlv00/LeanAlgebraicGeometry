# Lean ↔ Blueprint Checker Directive

## Slug
g0bo171

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex

(The blueprint chapter that covers `Genus0BaseObjects.lean` is `AbelianVarietyRigidity.tex`
via the `% archon:covers` declaration near the top of the chapter. This is the
canonical pairing for this Lean file.)

## Known issues

- 10 sorries on G0BO are tracked and known (see iter-171 prover task result at
  `.archon/task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md`):
  L188 `projectiveLineBar_geomIrred`, L195 `projectiveLineBar_smoothOfRelDim`,
  L375 `mvPolyToHomogeneousLocalizationAway_surjective`,
  L624 `gm_grpObj`, L697 `gmScalingP1_chart`, L711 `gmScalingP1_chart_agreement`,
  L727 `gmScalingP1_over_coherence`, L766 `gmScalingP1_collapse_at_zero`,
  L844 `gm_geomIrred`, L876 `projGm_isReduced`. Do NOT re-flag each as "missing proof";
  ONLY flag if the body is fake (e.g. `:= True`) or the blueprint claims a substantive
  proof that is hidden behind a placeholder.
- The body of `gmScalingP1` is now a concrete `Over.homMk + Scheme.Cover.glueMorphisms`
  with the three named internal sorries factored out. This is the planner's expected shape.
- `homogeneousLocalizationAwayIso_aux_left` body was rewritten this iter to a real
  cancel-surjective proof that depends on `mvPolyToHomogeneousLocalizationAway_surjective`.

Standard bidirectional report. Pay particular attention to:
1. Does the blueprint's `\lean{...}` hints precisely pin the names introduced this iter?
2. Has the blueprint been updated to mention the three internal helpers
   (`gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`)?
   (They may legitimately be unreferenced as internal scaffold — flag only if the chapter
   should have predicted them.)
3. Are there any excuse-comments left on declarations the chapter claims are real?
