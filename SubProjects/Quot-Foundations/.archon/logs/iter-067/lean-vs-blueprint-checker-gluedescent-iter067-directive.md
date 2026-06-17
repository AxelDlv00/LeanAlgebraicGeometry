# Lean vs Blueprint Checker Directive

## Slug
gluedescent-iter067

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GlueDescent.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianQuot.tex

## Notes
- `GlueDescent.lean` is NEW this iter: the generic `Scheme.Modules` glue/descent layer was split out of `GrassmannianQuot.lean`; its blueprint blocks (glue, glueLift, glueRestrictionIso, keystone `isIso_glueRestrictionHom`, β_ij `glueOverlapBaseChangeIso`) still live in the GrassmannianQuot chapter. There is no `% archon:covers` marker yet — note this as a mapping gap, not laundering.
- The split crashed mid-move; a prover applied two mechanical compile fixes (import + `eqToIso ... .symm` at ~L1166). Verify the moved declarations still match their chapter statements and that nothing was silently re-stated during the move.
- 2 expected sorries: ~L1170 (ext-V condition in `glueOverlapBaseChangeIso`) and ~L1207 (`isIso_glueRestrictionHom`).
