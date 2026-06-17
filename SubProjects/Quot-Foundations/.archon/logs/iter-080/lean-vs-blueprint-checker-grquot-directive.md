# lean-vs-blueprint-checker — grquot (iter080)

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Context
Prover closed 2 sorries this iter (3→1): the `represents` inverse laws / `grPointOfRankQuotient` tautological-pullback bridges and `universalQuotient_isLocallyFreeOfRank`. Residual `sorry` = `tautologicalQuotient_epi` (line ~2470, honestly open). blueprint-writer `grquot-univ` ran this iter on this chapter.

Report bidirectionally: (a) Lean-follows-blueprint (no fake statements, `\lean{}` pins match, proofs follow sketches); (b) blueprint adequacy + new Lean helpers lacking blocks. Flag broken `\uses{}`. The residual `tautologicalQuotient_epi` sorry being under a `\leanok` *statement* block is legitimate (decl exists) — verify proof block is unmarked before flagging. Verify `\lean{}` pins resolve (decls were relocated in prior iters) before calling them broken.
