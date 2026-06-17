## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Task
Bidirectional check. This iter the prover closed the `grPointOfRankQuotient` overlap-compatibility sorry via new lemma `chartMorphism_glue_compat` + ~11 supporting lemmas (comp_chartMorphism, presentedMatrix_comp, chart_point_eq, universalMatrix_map_presentedMatrix, imageMatrix_map_ringHom, chartComposite_rqPullback, etc.). Report: (a) Lean decls lacking a blueprint block (1-to-1 debt — list them); (b) any signature/statement mismatch with \lean{} pins; (c) verify reported "broken pins" actually resolve (iter-078 had false positives from positional grep after decl relocation — decls moved below the conjPullback transport block this iter too). Read-only.
