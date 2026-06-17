# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- This iter closed exactly one target: `base_change_mate_unit_value` (Seam 1,
  `lem:base_change_mate_unit_value`), now `sorry`-free and axiom-clean
  (`{propext, Classical.choice, Quot.sound}`). Verify the landed proof's mathematical content
  matches the chapter's Seam-1 sketch.
- Three seams remain as honest typed `sorry`s: `base_change_mate_fstar_reindex` (Seam 2),
  `base_change_mate_gstar_transpose` (Seam 3), plus `affineBaseChange_pushforward_iso` and
  `flatBaseChange_pushforward_isIso` (FBC-B, deferred). These are openly-disclosed scaffolding —
  do NOT flag each remaining `sorry` as a surprise placeholder; flag only mismatches between a
  declaration's signature and the chapter prose, or chapter blocks too thin to have guided the
  Seam-1 proof that was just formalized.
- Legacy cross-project STATUS comments referencing iter-234/236/240/241 are known stale.
