# Blueprint Reviewer Directive

## Slug
iter175-fastpath

## Strategy snapshot

Same-iter fast-path re-review. The whole-blueprint review `iter175-whole`
(dispatched earlier this plan-phase) returned three `must-fix-this-iter`
flags on three chapters. Two of those flags were **timing artifacts**:
the blueprint-writers contracted to close them
(`blueprint-writer g0bo-helper-pins`,
`blueprint-writer weildivisor-doc-updates`) were running in parallel with
the reviewer and had not yet landed their edits at review time.

Both writers have now landed. This scoped re-review confirms HARD GATE
clearance on the two chapters before opening their prover lanes
this iter:

- `Lane A1` on `Genus0BaseObjects/GmScaling.lean` gates on
  `AbelianVarietyRigidity.tex` (the consolidated chapter covering the 4
  post-split G0BO sub-files).
- `Lane D` on `RiemannRoch/WeilDivisor.lean` gates on
  `RiemannRoch_WeilDivisor.tex`.

The third must-fix flag (`Picard_RelativeSpec.tex` stale `\leanok`
markers) is **deferred to `sync_leanok` investigation iter-176** — `\leanok`
markers are managed deterministically by the sync_leanok phase per
project CLAUDE.md and cannot be edited by writers/reviewers/planners.
This is not part of the present scoped re-review.

## Focus areas (scoped)

Audit **only these two chapters**:

1. `blueprint/src/chapters/AbelianVarietyRigidity.tex` — verify the iter-175
   `blueprint-writer g0bo-helper-pins` edits closed the original
   `iter175-whole` finding:
   - the chapter now `\lean{...}`-pins the iter-174 helpers
     `AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap` and
     `AlgebraicGeometry.gmScalingP1_chart_PLB_eq`.
   - no other regressions introduced by the writer pass.
   - HARD GATE: complete: true AND correct: true AND no must-fix.

2. `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` — verify the iter-175
   `blueprint-writer weildivisor-doc-updates` edits closed the original
   `iter175-whole` findings:
   - the `def:divisor_closed_point` "Lean signature scope" paragraph now
     documents the iter-174 junk-branch convention on
     `Scheme.WeilDivisor.ofClosedPoint`.
   - the chapter pins the two bridge equation lemmas
     `AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_single` and
     `AlgebraicGeometry.Scheme.WeilDivisor.ofClosedPoint_eq_zero`.
   - the `def:order_at_point` block has a "Lean signature scope"
     paragraph naming the analogist-recommended Mathlib API path
     (`WithZero.log (Ring.ordFrac (X.presheaf.stalk Y.point) f)` with
     `[Ring.KrullDimLE 1 (X.presheaf.stalk Y.point)]` explicit
     typeclass argument).
   - no other regressions introduced by the writer pass.
   - HARD GATE: complete: true AND correct: true AND no must-fix.

Skip every other chapter — those were already audited in `iter175-whole`
and the verdicts there stand.

## Known issues

- `Picard_RelativeSpec.tex` stale `\leanok` markers: out of scope for this
  fast-path; queued for iter-176 sync_leanok investigation per project
  CLAUDE.md (`\leanok` is sync_leanok's domain, not blueprint-writer's).
- `Albanese_AlbaneseUP.tex` `def:symmetric_power_curve` empty `\uses{}`:
  informational only per iter175-whole; cosmetic; not gating any lane.
- `Picard_FGAPicRepresentability.tex` / `Picard_RelPicFunctor.tex`
  `AlgebraicGeometry.Scheme.PicScheme` Lean-name collision: soon-severity
  rename, not must-fix this iter (no prover lane on the colliding
  declaration this iter).

## Routes

Single fast-path purpose: clear HARD GATE on 2 named chapters.
