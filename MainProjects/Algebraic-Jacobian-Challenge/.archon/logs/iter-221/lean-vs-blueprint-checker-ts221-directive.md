# lean-vs-blueprint-checker directive — iter-221

## Lean file

`AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Blueprint chapter

`blueprint/src/chapters/Picard_TensorObjSubstrate.tex`

## Task

Bidirectional verification for THIS file/chapter pair only (no global context):

1. **Lean → blueprint.** The prover added 6 declarations this iter:
   `PresheafOfModules.dual` (`def:presheaf_dual`), `InternalHom.termRingMap_terminal`,
   `InternalHom.evalLin`, `evalLin_add`, `evalLin_smul`, and
   `InternalHom.internalHomEvalApp` (the per-object evaluation; pinned, if anywhere,
   under `lem:internal_hom_eval`). Confirm the `\lean{...}` pins resolve to the actual
   declaration names, and that the blueprint statements faithfully describe what the
   Lean proves (no fake/placeholder/weakened statements).

2. **Blueprint → Lean.** The FULL natural evaluation morphism `internalHomEval`
   (`M ⊗ M^∨ ⟶ R`) is NOT yet built — only the per-object `internalHomEvalApp`. Check
   whether `lem:internal_hom_eval` (or whatever block names the eval) is adequately
   specified for the next prover round to assemble the natural morphism, OR whether it
   conflates the per-object map with the natural transformation. If the chapter is too
   thin / ambiguous for the next sub-step, say so (blueprint-as-failure is in scope).

3. Note any `\lean{}` name mismatch that needs a review-agent correction, and whether
   `def:presheaf_internal_hom`'s pin still needs repointing to the `InternalHom.`
   namespace (carryover item).

Report must-fix-this-iter items separately from soft findings.
