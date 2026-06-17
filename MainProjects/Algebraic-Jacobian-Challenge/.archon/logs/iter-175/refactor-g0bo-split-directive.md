# Refactor Directive

## Slug
g0bo-split

## Problem

`AlgebraicJacobian/Genus0BaseObjects.lean` is **1143 LOC** of mixed
concerns — `ProjectiveLineBar` scheme construction, 2-chart cover,
chart-ring iso (the largest sub-block at ~340 LOC), `k̄`-points 0/1/∞,
`Ga` / `Gm` groups, chart-bridge, the `𝔾ₘ`-scaling action `σ_×`, and
product-stability instances. Per `PROGRESS.md` commitment #1 (deferred
from iter-174 plan with explicit reversal trigger), and per the iter-174
review's progress-critic STUCK escalation trigger ARMing on Route 1 (4
consecutive PARTIAL on Lane A), this iter executes the deferred split as
the **structural response to the STUCK trigger**.

## Mathematical Justification

The 4 logical strata in the file are clean and dependency-ordered:

1. **Bare scheme + affine cover**: `ProjectiveLineBarScheme`,
   `ProjectiveLineBar`, `projectiveLineBarAffineCover`, plus their
   structural instances (`IsProper`, `geomIrred` (sorry-scaffold),
   `smoothOfRelDim` (sorry-scaffold)).
2. **Chart-ring iso** (the load-bearing iso `HomogeneousLocalization.Away 𝒜 (X i)
   ≃+* k̄[u]`): `homogeneousLocalizationAwayToMvPoly`,
   `mvPolyToHomogeneousLocalizationAway`,
   `homogeneousLocalizationAwayIso_aux_left`,
   `homogeneousLocalizationAwayIso_aux_right`,
   `mvPolyToHomogeneousLocalizationAway_surjective`,
   `homogeneousLocalizationAwayIso`, `homogeneousLocalizationAwayIso_algebraMap`.
3. **k̄-points + groups**: `ProjectiveLineBar.zeroPt/onePt/inftyPt`, `Ga`
   + instances, `Gm` + instances, `Gm.onePt`, `gm_grpObj` (sorry-scaffold).
4. **Chart-bridge + `𝔾ₘ`-scaling**: `awayι_comp_PLB_hom`,
   `gmScalingP1_chart0_ringMap`, `gmScalingP1_chart1_ringMap`,
   `gmScalingP1_cover`, `gmScalingP1_cover_X_iso` (private),
   `gmScalingP1_chart`, `gmScalingP1_chart_PLB_eq`,
   `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`,
   `gmScalingP1`, `gmScalingP1_collapse_at_zero`, product-stability
   instances on `ℙ¹ ⊗ 𝔾ₘ` (`projGm_locallyOfFiniteType`,
   `projectiveLineBar_isReduced`, `gm_geomIrred`, `projGm_geomIrred`,
   `projGm_isReduced`).

Each stratum compiles standalone given its strict-prefix dependencies.
The current file's section comments (L69, L197, L255, L595, L693, L733,
L823, L847, L1208) already mark these boundaries.

The split unblocks iter-175 Lane A's progress-critic STUCK corrective:
after split, the Lane A prover operates on
`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (only the
chart-bridge + `gmScalingP1` machinery), with a fresh context window
unburdened by the chart-ring iso's 340 LOC. The new file is small enough
that the prover can attempt the **chart-bridge structural pivot** recipe
(from `analogies/chart-bridge-structural-pivot.md`, dispatched this
plan-phase) — including the option of restructuring `gmScalingP1_cover_X_iso`
to avoid the `match i with` literal that drives the Fin syntactic mismatch
on Step C.

## Changes Requested

Split `AlgebraicJacobian/Genus0BaseObjects.lean` into 4 sub-files under
the new directory `AlgebraicJacobian/Genus0BaseObjects/`, plus a
re-export shim at the original path. Concretely:

### File: AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean (NEW)

- Imports: same import set the current file uses minus anything only
  needed downstream (in practice `import Mathlib` is fine; tighter
  imports can come iter-176+).
- Contents (current line ranges; move verbatim, preserve signatures):
  - L78-89: `projectiveLineBarGrading`, `projectiveLineBarGrading_gradedRing`.
  - L91-102: `algebraKbarAway` (with its docstring).
  - L105-117: `ProjectiveLineBarScheme`, `projectiveLineBarScheme_canOver`,
    `ProjectiveLineBar`.
  - L119-194: `projectiveLineBar_isProper`, `projectiveLineBar_geomIrred`
    (sorry-scaffold; keep verbatim), `projectiveLineBar_smoothOfRelDim`
    (sorry-scaffold; keep verbatim).
  - L207-253: `projectiveLineBarAffineCover` body + helpers + the
    irrelevant-ideal-spans lemma. (Includes the section comment "The
    2-chart affine cover of ℙ¹_{k̄}".)
- Namespace: `AlgebraicGeometry` (matching current).

### File: AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean (NEW)

- Imports: `import AlgebraicJacobian.Genus0BaseObjects.BareScheme`.
- Contents:
  - L255-263: section comment "The chart-ring iso".
  - L265-289: `otherFin_ne` and the small helpers around it.
  - L291-312: `homogeneousLocalizationAwayToMvPoly`.
  - L314-324: `mvPolyToHomogeneousLocalizationAway`.
  - L326-378: `homogeneousLocalizationAwayIso_aux_right`.
  - L379-526: `mvPolyToHomogeneousLocalizationAway_surjective` (large
    proof — keep verbatim; this is axiom-clean and load-bearing for
    the iso).
  - L528-543: `homogeneousLocalizationAwayIso_aux_left`.
  - L545-562: `homogeneousLocalizationAwayIso`.
  - L564-593: `homogeneousLocalizationAwayIso_algebraMap` (iter-174
    helper; keep verbatim).
- Namespace: `AlgebraicGeometry` (matching current).

### File: AlgebraicJacobian/Genus0BaseObjects/Points.lean (NEW)

- Imports:
  - `import AlgebraicJacobian.Genus0BaseObjects.BareScheme`.
  - `import AlgebraicJacobian.Genus0BaseObjects.ChartIso` (for any
    `homogeneousLocalizationAwayIso` use in point definitions; if the
    point definitions only need `Proj.fromOfGlobalSections` + `algebraKbarAway`,
    drop this import).
- Contents:
  - L595-675: `pointOfVec` and friends (the L595 section comment
    "standard `k̄`-points 0, 1, ∞ on ℙ¹").
  - L677-692: `ProjectiveLineBar.zeroPt`, `ProjectiveLineBar.onePt`,
    `ProjectiveLineBar.inftyPt`.
  - L693-732: Section (B) `Ga` and its instances (`gaScheme_canOver`,
    `Ga`, `ga_isAffineHom`, `ga_locallyOfFinitePresentation`,
    `ga_isReduced`).
  - L733-822: Section (C) `Gm` and its instances (`GmRing`, `GmScheme`,
    `gmScheme_canOver`, `Gm`, `gm_isAffine`,
    `gm_locallyOfFinitePresentation`, `gm_isReduced`,
    `gmRing_isDomain`, `gm_irreducibleSpace`, `gm_grpObj` (sorry-scaffold;
    keep verbatim), `gm_smooth`, `Gm.onePt`).
- Namespace: `AlgebraicGeometry` (matching current).

### File: AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean (NEW)

- Imports:
  - `import AlgebraicJacobian.Genus0BaseObjects.BareScheme`.
  - `import AlgebraicJacobian.Genus0BaseObjects.ChartIso`.
  - `import AlgebraicJacobian.Genus0BaseObjects.Points`.
- Contents:
  - L823-845: chart-bridge section comment + `awayι_comp_PLB_hom`.
  - L847-895: section (D) opening + `gmScalingP1_chart1_ringMap`,
    `gmScalingP1_chart0_ringMap`, `gmScalingP1_cover`.
  - L897-946: `gmScalingP1_cover_X_iso` (private; lemma to allow
    iter-175 Lane A's structural pivot — KEEP its current `match i with
    | 0 => … | 1 => …` form; the iter-175 prover may restructure it as
    part of its chart-bridge structural pivot per the analogist's
    recommendation).
  - L948-989: `gmScalingP1_chart`.
  - L991-1117: `gmScalingP1_chart_PLB_eq` (KEEP verbatim with its current
    2 residual sorries on Step C `i=0`/`i=1` cases — Lane A iter-175
    will close these).
  - L1120-1156: `gmScalingP1_chart_agreement` (KEEP verbatim with its 2
    cross-case sorries — Lane A iter-175 will close these).
  - L1158-1180: `gmScalingP1_over_coherence`.
  - L1182-1200: `gmScalingP1`.
  - L1202-1226: `gmScalingP1_collapse_at_zero` (KEEP verbatim sorry body).
  - L1208-end: Section (E) product-stability instances
    (`projGm_locallyOfFiniteType`, `projectiveLineBar_isReduced`,
    `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced`).
- Namespace: `AlgebraicGeometry` (matching current).

### File: AlgebraicJacobian/Genus0BaseObjects.lean (REWRITTEN AS RE-EXPORT SHIM)

Replace the entire 1143-LOC file with a small shim:

```lean
/-
Genus0BaseObjects.lean — re-export shim. Iter-175 split this file into
four sub-modules. All declarations are re-exported from their new homes
via `import` (Lean has no `export` ceremony for non-namespaced decls —
re-export is automatic from imports).

  - BareScheme.lean : ProjectiveLineBar scheme + 2-chart affine cover.
  - ChartIso.lean   : HomogeneousLocalization.Away 𝒜 (X i) ≃+* k̄[u]
                      chart-ring iso + its load-bearing helpers.
  - Points.lean     : k̄-points 0, 1, ∞ on ℙ¹; Ga; Gm.
  - GmScaling.lean  : chart-bridge + σ_× : ℙ¹ × 𝔾ₘ → ℙ¹ action +
                      product-stability instances on ℙ¹ ⊗ 𝔾ₘ.

Downstream files that `import AlgebraicJacobian.Genus0BaseObjects` see
exactly the same surface as before the split.
-/
import AlgebraicJacobian.Genus0BaseObjects.BareScheme
import AlgebraicJacobian.Genus0BaseObjects.ChartIso
import AlgebraicJacobian.Genus0BaseObjects.Points
import AlgebraicJacobian.Genus0BaseObjects.GmScaling
```

### Blueprint chapter — refresh `% archon:covers`

The consolidated chapter `blueprint/src/chapters/AbelianVarietyRigidity.tex`
currently has a `% archon:covers` line near the top covering
`AbelianVarietyRigidity.lean`, `Genus0BaseObjects.lean`, and
`RigidityLemma.lean`. **Extend the covers line to include the 4 new
sub-files**: add `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`,
`AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`,
`AlgebraicJacobian/Genus0BaseObjects/Points.lean`,
`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`. Keep
`Genus0BaseObjects.lean` in the list (it is now the re-export shim, but
the file still exists; the blueprint-doctor will not flag a missing
file). Single-line edit; **do not touch the chapter prose itself**.

## Affected Files

- `AlgebraicJacobian/Genus0BaseObjects.lean` (rewritten as re-export
  shim — see above).
- 4 NEW files under `AlgebraicJacobian/Genus0BaseObjects/` directory.
- `AlgebraicJacobian.lean` (top-level module list) — add the 4 new
  sub-files to the `import AlgebraicJacobian.Genus0BaseObjects.…` block
  (or rely solely on the shim re-import — verify which compiles cleanly).
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` — extend
  `% archon:covers` per above; no other edits.
- Downstream consumers (`AbelianVarietyRigidity.lean`, `Rigidity.lean`,
  `Jacobian.lean`, etc.): NONE should need editing — they `import
  AlgebraicJacobian.Genus0BaseObjects` which now re-exports the same
  surface via the shim.

## Expected Outcome

After the split:

- `lake build AlgebraicJacobian` exits 0.
- Total `declarations using sorry` count is **UNCHANGED at 30** (the
  same 8 sorries in the original G0BO file now live across the new
  sub-files — Lane A will reduce this count iter-175).
- Per-file sorry distribution (predicted):
  - `BareScheme.lean`: 2 (geomIrred + smoothOfRelDim, both scaffolds).
  - `ChartIso.lean`: 0.
  - `Points.lean`: 1 (`gm_grpObj`).
  - `GmScaling.lean`: 5 (chart_PLB_eq i=0, chart_PLB_eq i=1,
    chart_agreement (0,1), chart_agreement (1,0),
    collapse_at_zero) + 1 (gm_geomIrred from §E) + 1 (projGm_isReduced
    from §E) = 7 if the iter-174 line-count is accurate. (Confirm
    against the actual lake build sorry warnings post-split.)
- `lean_verify` on each sub-file returns kernel-only axioms (modulo the
  scaffolds whose declarations propagate `sorryAx`).
- The chapter `% archon:covers` extension means the blueprint-doctor's
  per-file mapping continues to work after the split.

## Iter-175 Lane A (post-split) preview — informational

Lane A iter-175 prover lane targets `Genus0BaseObjects/GmScaling.lean`.
It will receive `analogies/chart-bridge-structural-pivot.md` as required
reading (dispatched this plan-phase). The lane is explicitly authorised
to **restructure `gmScalingP1_cover_X_iso`** (the private helper that
drives the Fin literal mismatch via its `match i with` form) if the
analogist recommends that as the structural pivot. This is a
deliberate green-light: the iter-174 progress-critic CHURNING corrective
was hard scope-discipline; the iter-175 corrective is structural-pivot
authorisation.

## Hard rules

- Do not change any declaration's name, type signature, or argument
  order. Do not change any proof body (carry sorries verbatim where
  present).
- Do not introduce new axioms.
- Do not edit `archon-protected.yaml` (no protected declarations live
  in `Genus0BaseObjects.lean`; the file is project-bespoke).
- Do not touch the blueprint chapter's prose, `\lean{...}` pins, or
  `\leanok` markers — only the `% archon:covers` line is in scope.
- Verify the build is green after each file lands (incremental verification).
