# Refactor Report

## Slug
positiveGenusWitness-scaffold-iter134

## Status
COMPLETE

## Directive

### Problem
`STRATEGY.md` § M3 scheduled a `positiveGenusWitness` stub for iter-133+; it slipped iter-133 and the iter-134 strategy-critic re-raised the alternative. The iter-134 plan decision was to land the scaffold this iter in parallel with the piece (i.b) prover lane so the genus-stratified body restructure of `nonempty_jacobianWitness` (iter-157+) has both arms pre-named — `genusZeroWitness` is in place since iter-127, only the positive-genus arm was missing.

### Changes Requested
Insert a new `noncomputable def positiveGenusWitness` in `AlgebraicJacobian/Jacobian.lean`, immediately after `genusZeroWitness` (between the two existing declarations and before `nonempty_jacobianWitness`), with full docstring and `sorry` body. No edits to protected declarations, no blueprint edit.

## Changes Made

### File: `AlgebraicJacobian/Jacobian.lean`
- **What:** Inserted a new declaration `positiveGenusWitness` between the existing `genusZeroWitness` (now at lines 188–192) and `nonempty_jacobianWitness` (now at lines 233–236). The new declaration spans lines 194–215: ~21 lines of docstring + signature + `sorry` body, exactly matching the directive's specified body verbatim.
- **Why:** Per the directive, scaffolds the positive-genus arm so the iter-157+ genus-stratified body restructure of `nonempty_jacobianWitness` can land with both `by_cases` arms pointing at NAMED sub-theorems.
- **Cascading:** None. `positiveGenusWitness` has zero in-tree consumers (grep found only the new site in `Jacobian.lean` plus a pre-existing mention in `analogies/m3-route-audit.md` doc, not a Lean import).

No other files modified. No edits to `archon-protected.yaml` (the new declaration is not protected and need not be).

## New Sorries Introduced
- `AlgebraicJacobian/Jacobian.lean:215` — body of `positiveGenusWitness`. Closure is M3 work, off-critical-path until M2 closes (per STRATEGY.md § M3, user-escalation-pending).

## Compilation Status
- `AlgebraicJacobian/Jacobian.lean`: compiles. `lean_diagnostic_messages` returns exactly the expected four diagnostics — three `sorry` warnings (L188 `genusZeroWitness`, L211 `positiveGenusWitness` new, L233 `nonempty_jacobianWitness`) plus the pre-existing long-line linter warning on the `Jacobian` declaration (now L257; was L234 before the insertion shifted it down). No errors. No unexpected new diagnostics.
- Per-file sorry count for `Jacobian.lean`: **3** (was 2).
- Project sorry count: **4** (was 3), matching the directive's expected outcome.

## Notes for Plan Agent
- The diagnostic line columns shifted: the long-line warning that the iter-134 plan agent noted at L234 (the `noncomputable def Jacobian` header) is now at L257 because the new declaration added 23 lines. No new long-line warnings were introduced — both new `[SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]` lines on the new declaration are under 100 chars (they reuse the same indentation as the parallel line in `genusZeroWitness`, which is ≤100).
- The diagnostic line for `positiveGenusWitness`'s sorry is `211` (the `def` line) rather than the `sorry` literal line `215` — Lean attributes "declaration uses sorry" to the def header. This is the standard behavior for Lean 4 sorry diagnostics; the plan agent should expect the same on `task_pending.md` registration.
- The directive said to use `Nat.pos_of_ne_zero` for the eventual `by_cases` decomposition site but explicitly noted the scaffold itself does not need it; confirmed — no use of `Nat.pos_of_ne_zero` in the scaffold. The scaffold takes `(hg : 0 < genus C)` directly.
- Mathematical justification in the directive was sufficient; no improvisation needed.
- Suggested follow-up: register `positiveGenusWitness` in `.archon/task_pending.md` as a new M3 scaffold sorry (parallel to the existing `genusZeroWitness` entry). The directive said the plan agent handles this separately after the refactor returns; flagging here only as a reminder.
- No blueprint edit per directive (iter-134 blueprint-reviewer marked `Jacobian.tex` as `complete: true`; the new declaration can be left blueprint-undocumented this iter and the plan agent will add a `\lean{positiveGenusWitness}` hint in iter-135+).
