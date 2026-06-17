# Blueprint Doctor

## Chapter coverage problems (`% archon:covers`)

A chapter's `% archon:covers <file> ...` declaration tells the prover-dispatch gate which Lean files that chapter blueprints. The issues below would route the gate to the wrong chapter — fix the declaration (correct the path, or make exactly one chapter own each file).

- chapter `Cohomology_CechHigherDirectImage.tex` covers `AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean`, which does not exist

## Broken cross-references

These `\ref{...}` / `\uses{...}` / `\cref{...}` (etc.) calls point at labels that no `\label{...}` defines anywhere in the included tex tree. The dependency graph rendered by leanblueprint will draw a missing edge for each. Common causes: label typos (case mismatch, plural/singular), labels moved to an orphan chapter, or copy-paste of `\uses{...}` lists that weren't updated when targets renamed.

### `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
- `\ref{lemma-cech-cohomology-quasi-coherent}` — no matching `\label`
- `\ref{lemma-cech-cohomology-quasi-coherent-trivial}` — no matching `\label`
- `\ref{lemma-flat-base-change-cohomology}` — no matching `\label`
- `\ref{lemma-quasi-coherence-higher-direct-images-application}` — no matching `\label`
- `\ref{lemma-quasi-coherent-affine-cohomology-zero}` — no matching `\label`

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- `\uses{\leanok
    thm:relative_pic_quotient_well_defined}` — no matching `\label`

