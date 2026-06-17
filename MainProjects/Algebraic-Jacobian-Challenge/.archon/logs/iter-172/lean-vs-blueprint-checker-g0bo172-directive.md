# Lean ↔ Blueprint Checker Directive

## Slug
g0bo172

## Lean file
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects.lean`

## Blueprint chapter
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex`

(The `% archon:covers` declaration in `AbelianVarietyRigidity.tex` covers `Genus0BaseObjects.lean` for this iter; the chapter blueprints the relevant declarations including `mvPolyToHomogeneousLocalizationAway_surjective`, `homogeneousLocalizationAwayIso`, `gmScalingP1` and helpers.)

## Iter-172 changes this iter
- Closed `mvPolyToHomogeneousLocalizationAway_surjective` (L379) axiom-clean.
- Updated docstring on `gmScalingP1_chart` (L831-839) to record that PRIMARY 1 unblocked `homogeneousLocalizationAwayIso` axiom-clean.
- Three named scaffold sorries unchanged: `gmScalingP1_chart` (L847), `gmScalingP1_chart_agreement` (L861), `gmScalingP1_over_coherence` (L877).

## Audit scope
Bidirectional per the standard checker prompt:
(A) Does the Lean follow the blueprint? — verify each `\lean{...}` block in `AbelianVarietyRigidity.tex` maps to the right Genus0BaseObjects declaration with a faithful signature + proof following the chapter's sketch. Pay attention to the new pin `lem:mvPoly_to_homogeneousLocalization_away_surjective` (added this iter by `blueprint-writer surjective-pin`).
(B) Is the blueprint adequate? — for any Lean declaration on G0BO that has no `\lean{...}` pin in any chapter, flag the chapter gap. For example, named helpers `pointOfVec`, `gmScalingP1_chart{0,1}_ringMap`, `gmScalingP1_cover`, etc.

## Out of scope
- AVR.tex declarations covering `AbelianVarietyRigidity.lean` declarations (different file).
- Sibling Lean files (`RigidityLemma.lean`, etc.).
