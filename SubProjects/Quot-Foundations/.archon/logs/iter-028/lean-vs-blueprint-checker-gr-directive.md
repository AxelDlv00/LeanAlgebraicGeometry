# lean-vs-blueprint-checker directive — iter-028 — GrassmannianCells

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

## Context for this check
This iter the prover added four axiom-clean decls toward the glue data `def:gr_glued_scheme`:
`chartTransition'` (the `t'` field), `chartTransition'_fac` (the `t_fac` field),
`chartTransition'_ringIdentity` (ring content of `t_fac`), and a helper
`awayMulCommEquiv_comp_algebraMap`. The `cocycle` field, `theGlueData`, and
`Grassmannian.scheme` are NOT yet built (handed off; categorical reduction documented in an
end-of-file `HANDOFF` comment, residual is a rotated `cocycleCondition` ring identity).

Check:
- Do the four new decls have corresponding blueprint blocks / `\lean{...}` anchors, or are they
  unmatched `lean_aux` nodes? (Confirm and name suggested labels — the chapter describes `t'`
  and `t_fac` in prose under `def:gr_glued_scheme` but may lack dedicated `\lean{}` anchors.)
- Does `def:gr_glued_scheme`'s field map match the Lean (`t' := chartTransition'`,
  `t_fac := chartTransition'_fac`, etc.)? Any signature mismatch?
- Is the chapter honest that `cocycle`/`theGlueData`/`scheme` are not yet formalized?

Report Lean→blueprint and blueprint→Lean findings with severity.
