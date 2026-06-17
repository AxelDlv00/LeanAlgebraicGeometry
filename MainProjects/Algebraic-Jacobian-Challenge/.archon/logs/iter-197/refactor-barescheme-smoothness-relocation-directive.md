# refactor directive — BareScheme smoothness instance relocation

## Slug
`barescheme-smoothness-relocation`

## Files in scope (write-domain)
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`
- `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`
- Any other file in `AlgebraicJacobian/Genus0BaseObjects/` IF needed
  to land the relocation.
- `AlgebraicJacobian.lean` (the umbrella file; if you need to add an
  import).
- Do NOT touch `archon-protected.yaml` — none of the declarations
  involved are protected.

## Goal

Per the iter-196 prover's task report
(`task_results/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean.md`):
the proof of `projectiveLineBar_smoothOfRelDim` is gated on the
per-chart smoothness aux `projectiveLineBar_smooth_chart_aux`, which
needs the chart-ring iso
`MvPolynomial (Fin 1) kbar ≃ₐ[kbar] HomogeneousLocalization.Away
(projectiveLineBarGrading kbar) (MvPolynomial.X i)`. That iso lives
in `Genus0BaseObjects/ChartIso.lean` — which is **downstream** of
`BareScheme.lean`, so `BareScheme.lean` cannot import it without
creating a cycle.

The fix is to **relocate** the two declarations
`projectiveLineBar_smoothOfRelDim` (and its private helper
`projectiveLineBar_smooth_chart_aux`) to a file where `ChartIso`'s
`homogeneousLocalizationAwayIso` is in scope. The recommended target
is `Genus0BaseObjects/ChartIso.lean` (it already has the iso); if
ChartIso is too cluttered, create a fresh
`Genus0BaseObjects/Smooth.lean` that imports both BareScheme.lean and
ChartIso.lean.

## Required actions (in order)

### Step 1 — Choose the target file

Read `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean` (size,
namespace, imports) and decide:

- Option (a): Move both declarations into ChartIso.lean. Choose this
  if ChartIso.lean has fewer than ~600 LOC and its existing namespace
  matches `AlgebraicGeometry` open with the same imports.
- Option (b): Create new file `Genus0BaseObjects/Smooth.lean` that
  imports both BareScheme and ChartIso, and host the relocated
  declarations there.

Justify the choice in the task report.

### Step 2 — Move the declarations

In source order:

1. The private helper `projectiveLineBar_smooth_chart_aux` (BareScheme.lean
   ~L312 docstring + L316-330 declaration).
2. The instance `projectiveLineBar_smoothOfRelDim` (BareScheme.lean
   L325-337 — note the iter-196 cover-reduction body).

When moving:
- Preserve the EXACT statement (signature, types, namespace path).
- Preserve the proof body, including the existing per-chart sorry IF
  the target file does NOT yet have the chart-ring iso in scope. The
  goal of this refactor is RELOCATION, not closure — the prover
  closes the sorry after relocation lands.
- Add any necessary `open` and `import` statements at the top of the
  target file.

### Step 3 — Remove from BareScheme.lean

Remove the two declarations from BareScheme.lean and leave a
`-- NOTE iter-197: relocated to <target file> per BareScheme
smoothness-relocation refactor.` comment in their place (one comment,
not two; reference the target file path).

### Step 4 — Update AlgebraicJacobian.lean

If you chose Option (b) and created a new `Smooth.lean`, update
`AlgebraicJacobian.lean` (the umbrella import file) to include the
new import. If Option (a), no umbrella change needed.

### Step 5 — Verify

- Run `lake build AlgebraicJacobian` and confirm it succeeds.
- Run `lean_verify AlgebraicGeometry.projectiveLineBar_smoothOfRelDim`
  and confirm the axiom set is `[propext, Classical.choice,
  Quot.sound, sorryAx]` (sorryAx still present because the per-chart
  sorry is unchanged) and that no NEW axioms appear.
- Confirm the build's sorry count is UNCHANGED (relocation does not
  affect sorry count; if it does, your relocation introduced a bug
  — abort and revert).

### Step 6 — Do NOT close any sorries

Per the refactor descriptor: refactor subagents NEVER fill sorries.
If you find yourself starting to close `projectiveLineBar_smooth_chart_aux`
because `homogeneousLocalizationAwayIso` is now in scope, STOP. That
is the iter-197 prover's job (separate dispatch, file=ChartIso.lean
or Smooth.lean depending on your choice).

## Report

Write to `task_results/refactor-barescheme-smoothness-relocation.md`:

- Summary: which target file (a vs b), why.
- Diffs: declaration headers moved, imports added, comments left at
  origin sites.
- Build status: `lake build AlgebraicJacobian` exit code + sorry count
  (should be UNCHANGED).
- Lean_verify output for `projectiveLineBar_smoothOfRelDim` post-move
  (should still show `sorryAx`).
- Any unexpected coupling (other declarations that depended on the
  moved ones via implicit import; downstream files that broke).

## Out of scope

- Closing the per-chart sorry (prover job).
- Touching `projectiveLineBar_geomIrred` (unrelated; ~200-350 LOC
  substrate gap).
- Touching any other declaration in BareScheme.lean or ChartIso.lean.
- Renaming protected declarations.
- Changing `archon-protected.yaml`.

## References

- `task_results/AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean.md`
- `task_results/lean-vs-blueprint-checker-barescheme.md`
- iter-196 review's iter-197 commitment #2: "BareScheme smoothness
  closure via refactor relocating the instance to a downstream file
  (CRIT-2)".
