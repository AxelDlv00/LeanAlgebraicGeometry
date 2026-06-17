# Blueprint-reviewer directive — slug `avr-fastpath173`

## Scope (SAME-ITER FAST PATH — scoped to ONE chapter)

Re-review **only** `blueprint/src/chapters/AbelianVarietyRigidity.tex`. Do NOT read other chapters.

## Context

Iter-173 plan-phase: `blueprint-reviewer route173` returned HARD-GATE-BLOCKED PRE-REPAIR for the `AlgebraicJacobian/Genus0BaseObjects.lean` prover lane because the chapter did not pin the three named scaffold sorries `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` with per-decl `\lean{...}` blocks.

In the same plan-phase, `blueprint-writer g0bo-pin-scaffolds` LANDED with four new blocks inserted after `def:gaTranslationP1`:
- `def:gmscaling_cover` (`\lean{AlgebraicGeometry.gmScalingP1_cover}`)
- `def:gmscaling_chart` (`\lean{AlgebraicGeometry.gmScalingP1_chart}`)
- `lem:gmscaling_chart_agreement` (`\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}`)
- `lem:gmscaling_over_coherence` (`\lean{AlgebraicGeometry.gmScalingP1_over_coherence}`)

each with `\uses{...}` dependency graph + prose recipe + forward refs to `analogies/chart-bridge.md` (iter-173 in flight, may not exist yet).

## Question

Does `AbelianVarietyRigidity.tex` now CLEAR HARD GATE for the `Genus0BaseObjects.lean` prover lane?

Specifically:

- Are the three new blocks (`def:gmscaling_chart`, `lem:gmscaling_chart_agreement`, `lem:gmscaling_over_coherence`) **complete + correct** with prose detail sufficient to formalize?
- Is the new `def:gmscaling_cover` correctly anchored (it's an extra block beyond the directive's minimum)?
- Does the chapter's `\uses{...}` graph remain internally consistent after the four new blocks?
- Are the `\lean{...}` pins well-formed and pointing at existing Lean declarations?
- Are there any new findings that gate the prover lane that the writer missed?

## Constraints on your output

- One-line verdict: `complete: true/partial/false`, `correct: true/partial/false`, must-fix-this-iter findings (or `none`).
- If `complete: true` AND `correct: true` AND no must-fix touches the chapter, HARD GATE CLEARS for the lane and the iter-173 prover may dispatch this iter.
- Otherwise enumerate the remaining must-fix items.
- The whole AVR chapter is in scope (≥1750 LOC), but the bulk of your attention should be on the four new blocks and their integration with the existing chapter.
