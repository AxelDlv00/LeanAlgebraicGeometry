# Directive: blueprint-reviewer-iter123 (whole-blueprint audit)

## Mode

Whole-blueprint audit. Read every chapter in
`blueprint/src/chapters/*.tex` and produce the per-chapter
checklist (`complete: true|partial|false`, `correct: true|false`).

## Particular focus for this iter

The iter-123 prover lane will target
`AlgebraicJacobian/Differentials.lean` (M1.b body — Steps 1-4 of
`IsLocalization.of_le`). Confirm HARD GATE clearance on
`Differentials.tex`, specifically:

1. Is the proof of `lem:appLE_isLocalization` (Steps 0-4 at lines
   162-188) detailed enough to guide a prover formalizing the
   remaining Steps 1-4 (Step 0 was closed iter-122)?
2. Is the namespace `IsAffineOpen` correct? (The lemma is in
   `AlgebraicGeometry.IsAffineOpen` namespace per the analogist's
   iter-121 recommendation.)
3. Are all `\uses{...}` links well-formed (no broken refs, no
   wrong-direction uses)?

Also re-check chapters that received iter-121/122 edits:
- `Jacobian.tex` (one-sentence rigidity step C.2 was expanded iter-121
  to a 7-step ~110 LOC nested itemize; line 376 + 388 base-change
  framing landed iter-122). Confirm the M2 chain is still consistent
  and complete enough for an iter-124+ M2.a prover lane.

## Inputs

- Read every `blueprint/src/chapters/*.tex` file directly.
- The Lean file slug mapping is `Foo/Bar.lean → Foo_Bar.tex`.
- The relevant `.lean` files (read for cross-checking only —
  signatures, declaration existence):
  - `AlgebraicJacobian/Differentials.lean` (2 sorries on entry to
    iter-123: L304 `appLE_isLocalization`; iter-122 left 1 sorry
    after closing 3 of the 4 introduced this iter).
  - `AlgebraicJacobian/Jacobian.lean` (1 sorry at L179
    `nonempty_jacobianWitness`).
  - All others compile clean.

## Hard requirements for HARD GATE clearance

For each chapter C corresponding to a file F that the planner will
add to `## Current Objectives`:

- `complete: true` AND `correct: true` AND no must-fix-this-iter
  finding touches C AND no broken `\uses{}` in C points at a label
  F's blueprint depends on.

Files the planner WILL add to objectives this iter:
- `AlgebraicJacobian/Differentials.lean` → chapter `Differentials.tex`.

For each file F NOT in objectives but flagged by the audit as having
HARD GATE issues, list the issues and recommend whether to dispatch
a blueprint-writer this iter.

## Output format

Per-chapter checklist + a flagged-issues block + dispatcher-actionable
must-fix-this-iter findings.
