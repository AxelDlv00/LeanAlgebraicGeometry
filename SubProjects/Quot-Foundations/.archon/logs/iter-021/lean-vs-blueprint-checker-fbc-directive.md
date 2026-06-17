# Lean ↔ Blueprint Checker Directive

## Slug
fbc

## Lean file
/home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

## Blueprint chapter
/home/archon/proj/Quot-Foundations/blueprint/src/chapters/Cohomology_FlatBaseChange.tex

## Known issues
- `base_change_mate_gstar_transpose` is PARTIAL this iter (a `rw` reframing + route
  comments landed; the proof still carries a `sorry`). Confirm the chapter's
  proof sketch for `lem:base_change_mate_gstar_transpose` is adequate to guide the
  remaining counit-conjugate close, and that the in-file route comments match the
  blueprint. Don't re-report the `sorry` itself as a defect — report whether the
  chapter is detailed enough.
- The Seam-2 `fstar_reindex` / `fstar_reindex_legs` apparatus is DEAD CODE
  (route-swapped iter-020, orphaned, referenced only in comments). Its blueprint
  blocks were marked superseded. Flag only if the chapter still presents it as a
  live dependency of a proved result.
