## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentificationLeg.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; this file is covered under it. Relevant labels: lem:pushPull_leg_sections,
lem:coreIso_comm_leg, the backbone/Stub-1 paragraph, and the push-pull leg material.)

## Task
Bidirectional check. (a) Do the Leg file's statements match the blueprint (no fake/placeholder
statements, signatures agree with \lean{} hints)? (b) Is the chapter detailed enough to guide the
remaining sorry `pushPull_interLegHom_sections` (Leg ~1012, per-leg restriction naturality / sheaf
seam)? Note: many Leg helpers (backboneIncl_proj, backboneIncl_nerveδ, entry_chain, glue_chain,
interProj, overWPproj, pushPull_interLegHom_sections, etc.) have NO blueprint block — report this as
coverage debt direction Lean→blueprint.
