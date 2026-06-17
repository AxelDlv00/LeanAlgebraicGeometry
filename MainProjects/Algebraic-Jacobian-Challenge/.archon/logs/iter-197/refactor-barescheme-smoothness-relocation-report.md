# Refactor Report

## Slug
barescheme-smoothness-relocation

## Status
COMPLETE

## Directive
**Problem**: `projectiveLineBar_smoothOfRelDim` and its private helper
`projectiveLineBar_smooth_chart_aux` lived in `BareScheme.lean`, but the proof of
the helper needs `homogeneousLocalizationAwayIso` from `ChartIso.lean`, which is
downstream of `BareScheme.lean` — creating an import cycle if left there.

**Changes requested**: Relocate the two declarations to a file where `ChartIso`'s
`homogeneousLocalizationAwayIso` is in scope.

## Target File Choice
**Option (a): moved into `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`.**

Rationale:
- ChartIso.lean was 381 LOC (well under the 600 LOC threshold).
- ChartIso.lean already imports `BareScheme.lean`, is in the same
  `namespace AlgebraicGeometry`, has the same `universe u` declaration, and has
  identical `open` statements — no new imports or opens were needed.
- `homogeneousLocalizationAwayIso` is defined at ChartIso.lean:328, so after
  relocation the sorry in `projectiveLineBar_smooth_chart_aux` can be closed
  without any further structural change.
- No new file was required; Option (b) would have added unnecessary indirection.

## Changes Made

### File: `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`
- **What**: Added a new section `/-! ### SmoothOfRelativeDimension 1 instance via
  the 2-chart cover -/` immediately before `end AlgebraicGeometry` (new lines
  378–419). Contains verbatim copies of `projectiveLineBar_smooth_chart_aux`
  (private lemma, with sorry preserved) and `projectiveLineBar_smoothOfRelDim`
  (instance). Docstrings updated to reflect "this file" for
  `homogeneousLocalizationAwayIso` and "BareScheme.lean" for
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension`.
- **Why**: ChartIso.lean has `homogeneousLocalizationAwayIso` in scope, so the
  relocation unblocks the per-chart sorry closure.
- **Cascading**: None — ChartIso.lean is downstream of BareScheme.lean; no other
  file imported the moved declarations directly.

### File: `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`
- **What**: Removed the section header `/-! ### SmoothOfRelativeDimension 1 ... -/`
  and the two declarations (`projectiveLineBar_smooth_chart_aux`,
  `projectiveLineBar_smoothOfRelDim`) from lines 300–339. Replaced with a single
  NOTE comment at line 300:
  ```
  -- NOTE iter-197: relocated to AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean per BareScheme smoothness-relocation refactor.
  ```
- **Why**: Removes the now-duplicate copy; ChartIso.lean hosts the canonical version.
- **Cascading**: None — the private helper was not accessible outside BareScheme.lean;
  the instance `projectiveLineBar_smoothOfRelDim` is accessible via ChartIso.lean
  which is imported by the umbrella `AlgebraicJacobian.lean` transitively.

## New Sorries Introduced
None. The one sorry in `projectiveLineBar_smooth_chart_aux` was **relocated**, not
introduced. Sorry count across both files is unchanged.

- Before: BareScheme.lean had 1 actual sorry (`projectiveLineBar_geomIrred`, line 220)
  + 1 actual sorry (`projectiveLineBar_smooth_chart_aux`, old line 330) = 2 sorries.
- After: BareScheme.lean has 1 actual sorry (`projectiveLineBar_geomIrred`, line 220);
  ChartIso.lean has 1 actual sorry (`projectiveLineBar_smooth_chart_aux`, line 406).
  Total = 2 sorries. Unchanged.

## Compilation Status
- `lake build AlgebraicJacobian`: **exit 0, Build completed successfully (8361 jobs)**
- `BareScheme.lean`: compiles, no errors.
- `ChartIso.lean`: compiles, no errors.
- `lean_verify AlgebraicGeometry.projectiveLineBar_smoothOfRelDim`:
  axioms = `[propext, sorryAx, Classical.choice, Quot.sound]`.
  No new axioms vs. pre-refactor.

## Notes for Plan Agent
- The iter-197 prover assigned to `ChartIso.lean` (or `Smooth.lean`) can now close
  the `projectiveLineBar_smooth_chart_aux` sorry: `homogeneousLocalizationAwayIso`
  is in scope, and the missing ~10 LOC reduction is:
  ```
  exact (mvPolynomialFin_isStandardSmoothOfRelativeDimension kbar 1).of_algEquiv
    (homogeneousLocalizationAwayIso kbar i).toAlgEquiv
  ```
  (or similar — prover's judgement).
- No changes were needed to `AlgebraicJacobian.lean` (ChartIso.lean was already
  imported transitively).
- No protected declarations were involved; `archon-protected.yaml` was not touched.
