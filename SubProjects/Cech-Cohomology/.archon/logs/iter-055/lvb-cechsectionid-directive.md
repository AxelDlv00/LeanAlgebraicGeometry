# lean-vs-blueprint — CechSectionIdentification.lean

Verify one Lean file against its blueprint chapter, bidirectionally.

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; this file is declared under `% archon:covers .../CechSectionIdentification.lean`.
The relevant blueprint declarations are the "Sub-brick A" chain, blueprint labels
`lem:cech_backbone_left_sigma` through `lem:cechSection_contractible`.)

## Context
This file was scaffolded this iter (iter-055) as the shared "Sub-brick A" extraction recommended in
the iter-054 review. It contains 6 `sorry`-stubbed `noncomputable def`s with rich planner-strategy
comments: `cechBackbone_left_sigma`, `pushPull_sigma_iso`, `pushPull_leg_sections`,
`pushPull_eval_prod_iso`, `cechSection_complex_iso`, `cechSection_contractible`.

NOTE: the file currently does NOT compile (missing opens for `Scheme.Modules`/`Over`/`evaluation`,
`∏` vs `∏ᶜ` at line 126). Assess the SIGNATURES against the blueprint regardless — your job is whether
the 6 stub statements faithfully match the blueprint's Sub-brick A decomposition.

## Report
(a) Do the 6 stub signatures match the blueprint's Sub-brick A lemma statements (each `\lean{}` target
    present and correctly typed)? (b) Is the blueprint Sub-brick A chain detailed enough to guide
    formalizing each stub, or too thin? (c) Any stub whose statement looks mathematically wrong or
    mis-scoped relative to the blueprint? Flag must-fix-this-iter items explicitly.
