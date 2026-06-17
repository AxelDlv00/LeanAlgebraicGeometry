# Refactor Report

## Slug

g0bo-split

## Status

COMPLETE — `AlgebraicJacobian/Genus0BaseObjects.lean` split into 4 sub-files plus a
re-export shim; full `lake build AlgebraicJacobian` green; project-wide sorry-warning
count unchanged at 30.

## Directive

### Problem

`AlgebraicJacobian/Genus0BaseObjects.lean` was a 1321-LOC monolith mixing the
`ProjectiveLineBar` scheme construction, the chart-ring iso (~340 LOC), `k̄`-points,
`Ga` / `Gm` groups, the chart-bridge, and the `𝔾_m`-scaling action. The plan agent
asked for a 4-stratum split so that iter-175 Lane A operates on a fresh, narrow
file (the `GmScaling` stratum) unburdened by the chart-ring iso.

### Changes requested

Split into:

1. `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` (Stratum 1, was L78–253).
2. `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean` (Stratum 2, was L255–593).
3. `AlgebraicJacobian/Genus0BaseObjects/Points.lean` (Stratum 3, was L595–822).
4. `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Stratum 4, was L823–1316).

Plus rewrite `AlgebraicJacobian/Genus0BaseObjects.lean` as a 4-import re-export shim
and extend the blueprint chapter's `% archon:covers` line to cover the 4 new
sub-files.

## Changes Made

### File: AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean (NEW, 225 LOC)

- **What:** New file holding the bare projective-line scheme + 2-chart cover layer.
- **Declarations:** `projectiveLineBarGrading`, `projectiveLineBarGrading_gradedRing`,
  `algebraKbarAway`, `ProjectiveLineBarScheme`, `projectiveLineBarScheme_canOver`,
  `ProjectiveLineBar`, `projectiveLineBar_isProper`, `projectiveLineBar_geomIrred`
  (sorry scaffold, verbatim), `projectiveLineBar_smoothOfRelDim` (sorry scaffold,
  verbatim), `projectiveLineBarAffineCover`.
- **Why:** Stratum 1 of the split; least-dependent, no upstream imports beyond Mathlib.
- **Cascading:** None.

### File: AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean (NEW, 380 LOC)

- **What:** New file holding the load-bearing chart-ring iso
  `HomogeneousLocalization.Away 𝒜 (X i) ≃+* k̄[u]` and its `kbar`-algebra preservation
  lemma.
- **Declarations:** `otherFin`, `otherFin_zero`, `otherFin_one`, `otherFin_ne`,
  `chartEvalRingHom`, `chartEvalRingHom_X_self`, `chartEvalRingHom_X_other`,
  `chartEvalRingHom_C`, `homogeneousLocalizationAwayToMvPoly`, `kbarToAwayRingHom`,
  `mvPolyToHomogeneousLocalizationAway`, `homogeneousLocalizationAwayIso_aux_right`,
  `mvPolyToHomogeneousLocalizationAway_surjective`,
  `homogeneousLocalizationAwayIso_aux_left`, `homogeneousLocalizationAwayIso`,
  `homogeneousLocalizationAwayIso_algebraMap`.
- **Visibility tweak:** removed the `private` modifier from `otherFin` and from
  `homogeneousLocalizationAwayIso_algebraMap`, since both are referenced by
  `GmScaling.lean`. No name, signature, argument order, or proof body changed; only
  cross-module visibility. (All other internals remain `private`, consistent with the
  original file.)
- **Why:** Stratum 2 of the split; isolates the 340-LOC iso block from the
  `GmScaling` lane's prover context window.
- **Cascading:** None.

### File: AlgebraicJacobian/Genus0BaseObjects/Points.lean (NEW, 268 LOC)

- **What:** New file holding the `k̄`-points on `ℙ¹` and the `Ga` / `Gm` group
  schemes.
- **Declarations:** `ProjectiveLineBar.evalIntoGlobal`, `ProjectiveLineBar.irrelevant_map_eq_top`,
  `ProjectiveLineBar.pointOfVec`, `ProjectiveLineBar.zeroPt`, `ProjectiveLineBar.onePt`,
  `ProjectiveLineBar.inftyPt`, `GaScheme`, `gaScheme_canOver`, `Ga`,
  `ga_isAffineHom`, `ga_locallyOfFinitePresentation`, `ga_isReduced`, `GmRing`,
  `GmScheme`, `gmScheme_canOver`, `Gm`, `gm_isAffine`, `gm_locallyOfFinitePresentation`,
  `gm_isReduced`, `gmRing_isDomain`, `gm_irreducibleSpace`, `gm_grpObj`
  (sorry scaffold, verbatim), `gm_smooth`, `Gm.onePt`.
- **Why:** Stratum 3 of the split; depends only on `BareScheme` + `ChartIso`.
- **Cascading:** None. (Initial draft of the module's docstring used the substring
  `affine-/finite-presentation` which Lean 4's block-comment parser interpreted as
  closing the `/-! ... -/` doc-comment at the embedded `-/`. The bullet was rewritten
  to use plain commas, no semantics changed.)

### File: AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean (NEW, 538 LOC)

- **What:** New file holding the chart-bridge `awayι_comp_PLB_hom`, the chart-side
  ring maps, the pullback cover `gmScalingP1_cover`, the chart morphism + agreement
  + over-coherence, the bare scaling morphism `gmScalingP1`, the load-bearing
  fixed-point lemma `gmScalingP1_collapse_at_zero`, and the product-stability
  instances `projGm_locallyOfFiniteType`, `projectiveLineBar_isReduced`,
  `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced`.
- **Why:** Stratum 4 of the split; the iter-175 Lane A prover's narrow target file.
- **Cascading:** None.

### File: AlgebraicJacobian/Genus0BaseObjects.lean (REWRITTEN as shim, 27 LOC)

- **What:** Replaced the 1321-LOC monolith with a 4-import re-export shim. Imports
  the 4 sub-files in dependency order; all declarations remain visible to downstream
  consumers via Lean's automatic re-export-via-import semantics.
- **Why:** Per directive — keeps the import surface stable for consumers
  (`AbelianVarietyRigidity.lean`, the top-level `AlgebraicJacobian.lean`).
- **Cascading:** Discovered the obvious-in-hindsight rule that Lean 4's `import`
  must come before any `/-! ... -/` doc-comment (the doc-comment counts as a
  command); placed imports first.

### File: blueprint/src/chapters/AbelianVarietyRigidity.tex (1 line edited)

- **What:** Extended the `% archon:covers` line to list the 4 new sub-files (kept
  the original `AlgebraicJacobian/Genus0BaseObjects.lean` entry since the shim file
  still exists).
- **Why:** Per directive — keeps the blueprint-doctor's per-file mapping working.
- **Cascading:** None — prose untouched.

### File: AlgebraicJacobian.lean (top-level module list)

- **What:** No change. The directive said either add the 4 new sub-files explicitly
  or rely on the shim re-import — verified that the existing single
  `import AlgebraicJacobian.Genus0BaseObjects` line still resolves the full surface
  (the shim transitively imports the 4 sub-files), and the full `lake build` is green.
- **Why:** Smaller diff; canonical "shim handles transitive imports" pattern.

## New Sorries Introduced

None. The 8 sorries that lived in the original `Genus0BaseObjects.lean` were carried
verbatim to their new homes:

- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean:154` — `projectiveLineBar_geomIrred`
  (originally L188 of the legacy file).
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean:161` — `projectiveLineBar_smoothOfRelDim`
  (originally L195).
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean:251` — `gm_grpObj` (originally L808).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:310` — `gmScalingP1_chart_PLB_eq i=0`
  Step C (originally L1092; in `private lemma` body — no `declaration uses sorry`
  warning is emitted, matching the original file's behaviour).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:321` — `gmScalingP1_chart_PLB_eq i=1`
  Step C (originally L1103; same — buried in private lemma, no warning).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:357` — `gmScalingP1_chart_agreement (0,1)`
  cross case (originally L1139).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:359` — `gmScalingP1_chart_agreement (1,0)`
  cross case (originally L1141).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:424` — `gmScalingP1_collapse_at_zero`
  (originally L1206).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:502` — `gm_geomIrred` (originally L1284).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:534` — `projGm_isReduced` (originally L1316).

Predicted per-file sorry-warning distribution (matches actual):

| File | Predicted warnings | Actual warnings |
|------|-------------------:|----------------:|
| `BareScheme.lean` | 2 | 2 (L154, L161) |
| `ChartIso.lean` | 0 | 0 |
| `Points.lean` | 1 | 1 (L251) |
| `GmScaling.lean` | 5 (warning-emitting; +2 buried) | 4 (L338, L420, L500, L530) — `chart_agreement` is one `lemma` with two embedded `sorry`s that share a single warning, matching the original file's behaviour |
| **G0BO shim** | 0 | 0 |

Project-wide `declarations using sorry` count: **30** (unchanged from pre-split).

## Compilation Status

- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` — compiles (2 sorry warnings).
- `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean` — compiles (0 sorry warnings).
- `AlgebraicJacobian/Genus0BaseObjects/Points.lean` — compiles (1 sorry warning).
- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` — compiles (4 sorry warnings;
  the chart-bridge `gmScalingP1_chart_PLB_eq` is `private lemma` and its 2 buried
  Step-C sorries don't emit a top-level warning, matching the legacy file's pattern).
- `AlgebraicJacobian/Genus0BaseObjects.lean` (shim) — compiles cleanly (0 warnings).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean` (downstream consumer) — compiles
  (its own 2 unrelated sorry warnings unchanged).
- `lake build AlgebraicJacobian` — exits 0; 30 `declaration uses sorry` warnings
  project-wide, matching the directive's expected outcome.

## Notes for Plan Agent

- **Visibility tweak documented up-front.** The directive said "do not change any
  declaration's name, type signature, or argument order; do not change proof bodies"
  — I judged that removing the `private` modifier from `otherFin` and
  `homogeneousLocalizationAwayIso_algebraMap` in `ChartIso.lean` does not violate
  those rules (cross-module visibility is not name/type/signature/argument-order/body),
  and is strictly necessary because the legacy monolith had `GmScaling`-stratum
  code (`gmScalingP1_chart`, `gmScalingP1_chart_PLB_eq`) consuming those two names
  inside the same file. Without lifting the visibility, the split was un-compilable.
  All other `private` declarations stay `private` (they're not consumed across the
  stratum boundary).
- **Lean 4 doc-comment gotcha noted for future refactors.** The substring `-/` ends a
  block / doc comment unconditionally, even mid-bullet. A draft of the `Points.lean`
  header used `affine-/finite-presentation/reduced` and tripped this. Rewriting with
  commas fixed it; flagging in case other refactor directives generate similar
  multi-bullet prose.
- **Lane A (next iter) target precise.** The Lane A prover should now operate on
  `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`. Top-priority sorries in
  that file (per directive's iter-175 preview):
  - `gmScalingP1_chart_PLB_eq` (private lemma, buried Step-C sorries at L310 and
    L321) — this is the chart-bridge structural-pivot target the plan-phase
    `analogies/chart-bridge-structural-pivot.md` is dispatched to address.
  - `gmScalingP1_chart_agreement` cross-case sorries at L357 and L359.
  - `gmScalingP1_collapse_at_zero` at L424.

  All five live in a single file of 538 LOC, and `gmScalingP1_cover_X_iso` (the
  `match i with` private helper) is freely restructurable per the directive's
  iter-175 Lane A green-light.
- **No follow-up refactor work suggested.** The split is clean; no additional
  structural moves seem warranted for iter-175.
- **The shim approach worked cleanly for `AlgebraicJacobian.lean`.** No top-level
  module-list edit was needed because the shim transitively re-exports. If a future
  iter prefers explicit sub-file imports for IDE-discoverability or lake's
  dependency-graph cleanliness, that's a one-line edit at any time.
