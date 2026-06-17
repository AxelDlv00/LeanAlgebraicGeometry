# lean-vs-blueprint-checker directive — iter-222

Verify ONE Lean file against its blueprint chapter, bidirectionally.

- Lean file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
- Blueprint chapter: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

This iter the prover worked on the evaluation morphism `internalHomEval`
(blueprint `lem:internal_hom_eval`) and added supporting lemmas
`internalHomEvalApp_tmul` and `restr_map_homMk`.

Check specifically:
- Does `lem:internal_hom_eval`'s `\lean{...}` pin name the actually-built decl
  (`PresheafOfModules.internalHomEval`)? `internalHomEval` currently carries a typed
  `sorry` in its naturality field — confirm the chapter does NOT present it as a
  completed/closed result (no fake/weakened statement).
- Are the newly-added supporting lemmas (`internalHomEvalApp_tmul`, `restr_map_homMk`)
  adequately reflected in the chapter, or are they purely Lean-internal helpers with no
  blueprint counterpart (acceptable, but note it)?
- Bidirectional: is the chapter detailed enough to have guided this formalization, or is
  any sub-step under-specified for the NEXT prover round (closing the naturality sorry)?

Report bidirectionally with any must-fix-this-iter findings. Write to task_results/.
