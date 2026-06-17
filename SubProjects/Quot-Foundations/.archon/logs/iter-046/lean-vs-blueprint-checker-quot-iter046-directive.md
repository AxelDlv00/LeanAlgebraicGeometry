# lean-vs-blueprint-checker — QuotScheme iter-046

## Lean file
`/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean`

## Blueprint chapter
`/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex`

## Scope
Two decls added this iter:
- `annihilator_map_basicOpen` (~L2728) — has NO dedicated blueprint block (only prose inside
  `def:modules_annihilator`); flag the missing block.
- `annihilator_ideal` (~L2761) — blueprint `lem:modules_annihilator_ideal` (~L2413). KNOWN deviation:
  Lean takes a GLOBAL `hfin : ∀ V, Module.Finite Γ(X,V) Γ(F,V)`; blueprint states a single-`U`
  finiteness hypothesis. A `% NOTE:` already documents this. Report bidirectionally: does the Lean
  faithfully formalize a (corrected) statement, and is the blueprint statement/proof adequate or does
  it still mis-state the hypothesis / contain the false "section = infimum of comaps" proof step.

## Output
Bidirectional report (Lean→blueprint and blueprint→Lean) with must-fix / major / minor severities.
