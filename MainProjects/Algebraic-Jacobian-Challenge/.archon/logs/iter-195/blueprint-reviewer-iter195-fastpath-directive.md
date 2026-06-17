# Directive — blueprint-reviewer `iter195-fastpath`

## Mode

**Scoped re-review** — limited to the single chapter
`AbelianVarietyRigidity.tex` whose iter-195 `blueprint-reviewer
iter195` verdict was `complete: false` (must-fix HARD GATE blocker:
missing `\lean{...}` blocks for `BareScheme.lean` scaffold sorrys).

The plan agent dispatched a `blueprint-writer barescheme-pins` round
that added two new `\begin{lemma}` blocks at lines 951-993:

- `lem:projectiveLineBar_smoothOfRelDim` (L951-971)
- `lem:projectiveLineBar_geomIrred` (L972-993)

Both blocks pin via `\lean{...}` at the
`BareScheme.lean:151-163` declaration names verbatim.

## Your job

Verify ONLY this chapter:

- Does `AbelianVarietyRigidity.tex` now have `complete: true` for
  BareScheme.lean coverage?
- Are the two new `\lean{...}` pins syntactically and semantically
  valid (correct declaration names that exist in
  `BareScheme.lean:151-163`)?
- Is the prose mathematically reasonable for formalization?
- Are there any new must-fix-this-iter findings introduced by the
  writer's edits?

Do NOT audit other chapters this dispatch; this is a scoped
fast-path clearance per the HARD GATE rule.

## Output

Per the standard descriptor: per-chapter checklist limited to
`AbelianVarietyRigidity.tex`. The plan agent will use the
`complete + correct + no must-fix` verdict (if positive) to clear
the iter-195 BareScheme.lean prover dispatch.

If the verdict is positive: add BareScheme.lean back to the iter-195
prover dispatch.

If the verdict is still `partial | false` on either axis: BareScheme
defers to iter-196.
