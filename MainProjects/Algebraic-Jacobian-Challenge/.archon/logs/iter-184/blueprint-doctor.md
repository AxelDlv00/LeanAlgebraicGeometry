# Blueprint Doctor

## Chapter coverage problems (`% archon:covers`)

A chapter's `% archon:covers <file> ...` declaration tells the prover-dispatch gate which Lean files that chapter blueprints. The issues below would route the gate to the wrong chapter — fix the declaration (correct the path, or make exactly one chapter own each file).

- chapter `Picard_IdentityComponent.tex` covers `AlgebraicJacobian/Picard/IdentityComponent.lean`, which does not exist

## Broken cross-references

These `\ref{...}` / `\uses{...}` / `\cref{...}` (etc.) calls point at labels that no `\label{...}` defines anywhere in the included tex tree. The dependency graph rendered by leanblueprint will draw a missing edge for each. Common causes: label typos (case mismatch, plural/singular), labels moved to an orphan chapter, or copy-paste of `\uses{...}` lists that weren't updated when targets renamed.

### `blueprint/src/chapters/AbelianVarietyRigidity.tex`
- `\cref{thm:rigidity_genus0_curve_to_AV}` — no matching `\label`

### `blueprint/src/chapters/Albanese_AlbaneseUP.tex`
- `\cref{thm:rigidity_genus0_curve_to_AV}` — no matching `\label`

