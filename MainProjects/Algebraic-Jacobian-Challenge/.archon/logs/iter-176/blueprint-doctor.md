# Blueprint Doctor

## Chapter coverage problems (`% archon:covers`)

A chapter's `% archon:covers <file> ...` declaration tells the prover-dispatch gate which Lean files that chapter blueprints. The issues below would route the gate to the wrong chapter — fix the declaration (correct the path, or make exactly one chapter own each file).

- chapter `Albanese_AlbaneseUP.tex` covers `AlgebraicJacobian/Albanese/AlbaneseUP.lean`, which does not exist
- chapter `Albanese_CodimOneExtension.tex` covers `AlgebraicJacobian/Albanese/CodimOneExtension.lean`, which does not exist
- chapter `RiemannRoch_RationalCurveIso.tex` covers `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`, which does not exist

