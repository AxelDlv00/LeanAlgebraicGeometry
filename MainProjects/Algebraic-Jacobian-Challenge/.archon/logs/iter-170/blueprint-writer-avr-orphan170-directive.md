# Blueprint-Writer Directive — Slug `avr-orphan170`

## Chapter

`blueprint/src/chapters/AbelianVarietyRigidity.tex`

## What to do (1 mechanical edit, 1 small additional cleanup)

### Edit 1 — DELETE the orphan `def:ga_grpObj` block (REQUIRED)

The Lean instance `AlgebraicGeometry.ga_grpObj` was DELETED from `AlgebraicJacobian/Genus0BaseObjects.lean` in iter-169 (SECONDARY-4 hygiene). The blueprint block at `AbelianVarietyRigidity.tex` L1020–L1040 still pins the deleted instance via `\lean{AlgebraicGeometry.ga_grpObj}`. The iter-169 lean-vs-blueprint-checker explicitly flagged this as a must-fix orphan; the iter-169 plan-writer NOTE already attached to the block (L1025-L1032) explicitly says "the iter-170 plan-writer should DELETE this entire block".

Action: delete the entire `\begin{definition}[The additive `GrpObj` structure on `𝔾_a`] ... \end{definition}` block (currently L1020–L1040, including its `\label{def:ga_grpObj}`, `\lean{AlgebraicGeometry.ga_grpObj}` pin, `\uses{def:ga}` edge, the iter-169 `% NOTE` comment, and the trailing prose). No other block in the chapter carries an incoming `\uses{def:ga_grpObj}` edge (verified via grep), so the deletion is purely local cleanup.

Then update `blueprint/lean_decls` to remove the line `AlgebraicGeometry.ga_grpObj` (currently line 134). Make a single-line removal; do NOT regenerate the whole file.

### Edit 2 — Refresh the iter-169 NOTE on `def:gaTranslationP1` (REQUIRED)

The block `def:gaTranslationP1` (L1164–L1223) carries an iter-169 `% NOTE` flagging that `gmScalingP1` ships `:= sorry` with three escalation options pending the iter-170 planner decision. Iter-170 has now MADE that decision: **option (c) inline chart-glue at scale, decomposed across iter-170 → iter-173 with named milestones per iter**.

Refresh the `% NOTE (iter-169)` block (L1169–L1178) to:

```latex
% NOTE (iter-170 decision): the iter-169 escalation surface CLOSED — the
% planner committed to option (c) inline chart-glue at scale (NOT option (a)
% Mathlib upstream PR, NOT option (b) accept `[CharZero]` fallback). The
% commitment is a bounded 3-4-iter decomposition of the chart-glue, with
% named per-iter milestones in `iter/iter-170/plan.md`. The Lean body of
% `gmScalingP1` still ships as a typed `sorry` THIS iter; iter-170 attacks
% Step A (chart-side ring maps `gmScalingP1_chart_i_ringMap`) + the
% `homogeneousLocalizationAwayIso_aux_left` residual (the iso's lone sorry,
% needed for Step B). iter-171/iter-172/iter-173 carry the rest.
% See `analogies/gmscaling-deep.md` for the full 6-step decomposition.
```

(Keep the surrounding `% Archon-original Lean encoding` and `% NOTE (iter-164/167)` comments — only swap the iter-169 NOTE for the iter-170 one.)

### Edit 3 — Refresh the iter-169 NOTE on `lem:gmScaling_fixes_zero` (REQUIRED)

The block `lem:gmScaling_fixes_zero` (L1225–L1240) carries an iter-169 `% NOTE` saying "gated sorry, strictly downstream". Refresh to:

```latex
% NOTE (iter-170 decision): the Lean body of `gmScalingP1_collapse_at_zero`
% remains a gated `sorry` — its discharge is strictly downstream of
% `gmScalingP1`'s body landing (per option (c) decomposition, this means
% landing in iter-173 at the earliest). Once `gmScalingP1` is concrete via
% the chart-glue, this collapse lemma reduces to a chart-1 direct computation
% via `Proj.fromOfGlobalSections_morphismRestrict`.
```

## What you MUST NOT do

- Do NOT add or remove `\leanok` or `\mathlibok` markers anywhere. The deterministic `sync_leanok` phase manages `\leanok`; the review agent manages `\mathlibok`. Even on the deleted block, do not touch markers — just delete the whole block atomically.
- Do NOT modify any other chapter or any other block in this chapter. Targeted minimum edit only.
- Do NOT spawn a child reference-retriever or any other subagent. No external sources are needed.

## Citation discipline

The chapter ships its citation discipline already (`% SOURCE`, `% SOURCE QUOTE`, `\textit{Source: ...}`). Your edits change only the noted iter blocks and the orphan block deletion; you don't need to add new citation blocks (none of the existing blocks loses its citation under this edit).

## Verification you should do

1. After the edit, `grep -n 'def:ga_grpObj\|ga_grpObj' AbelianVarietyRigidity.tex` should return zero hits.
2. After the `lean_decls` edit, `grep -n 'ga_grpObj' blueprint/lean_decls` should return zero hits.
3. The total chapter LOC drops by ~20 (the deleted block); the two NOTE refreshes are LOC-neutral.

## Output

Report at `task_results/blueprint-writer-avr-orphan170.md`. Cite the line numbers post-edit so a checker can re-verify.

## Out-of-scope flag

The lean-vs-blueprint-checker iter169 ALSO recommended (optional):
- adding per-decl `\lean{...}` pins for `projectiveLineBar_isProper` (axiom-clean) and disclosing the scaffold-sorry status of `projectiveLineBar_geomIrred` / `projectiveLineBar_smoothOfRelDim` under `def:genus0_base_objects`.

These are NOT in scope this iter. Do NOT do them. They will be picked up in a future hygiene writer-pass.
