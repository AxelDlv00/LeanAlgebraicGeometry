# Lean ↔ Blueprint Checker Directive

## Slug
barescheme

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/AbelianVarietyRigidity.tex

(BareScheme.lean is covered by the consolidated AbelianVarietyRigidity.tex per its
`% archon:covers` declaration. The iter-195 blueprint-writer landed two `\lemma`
blocks at AVR.tex L951-993 covering the smoothness + geom-irred substrate.)

## Focus areas
- iter-196 added 5 axiom-clean MvPolynomial Submersive-presentation substrate
  declarations (`mvPolyGenerators`, `mvPolyPresentation`,
  `mvPolyPreSubmersivePresentation`, `mvPolySubmersivePresentation`,
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension`) at L165-211.
  Verify the blueprint chapter mentions or motivates this Mathlib supplement —
  if not, the chapter prose may need expansion to surface this substrate.
- `projectiveLineBar_smoothOfRelDim` (L325) now uses the cover-reduction recipe
  delegating to `projectiveLineBar_smooth_chart_aux` (L316). Verify the
  blueprint sketch references this cover reduction.
- `projectiveLineBar_geomIrred` (L218) remains an unchanged bare sorry; the
  blueprint chapter expansion at AVR.tex L951-993 should describe the recipe
  (Helper A `Proj 𝒜 ⊗ K ≅ Proj 𝒜 ×_S Spec K` + Helpers B-E).

## Out of scope
- ChartIso.lean (separate file).
