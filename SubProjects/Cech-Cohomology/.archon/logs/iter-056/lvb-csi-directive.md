# Lean ↔ Blueprint Checker Directive

## Slug
csi

## Lean file
/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

## Blueprint chapter
/home/archon/proj/Cech-Cohomology/blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
(consolidated chapter; it carries `% archon:covers ... CechSectionIdentification.lean` near its top.)

## Focus
This file holds the "Sub-brick A" extraction: 6 stubs identifying the evaluated augmented Čech section
complex with a concrete complex. This iter closed Stub 3 (`pushPull_leg_sections`) and added a NOTE
block claiming Stubs 5 and 6 are MIS-SPECIFIED (provably false as written): the consumer needs the
AUGMENTED section complex `D'_aug`, not the non-augmented `sectionCechComplex`. Verify against the
blueprint: (a) does the blueprint's Sub-brick A chapter specify Stubs 5/6 as `D ≅ D'` and
`Homotopy (𝟙 D') 0` (the allegedly-false forms), and if so is the blueprint itself the source of the
mis-specification that should be re-written? (b) does `pushPull_leg_sections` match its blueprint
block? (c) is the corrected `D'_aug` decomposition (augmentation by Γ(V,F)) reflected anywhere in the
blueprint yet, or is it pure coverage debt? Report bidirectionally — the blueprint may be the failure.
