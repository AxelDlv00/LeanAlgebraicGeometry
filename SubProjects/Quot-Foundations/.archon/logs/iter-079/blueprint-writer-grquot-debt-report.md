# Blueprint Writer Report: grquot-debt
**Status:** COMPLETE

## Changes (Picard_GrassmannianQuot.tex only)
- Rewrote `lem:chartLocus_isOpenCover` PROOF: now describes formalized affine-projective-splitting route (global split on affine W via `exists_rightInverse_of_epi_matrixEndRect` → residue-field minor via `exists_isUnit_submatrix` → basic open `W_{P_I}`). Removed stale `% NOTE (review iter-078)`. Kept SOURCE/SOURCE QUOTE/`\textit{Source}` verbatim.
- STATEMENT `\uses`: removed `lem:isIso_pullback_isoLocus_map`. PROOF `\uses`: added `def:isoLocus` (+ `def:gr_matrixEndRect`, the two helper lems, to wire edges).
- Added subsection "Matrix-calculus toolbox" before `def:gr_matrixEndRect` with all 15 helper blocks (`lem:gr_*`, `def:gr_presentedMatrix`), each with `\lean{AlgebraicGeometry.Grassmannian.*}` (verified names/signatures against Lean) + accurate `\uses`. Archon-original (no SOURCE lines). No `\leanok`.
- Deps without an existing block (ιFree_*, unitEndSection_*, isColimitFreeCofan, Mathlib tilde/projectivity, Scheme.isoSpec, Matrix.* LA) omitted per directive; cross-refs use only existing/new labels.

## Verify
- leandag: 0 unknown_uses; none of the 15 new blocks (nor chartLocus_isOpenCover) isolated. begin/end balanced (142/142).
