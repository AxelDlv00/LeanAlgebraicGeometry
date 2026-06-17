# Blueprint-clean directive

## Chapter to purify
`blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

## Context
A blueprint-writer round (slug `coverage-debt`, iter-047) just added two new `\begin{lemma}` blocks
(`lem:tileReconcileEquiv`, `lem:isScalarTower_restrictScalars_obj`), bundled 3 private helper names
into existing `\lean{...}` lists, and fixed two `\uses{}` edges on `lem:tile_section_localization`.

## Your job
Strip any Lean leakage (tactic strings, raw Lean syntax beyond the `\lean{}`/`\uses{}` pins,
project-history verbosity) introduced ONLY by the two new blocks and the edited `\uses{}` lines.
The two new blocks describe a `ModuleCat.restrictScalars` carrier and an `IsScalarTower` instance —
ensure the prose is mathematical (restriction of scalars along `R → R_g`, scalar-tower), not a
restatement of Lean instance-synthesis mechanics. Do NOT add or remove `\leanok`. Do NOT touch
markers, the kernel-comparison block, or the keystone block. Validate that any source-quote
discipline already present in the chapter is untouched.

## Scope
Only the iter-047 writer's additions/edits. Do not rewrite untouched blocks.
