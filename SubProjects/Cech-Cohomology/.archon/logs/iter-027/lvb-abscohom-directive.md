# Lean ↔ blueprint check — AbsoluteCohomology.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; `% archon:covers … AbsoluteCohomology.lean`). The relevant new block this
iter is `lem:absolute_cohomology_zero_natural` (naturality of H⁰≅Γ in the coefficient sheaf),
pinned to `\lean{AlgebraicGeometry.absoluteCohomologyZeroAddEquiv_naturality}`.

## What to check
- Does `absoluteCohomologyZeroAddEquiv_naturality` faithfully realize the blueprint statement
  `lem:absolute_cohomology_zero_natural`? The Lean uses bottom arrow
  `g_U = ConcreteCategory.hom (((toPresheafOfModules X).map g).app (op U))` and top arrow
  `e.comp (Ext.mk₀ g) (add_zero 0)`. Confirm the blueprint prose matches this realization (no
  signature drift, no weaker statement).
- The 4 private helpers (`homEquiv₀_comp_mk₀`, `freeYonedaHomEquiv_naturality`,
  `sheafificationHomAddEquiv_naturality`, `jShriekOU_homEquiv_naturality`) have NO blueprint block
  — report them as coverage debt (the planner will bundle them).
- Blueprint → Lean: is the chapter detailed enough to have guided this proof, or too thin?

Report bidirectionally with must-fix / red-flag tags. Note `\mathlibok` anchors if any need adding.
