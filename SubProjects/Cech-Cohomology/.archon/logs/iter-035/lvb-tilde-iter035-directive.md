# lean-vs-blueprint-checker directive — TildeExactness (iter-035)

Verify ONE Lean file against its blueprint chapter, bidirectionally.

## Lean file (absolute path)
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/TildeExactness.lean

## Blueprint chapter (absolute path)
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

The relevant blueprint block is `lem:tilde_preserves_kernels` (around line 4328). The named target
`tildePreservesFiniteLimits` is NOT in Lean (prover left it absent — it is a multi-decl categorical
build blocked on the absent `Scheme.Modules.toSheaf` / jointly-reflecting-stalk assembly).

This iter the prover appended 4 axiom-clean helper decls realizing sub-step (A) of the mechanization:
- `tilde_germ_algebraMap_smul` (germ is R-linear)
- `stalkMapₗ` (the Ab-stalk map packaged as an R-LINEAR map — its `map_smul'` field is the new content)
- `stalkMapₗ_eq` (identifies stalkMapₗ with the localised module map IsLocalizedModule.map)
- `stalkMapₗ_injective` (stalkwise injectivity for a mono)

## What to check
1. Lean → blueprint: do these 4 helpers faithfully realize the sub-steps the blueprint sketch claims
   for `lem:tilde_preserves_kernels`? Any vacuous/placeholder statement? Is `stalkMapₗ_eq` a genuine
   identification or a tautology?
2. blueprint → Lean: is the `lem:tilde_preserves_kernels` sketch detailed enough to guide the
   REMAINING build (the named target)? The prover reported the sketch needs the natural-iso packaging
   of the stalk composite + localisation-is-flat + jointly-reflecting stalk lift, and flagged that
   `Scheme.Modules.toSheaf` does not exist. Is the chapter under-specified for that remaining work
   (missing sub-steps, no mention of the toSheaf gap)?
3. The 4 helper decls have NO blueprint block (not in any `\lean{}` list). Note as coverage debt.
4. Confirm the named target's absence is honestly documented (no false `\leanok`/`\mathlibok` on
   `tildePreservesFiniteLimits`).

Report must-fix-this-iter findings explicitly.
