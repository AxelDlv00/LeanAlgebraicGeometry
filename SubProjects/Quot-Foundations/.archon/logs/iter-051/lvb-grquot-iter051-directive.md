# lean-vs-blueprint-checker — GrassmannianQuot iter-051

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Focus
- New Lean decls: `scalarEnd_one`, `scalarEnd_zero` (helpers, no blueprint block), `chartQuotientMap_ιFree`
  (private), `chartQuotientMap_epi` (lem:gr_chartQuotientMap_epi).
- `Scheme.Modules.glue` (def:scheme_modules_glue) signature now carries cocycle hyp C1 (`_hC1`) but NOT C2 — does
  the blueprint def list both C1 and C2? Flag whether the Lean signature is faithful or whether C2's absence needs
  a % NOTE. Verify the 5 scaffold `sorry` decls (`glue`,`universalQuotient`,`tautologicalQuotient`,`functor`,
  `represents`) match their blueprint statements (honest scaffolds, not fake).

## Output
Bidirectional findings with severity; name any % NOTE / blueprint-writer fix needed.
