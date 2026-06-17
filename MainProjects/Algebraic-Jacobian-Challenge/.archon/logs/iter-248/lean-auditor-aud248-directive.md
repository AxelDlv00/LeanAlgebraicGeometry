# Lean Auditor Directive

## Slug
aud248

## Scope (files)
Two files received edits this iter; audit these as Lean:
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean
- /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/RelPicFunctor.lean

## Focus areas
- TensorObjSubstrate.lean: the newly-added decls near the `LocTrivPullbackTensor` section tail (`compHomEquivFactor`, `sheafificationCompPullback_eq_leftAdjointUniq`, `leftAdjointUniqUnitEta`, `pullbackEtaUnitSquare`, `pullbackTensorMap_unit_isIso`). Check proof bodies are reasonable Lean (not syntax-manipulation dead-ends), and that comments around the single `sorry` (~L1672) are accurate, not excuse-comments.
- RelPicFunctor.lean: this iter rewrote 7 docstrings. Verify the new docstrings are ACCURATE about the code below them (the file should have 0 file-local sorry; `addCommGroup` a real body; `PicSharp`/`functorial` deliberate stubs). Flag any remaining excuse-comment or any docstring still asserting a false "file-local addCommGroup sorry" / "Scheme.Modules monoidal-upgrade gate".

## Known issues (do not re-report)
- The `sorry` at TensorObjSubstrate.lean L1672 (the (∗∗) residual in `pullbackEtaUnitSquare`) and L692 (`exists_tensorObj_inverse`) are intentional, tracked residuals — not placeholders to flag.
- Deprecated `CategoryTheory.Sheaf.val` warnings (project-wide) and the L465 prose-comment containing the word "opaque" are known/benign.
- `PicSharp` = const `PUnit` and `functorial` = zero hom in RelPicFunctor.lean are deliberate stubs gated cross-file on Lane TS D4′ — flag ONLY if a docstring lies about them; do not flag the stubs themselves.
