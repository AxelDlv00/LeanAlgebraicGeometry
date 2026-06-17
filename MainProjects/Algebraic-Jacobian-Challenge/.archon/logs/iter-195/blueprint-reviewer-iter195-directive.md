# Directive — blueprint-reviewer `iter195`

## Context

iter-195 plan-phase dispatches 10 prover lanes, one of which is a
**NEW** lane on `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`
(close the 2-iter-aged scaffold sorrys `projectiveLineBar_smoothOfRelDim`
and `projectiveLineBar_geomIrred`).

BareScheme.lean is covered by `chapters/AbelianVarietyRigidity.tex`
via `archon:covers` (verified iter-195 plan-phase). Per the
HARD GATE rule, a prover dispatch on BareScheme.lean requires the
covering chapter to be `complete: true` AND `correct: true` AND with
no must-fix-this-iter finding.

The iter-194 verdict was COMPLETE (cleared HARD GATE via fastpath
for all chapters under active prover work). The iter-195 plan
expands the dispatch to include BareScheme.lean — hence this
scoped re-review.

## Your job

**Audit the whole blueprint** per your standard descriptor — DO NOT
limit your scope to AbelianVarietyRigidity.tex. The cross-chapter
view is part of the value.

But pay particular attention to:

1. **`chapters/AbelianVarietyRigidity.tex`** (consolidated chapter
   covering 7 Lean files including BareScheme.lean). Verify it
   contains adequate blueprint coverage for the two scaffold
   sorrys in `BareScheme.lean:151-163`
   (`projectiveLineBar_smoothOfRelDim` + `projectiveLineBar_geomIrred`).
   If coverage is missing or thin, that is a **must-fix-this-iter**
   blocking the iter-195 BareScheme dispatch.

2. **`chapters/RiemannRoch_H1Vanishing.tex`**. iter-194 fastpath
   cleared this chapter; iter-195 dispatches the closure attempt on
   `SAb.Exact` (sole remaining sorry inside `shortExact_app_surjective`).
   Verify the chapter's `\lemma`/`\theorem` blocks for
   `shortExact_app_surjective` document the `PreservesHomology` /
   stalkwise approach the prover will be using.

3. **`chapters/Picard_QuotScheme.tex`**. iter-195 plan-phase dispatches
   a refactor `lane-f-step12-sigma-pair` reshaping `step1` (Stacks
   01I8) and `step2` (Stacks 01HQ) signatures to Σ-pair form. Verify
   the chapter prose supports the Σ-pair signature (carrying the
   iso-characterizing identity alongside the existence of the iso).

4. **`chapters/Picard_Pic0AbelianVariety.tex`**. iter-194
   blueprint-writer landed WD-4 (stale-note + AddEquiv/LinearEquiv
   gap doc); iter-195 plan agent re-engages this lane cautiously
   (explore-and-commit-partial). Verify the chapter's 5 pinned
   declarations have current `\lean{...}` pins matching the
   Pic0AbelianVariety.lean file's current declaration names.

5. **All other chapters under active prover work this iter**:
   `RiemannRoch_WeilDivisor.tex`, `RiemannRoch_RationalCurveIso.tex`,
   `RiemannRoch_OCofP.tex`, `RiemannRoch_RRFormula.tex`. Verify they
   PASS the HARD GATE.

## Output format

Per the blueprint-reviewer descriptor: per-chapter checklist
(complete · correct · must-fix-this-iter) plus a verdict line
for each chapter. Also include a `## Unstarted-phase blueprint
proposals` section if any strategy phase still lacks blueprint
coverage.

Read the whole blueprint directly from `blueprint/src/chapters/`.
The list of chapter files is in your standard view of that
directory.

## Lean files under active prover work this iter (for cross-check)

- `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` (NEW LANE)
- `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- `AlgebraicJacobian/Picard/QuotScheme.lean`
- `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`
- `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean`
