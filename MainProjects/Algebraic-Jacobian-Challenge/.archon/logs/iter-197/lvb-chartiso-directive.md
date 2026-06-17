# Directive — lean-vs-blueprint-checker (ChartIso iter-197)

## Files

- Lean: `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`
- Blueprint chapter: the consolidated `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (which `% archon:covers` `BareScheme.lean` + `ChartIso.lean` per the iter-196 plan).

## iter-197 prover delta (for context)

Lane ChartIso closed 1 sorry (`projectiveLineBar_smooth_chart_aux`, L406)
axiom-clean via a new file-private helper `projectiveLineBar_smooth_chart_X`
(~50 LOC) that ports the per-chart standard-smooth-of-relative-dimension-1
property from the named-`X i` form, then uses `fin_cases` at the
cover-derived level.

Cascade: `projectiveLineBar_smoothOfRelDim` is now fully axiom-clean
(verified by the prover task report).

## Audit ask

1. Bidirectional check:
   - Lean → blueprint: does `ChartIso.lean`'s exported surface match
     the blueprint chapter (declaration names + signatures)?
   - Blueprint → Lean: does any `\lean{...}` pin in the chapter point
     at a stale name, or describe a different signature?
2. Is the iter-196 "Status (iter-196)" note in
   `lem:projectiveLineBar_smoothOfRelDim` now stale (the relocation
   landed iter-197 plan-phase + per-chart sorry closed iter-197
   prover-phase)?
3. Any block whose informal proof sketch references infrastructure
   that no longer matches the Lean (e.g. the cover-reduction wrapper
   `IsZariskiLocalAtSource.of_openCover`)?

## Output

Standard lean-vs-blueprint-checker per-file bidirectional report.
Flag must-fix-this-iter items clearly.

## Read scope

`AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean` and
`blueprint/src/chapters/AbelianVarietyRigidity.tex`.

Do NOT read STRATEGY.md / PROGRESS.md / iter sidecars / task results.
