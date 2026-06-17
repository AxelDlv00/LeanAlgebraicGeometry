# lean-vs-blueprint-checker — GrassmannianQuot iter-056

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

Verify bidirectionally. Pay attention to:
- `Scheme.Modules.glue` closed as an equalizer-of-pushforwards, NOT the blueprint's hand-built gluePresheaf/gluePresheafModule/gluePresheafIsSheaf route. Does the blueprint still describe the abandoned hand-built presheaf? If so, flag the mismatch (the Lean took a different, valid route).
- The cocycle hyps `_hC1`/`_hC2` are unused in the `glue` object. Is that faithful to the blueprint?
- Remaining sorries universalQuotient/tautologicalQuotient/represents and the GL_d bundle cocycle route — blueprinted?
