# Lean Auditor Directive

## Slug
iter029

## Scope (files)
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean

## Focus areas (optional)
- FlatBaseChange.lean around lines 1410–1450 (a large boxed diagnosis comment was just
  rewritten at the `_legs` sorry site) and lines 1838–1912 (two docstrings were just edited
  from "this theorem is sorry-free" to "transitively sorry-backed"). Verify the new comments
  are accurate about the code below them and contain no excuse-comments / false-completion claims.
- QuotScheme.lean around lines 710–760: one new public theorem
  `exists_finite_basicOpen_cover_le_quasicoherentData` plus a possible
  `exists_finite_basicOpen_cover_of_isQuasicoherent` corollary — verify the proofs are genuine
  (no fake bodies, no laundering) and the surrounding comments are accurate.

## Known issues
- 4 protected typed `sorry` stubs in QuotScheme.lean (@126/165/201/228) are intentional skeleton
  placeholders — do not re-report them as suspect bodies.
- 4 active `sorry` in FlatBaseChange.lean (`_legs` ~1446, `gstar_transpose` ~1818, affine ~1999,
  FBC-B ~2021) are known open targets — report only if their surrounding comments mislead.
