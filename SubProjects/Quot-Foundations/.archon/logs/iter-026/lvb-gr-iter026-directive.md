# lean-vs-blueprint-checker — GrassmannianCells (iter-026)

Compare exactly one Lean file against its blueprint chapter, bidirectionally.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

This iter the prover added 11 axiom-clean declarations (0 sorry) building the scheme-level
transition layer toward `Grassmannian.scheme` (the GlueData): `minorDet_self`, `chartOverlap`,
`chartIncl`, `chartIncl_isOpenImmersion`, `chartIncl_self_isIso`, `chartTransition`,
`chartTransition_self`, `awayPullbackIso`, `awayPullbackIso_inv_fst/_snd`, `awayMulCommEquiv`.
The final `Scheme.GlueData` (`t'`, `t_fac`, `cocycle`, `.glued`) was NOT built.

Verify:
- Do these new Lean declarations have blueprint blocks, or are they uncovered `lean_aux` nodes
  the chapter must add? (They feed the still-unformalized `def:gr_glued_scheme`.)
- Are the statements faithful (no placeholders), and are Mathlib-backed anchors like
  `pullbackSpecIso`, `IsLocalization.atUnit`, `instIsOpenImmersionMapOfHomAwayAlgebraMap`
  candidates for `\mathlibok` anchors?
- Is the chapter adequate to guide the next GlueData build, including the product-order
  subtlety (`awayMulCommEquiv` as `orderSwap`)?

Report to your task_results file.
