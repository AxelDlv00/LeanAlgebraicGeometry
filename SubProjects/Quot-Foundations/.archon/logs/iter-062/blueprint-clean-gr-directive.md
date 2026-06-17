# blueprint-clean directive

## Target
`blueprint/src/chapters/Picard_GrassmannianQuot.tex` — only the L3-split region just
edited by the effort-breaker: the three new blocks `lem:gr_scalarEnd_pullback`,
`lem:gr_matrixEnd_pullback`, `lem:gr_baseChange_bridge`, and the rewritten residual
`lem:gr_bundleCocycle_transport`.

## Action
Purity pass on those four blocks only: strip any Lean tactic syntax / Lean-elaboration
detail (the math is project-bespoke infra — pullback naturality + ΓSpecIso bridge);
remove project-history / iter-narrative verbosity; confirm each statement is math-only
prose precise enough to formalize. These are Archon-original infra blocks (no external
source), so no `% SOURCE`/`% SOURCE QUOTE` lines are required — do NOT invent any.

## Constraints
- Do NOT add/remove `\leanok` or `\mathlibok`.
- Do NOT touch any other chapter or any block outside the four named above.
- Keep all `\lean{}` forward pins and `\uses{}` edges intact (the prover builds the three
  new decls this iter; the pins are intentional).
