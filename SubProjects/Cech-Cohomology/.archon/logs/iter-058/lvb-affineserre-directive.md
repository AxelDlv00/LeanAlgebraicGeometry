# Lean-vs-blueprint check — AffineSerreVanishing.lean

Verify ONE Lean file against its blueprint chapter, bidirectionally.

Lean file: /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean
Blueprint chapter: /home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
  (consolidated chapter; this file is one of its `% archon:covers` entries)

Report:
- Lean → blueprint: are there fake/placeholder/vacuous statements? Do the new decls
  `affine_tildeVanishing_general` and `affine_serre_vanishing_general_open` match the blueprint
  labels `lem:affine_serre_vanishing_general_open` (and the seed `lem:affine_cech_vanishing_general_seed`)?
- blueprint → Lean: is the chapter detailed enough to have guided this formalization, or is it too thin?
  Are the `\lean{...}` pins correct for the new decls?
- Flag any must-fix-this-iter findings.
