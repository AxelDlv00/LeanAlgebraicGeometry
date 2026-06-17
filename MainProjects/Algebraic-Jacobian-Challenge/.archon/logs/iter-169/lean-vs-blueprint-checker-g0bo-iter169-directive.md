# Directive — lean-vs-blueprint-checker (Genus0BaseObjects.lean ↔ AbelianVarietyRigidity.tex, iter-169)

## Files in scope (one per dispatch — this is the dispatch)

- **Lean**: `AlgebraicJacobian/Genus0BaseObjects.lean`
- **Blueprint chapter**: `blueprint/src/chapters/AbelianVarietyRigidity.tex`
  (note: the chapter declares `% archon:covers AbelianVarietyRigidity.lean Genus0BaseObjects.lean RigidityKbar.lean Jacobian.lean`
  near its top — the AVR chapter covers G0BO content; verify that the G0BO definitions still
  match their pinned `\lean{...}` blocks under `def:genus0_base_objects` and friends.)

## What changed this iter

The prover's task_result lives at
`.archon/task_results/AlgebraicJacobian_Genus0BaseObjects.lean.md`. Summary:

1. **SECONDARY-4 deletion**: `ga_grpObj` instance (and the downstream-only `ga_smooth`
   instance) DELETED from `Genus0BaseObjects.lean`. Blueprint pin `\lean{ga_grpObj}` is
   now ORPHANED (the chapter still references it under `def:genus0_base_objects` and via
   `def:ga_grpObj` — please flag whether it still does after the iter-167 writer round).
2. **SECONDARY-1/2/3** + the PRIMARY docstrings on `gmScalingP1` and
   `gmScalingP1_collapse_at_zero` were rewritten honestly. Bodies of `gmScalingP1` (L685)
   and `gmScalingP1_collapse_at_zero` (L709) remain `sorry`.
3. No new declarations landed; no `\lean{...}` pins need adding from the Lean side.

## What to verify

- **Lean → blueprint**: does the blueprint chapter `\lean{ga_grpObj}` still exist? If yes,
  flag as ORPHANED and recommend the iter-170 plan-writer remove the corresponding block
  (and its `\uses{}`/`\proves{}` connections). Same check for `ga_smooth` if it had a pin.
- **Blueprint → Lean**: are all `\lean{...}` references in
  `def:genus0_base_objects` / `def:ga_grpObj` / `def:gm_grpObj` /
  `def:gaTranslationP1` / `lem:gmScaling_fixes_zero` / `def:projlinebar_affine_cover` /
  `def:proj_chart_ring_iso` / `lem:proj_chart_ring_iso_aux_left` /
  `lem:projlinebar_isReduced` still pointing at declarations that exist in
  `Genus0BaseObjects.lean`? Any rename / deletion drift?
- **Stale narrative**: does the AVR chapter's iter-NNN-stamped prose (if any) still match
  what the Lean file actually does? In particular, the chapter section
  `\subsection{The \texorpdfstring{$\mathbb{G}_m$}{Gm}-scaling action}` (around L640+)
  describes the `σ_×` construction — does the Lean side's iter-169 honest TODO docstring
  agree with what the chapter promises?

## Out of scope

- Other `.lean` files (AVR, Jacobian, RigidityKbar) were not edited this iter.

## Output

Per the checker descriptor: bidirectional per-file report. Write to
`task_results/lean-vs-blueprint-checker-g0bo-iter169.md`.
