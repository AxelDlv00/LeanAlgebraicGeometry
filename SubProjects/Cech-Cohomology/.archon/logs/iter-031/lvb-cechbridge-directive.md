# Lean-vs-blueprint — CechBridge.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechBridge.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(this chapter is the consolidated `% archon:covers` chapter for the Cohomology/ Lean files)

## Focus
This iter added a family-parameterized bridge chain (10 `…Fam` decls), notably the two NAMED targets
`sectionCechComplexMapOpIsoFam` and `injective_cech_acyclicFam`. The planner pre-pinned these two names
into existing blueprint `\lean{}` lists (`lem:section_cech_complex_mapop_iso`, `lem:injective_cech_acyclic`).
Confirm: (a) the Lean statements match the pinned blueprint statements (cover-agnostic, no covering hyp);
(b) the 8–9 supporting `…Fam` helpers (homCech*Fam etc.) — report whether they have blueprint coverage or
are unmatched `lean_aux` (the planner needs to bundle their names); (c) no fake/placeholder statements.
Report bidirectionally (Lean→blueprint and blueprint→Lean).
