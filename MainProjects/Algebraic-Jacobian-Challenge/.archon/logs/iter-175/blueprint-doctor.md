# Blueprint Doctor

## Chapter coverage problems (`% archon:covers`)

A chapter's `% archon:covers <file> ...` declaration tells the prover-dispatch gate which Lean files that chapter blueprints. The issues below would route the gate to the wrong chapter — fix the declaration (correct the path, or make exactly one chapter own each file).

- chapter `Albanese_AlbaneseUP.tex` covers `AlgebraicJacobian/Albanese/AlbaneseUP.lean`, which does not exist
- chapter `Albanese_CodimOneExtension.tex` covers `AlgebraicJacobian/Albanese/CodimOneExtension.lean`, which does not exist
- chapter `Picard_FGAPicRepresentability.tex` covers `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`, which does not exist
- chapter `Picard_FlatteningStratification.tex` covers `AlgebraicJacobian/Picard/FlatteningStratification.lean`, which does not exist
- chapter `Picard_QuotScheme.tex` covers `AlgebraicJacobian/Picard/QuotScheme.lean`, which does not exist
- chapter `Picard_RelPicFunctor.tex` covers `AlgebraicJacobian/Picard/RelPicFunctor.lean`, which does not exist
- chapter `RiemannRoch_OCofP.tex` covers `AlgebraicJacobian/RiemannRoch/OCofP.lean`, which does not exist
- chapter `RiemannRoch_RationalCurveIso.tex` covers `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`, which does not exist

## Malformed annotations

Annotations with an empty argument (`\uses{}`, `\proves{}`, `\label{}`, `\ref{}`, ...) or an empty list item (`\uses{a,,b}`, `\uses{a,}`). plastex emits `Label '' could not be resolved` for each of these and then the leanblueprint depgraph builder enters infinite recursion (`RecursionError`), so the blueprint never finishes building. Fix each one by either filling in the intended label or deleting the empty annotation. Do NOT defer — the next `leanblueprint web` run will crash until these are resolved.

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- `\uses{...}` — empty argument

