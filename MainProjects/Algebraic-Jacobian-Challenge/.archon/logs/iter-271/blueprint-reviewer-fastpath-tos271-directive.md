# Blueprint-reviewer FAST-PATH re-review — iter-271

This is a HARD-GATE fast-path re-review focused on ONE chapter:
`blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (covers the two active Picard prover
lanes this iter: `TensorObjSubstrate.lean` and `TensorObjSubstrate/DualInverse.lean`). Read the
whole blueprint as usual, but the gate decision I need is specifically for this chapter.

## Context: prior verdict + what changed
- iter-270 (your prior pass) returned `Picard_TensorObjSubstrate.tex`: complete=partial, correct=partial.
  The `correct: partial` was attributed to ~9 `unmatched_lean` `\lean{}` pins that you classified as
  "stale renames — the real Lean names are now different".
- A blueprint-writer pass (iter-271, slug repin271) then grepped the ENTIRE Lean tree
  (`AlgebraicJacobian/**/*.lean`) for each of those 9 "real" target names and found that **none exist
  as a Lean declaration** — they appear only in comments/docstrings as PLANNED/forward targets. So the
  9 entries are NOT stale renames; they are **expected unformalized forward references** to
  not-yet-built (and several intentionally never-to-be-built: the ABANDONED general-pullback route
  `lem:pullback_tensor_iso`/`lem:pullback0_tensor_iso`, and the route-(e) `lem:jw_ismonoidal`)
  declarations — the SAME posture you already accept as "expected per strategy" for
  Picard_FlatteningStratification, Picard_QuotScheme, and Cohomology_FlatBaseChange TODO pins.
  The writer added in-source `% NOTE` annotations recording this for each block.

## What to adjudicate
Re-evaluate `Picard_TensorObjSubstrate.tex` ONLY on whether its MATHEMATICAL content for the
active prover cone is complete and correct — treating expected unformalized forward-reference pins
(now annotated in-source) the same way you treat the accepted TODO-pin specification chapters, i.e.
NOT as a `correct: partial` math defect. The active sorries the gate protects are:
- `sliceDualTransport.invFun` + round-trips (`lem:slice_dual_transport`, DualInverse.lean);
- `sheafificationCompPullback_comp_tail` R1/R5 recovery (`lem:pullback_tensor_map_basechange` Sq1-tail,
  TensorObjSubstrate.lean).
Confirm these two declarations' prose/sketches are sound and detailed enough to formalize.

Return a clear per-chapter verdict for `Picard_TensorObjSubstrate.tex` (complete / correct booleans +
any genuine must-fix that touches the two active declarations). If the only residual is the
forward-reference pins, say so explicitly and state whether the gate should be considered satisfied
for the two active lanes.
