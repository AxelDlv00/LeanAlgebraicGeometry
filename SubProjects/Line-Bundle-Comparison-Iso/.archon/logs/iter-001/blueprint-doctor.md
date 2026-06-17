# Blueprint Doctor

## Broken cross-references

These `\ref{...}` / `\uses{...}` / `\cref{...}` (etc.) calls point at labels that no `\label{...}` defines anywhere in the included tex tree. The dependency graph rendered by leanblueprint will draw a missing edge for each. Common causes: label typos (case mismatch, plural/singular), labels moved to an orphan chapter, or copy-paste of `\uses{...}` lists that weren't updated when targets renamed.

### `blueprint/src/chapters/Picard_LineBundlePullback.tex`
- `\cref{chap:Jacobian}` — no matching `\label`
- `\cref{chap:Picard_RelativeSpec}` — no matching `\label`

### `blueprint/src/chapters/Picard_RelPicFunctor.tex`
- `\cref{chap:Picard_FGAPicRepresentability}` — no matching `\label`
- `\cref{chap:Picard_RelativeSpec}` — no matching `\label`

### `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`
- `\cref{chap:Albanese_AlbaneseUP}` — no matching `\label`
- `\cref{chap:Picard_FGAPicRepresentability}` — no matching `\label`
- `\cref{chap:Picard_IdentityComponent}` — no matching `\label`

