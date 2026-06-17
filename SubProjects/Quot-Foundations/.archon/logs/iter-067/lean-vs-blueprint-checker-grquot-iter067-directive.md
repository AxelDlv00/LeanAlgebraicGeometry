# Lean vs Blueprint Checker Directive

## Slug
grquot-iter067

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianQuot.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Notes
- This iter closed `grPointOfRankQuotient_rel` (blueprint label likely under the Nitsure-inverse section) via a new transport chain; verify the formal proof matches the chapter's informal route and that `\lean{}` pins resolve.
- ~18 new helper declarations (scalarEnd_unitEndSection … chartMatrix_minor) have NO blueprint blocks yet (a coverage writer was killed before writing) — report them as missing-coverage, not as laundering.
- Sorried decls in file: `tautologicalQuotient_epi`, `chartLocus_isOpenCover`, `isIso_pullback_isoLocus_map`, the overlap argument inside `grPointOfRankQuotient`, two `represents` inverse laws. Statement-`\leanok` on sorried decls is documented project semantics.
